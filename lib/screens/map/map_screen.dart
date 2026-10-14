import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../app/theme.dart';
import '../../config/app_config.dart';
import '../../data/locations.dart';
import '../../models/location_model.dart';
import '../../models/progress_model.dart';
import '../../providers/providers.dart';
import '../../services/gps_service.dart';
import '../../services/navigation_service.dart';
import '../../widgets/map/status_style.dart';
import '../home/home_shell.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _map = MapController();
  bool _tilesFailed = false;
  bool _locating = false;
  bool _legendOpen = false;

  void _onTileError() {
    if (_tilesFailed) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _tilesFailed = true);
    });
  }

  Future<void> _locate() async {
    setState(() => _locating = true);
    final (fix, error) = await ref
        .read(gpsServiceProvider)
        .currentFix(simulated: ref.read(simulatedPositionProvider));
    if (!mounted) return;
    setState(() => _locating = false);
    if (fix == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            GpsService.message(
              GpsCheckResult(error ?? GpsOutcome.unavailable),
              group: ref.read(progressProvider).isGroup,
            ),
          ),
        ),
      );
      return;
    }
    ref.read(lastFixProvider.notifier).set(fix);
    _map.move(LatLng(fix.latitude, fix.longitude), 15);
  }

  void _fitRoute(List<LatLng> points) => _map.fitCamera(
    CameraFit.bounds(
      bounds: LatLngBounds.fromPoints(points),
      padding: const EdgeInsets.all(56),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final route = ref.watch(selectedRouteProvider);
    final p = ref.watch(progressProvider);
    final fix = ref.watch(lastFixProvider);
    if (route == null) return const SizedBox.shrink();

    final locs = [
      for (final id in route.locationIds)
        if (locations[id] != null) locations[id]!,
    ];
    final points = [for (final l in locs) l.position];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kaart'),
        actions: [
          IconButton(
            tooltip: 'Hele route in beeld',
            icon: const Icon(Icons.zoom_out_map),
            onPressed: () => _fitRoute(points),
          ),
          const SettingsAction(),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _map,
            options: MapOptions(
              initialCameraFit: CameraFit.bounds(
                bounds: LatLngBounds.fromPoints(points),
                padding: const EdgeInsets.all(56),
              ),
              minZoom: 10,
              maxZoom: 18,
              backgroundColor: AppColors.paperDark,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: AppConfig.mapUserAgentPackage,
                errorTileCallback: (_, _, _) => _onTileError(),
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: points,
                    color: AppColors.green.withValues(alpha: 0.8),
                    strokeWidth: 4,
                    pattern: StrokePattern.dashed(segments: const [14, 8]),
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  for (var i = 0; i < locs.length; i++)
                    Marker(
                      point: locs[i].position,
                      width: 52,
                      height: 52,
                      child: _LocationMarker(
                        number: i + 1,
                        status: p.statusOf(locs[i].id, route),
                        title: locs[i].title,
                        onTap: () => _showPreview(
                          locs[i],
                          p.statusOf(locs[i].id, route),
                        ),
                      ),
                    ),
                  if (fix != null)
                    Marker(
                      point: LatLng(fix.latitude, fix.longitude),
                      width: 28,
                      height: 28,
                      child: Semantics(
                        label: 'Jouw positie',
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2F6FB2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: const [
                              BoxShadow(blurRadius: 6, color: Colors.black26),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const RichAttributionWidget(
                alignment: AttributionAlignment.bottomRight,
                attributions: [
                  TextSourceAttribution('OpenStreetMap-bijdragers'),
                ],
              ),
            ],
          ),
          if (_tilesFailed)
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: Material(
                color: AppColors.anthracite,
                borderRadius: BorderRadius.circular(10),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.cloud_off, color: Colors.white),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'De kaart kan niet worden geladen (geen internet?). '
                          'Locaties, opdrachten en het missieboek werken wel.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            left: 12,
            bottom: 12,
            child: _Legend(
              open: _legendOpen,
              onToggle: () => setState(() => _legendOpen = !_legendOpen),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 40,
            child: FloatingActionButton.extended(
              heroTag: 'locate',
              backgroundColor: AppColors.green,
              foregroundColor: Colors.white,
              onPressed: _locating ? null : _locate,
              icon: _locating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.my_location),
              label: const Text('Mijn positie'),
            ),
          ),
        ],
      ),
    );
  }

  void _showPreview(HistoricalLocation loc, LocationStatus status) {
    final fix = ref.read(lastFixProvider);
    final texts = ref.read(selectedRouteProvider)!.texts;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(status.icon, size: 18, color: status.color),
                  const SizedBox(width: 6),
                  Text('${status.label} · ${loc.place}'),
                  if (fix != null)
                    Text(
                      ' · ${_formatDistance(GpsService.distanceTo(fix, loc))}',
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                status == LocationStatus.locked
                    ? 'Deze locatie wordt later in de route ontgrendeld.'
                    : texts[loc.id]!.teaser,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          const NavigationService().navigateTo(loc),
                      icon: const Icon(Icons.directions_bike),
                      label: const Text('Navigeer'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        context.push('/location/${loc.id}');
                      },
                      child: const Text('Bekijk'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatDistance(double m) => m >= 1000
    ? '${(m / 1000).toStringAsFixed(1).replaceAll('.', ',')} km'
    : '${m.round()} m';

class _LocationMarker extends StatelessWidget {
  const _LocationMarker({
    required this.number,
    required this.status,
    required this.title,
    required this.onTap,
  });

  final int number;
  final LocationStatus status;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final current =
        status == LocationStatus.available ||
        status == LocationStatus.discovered;
    return Semantics(
      button: true,
      label: '$title, ${status.label}',
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Container(
            width: current ? 46 : 38,
            height: current ? 46 : 38,
            decoration: BoxDecoration(
              color: status.color,
              shape: BoxShape.circle,
              border: Border.all(
                color: current ? AppColors.paper : Colors.white,
                width: current ? 4 : 2.5,
              ),
              boxShadow: const [
                BoxShadow(blurRadius: 5, color: Colors.black38),
              ],
            ),
            alignment: Alignment.center,
            child:
                status == LocationStatus.completed ||
                    status == LocationStatus.locked
                ? Icon(status.icon, color: Colors.white, size: 20)
                : Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.open, required this.onToggle});
  final bool open;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.paperLight.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.legend_toggle, size: 20),
                  const SizedBox(width: 6),
                  const Text(
                    'Legenda',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Icon(open ? Icons.expand_more : Icons.expand_less, size: 20),
                ],
              ),
              if (open)
                for (final s in LocationStatus.values)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: s.color,
                          child: Icon(s.icon, size: 12, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Text(s.label),
                      ],
                    ),
                  ),
              if (open)
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 6,
                        backgroundColor: Color(0xFF2F6FB2),
                      ),
                      SizedBox(width: 12),
                      Text('Jouw positie'),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

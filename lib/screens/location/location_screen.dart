import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/clues.dart';
import '../../data/locations.dart';
import '../../models/location_model.dart';
import '../../models/progress_model.dart';
import '../../providers/providers.dart';
import '../../services/gps_service.dart';
import '../../services/navigation_service.dart';
import '../../utils/motion.dart';
import '../../widgets/common/archive.dart';
import '../../widgets/common/home_leading.dart';
import '../../widgets/common/location_image.dart';
import '../../widgets/common/page_body.dart';
import '../../widgets/common/reveal_dialog.dart';
import '../../widgets/common/sources_sheet.dart';
import '../../widgets/map/status_style.dart';
import '../../widgets/missions/clue_card.dart';

class LocationScreen extends ConsumerWidget {
  const LocationScreen({super.key, required this.locationId});
  final String locationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = locations[locationId];
    final route = ref.watch(selectedRouteProvider);
    final p = ref.watch(progressProvider);
    if (loc == null || route == null) {
      return Scaffold(
        appBar: AppBar(leading: homeLeading(context)),
        body: PageBody(
          children: [
            const Text('Deze locatie bestaat niet (meer).'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/route'),
              child: const Text('Terug naar de route'),
            ),
          ],
        ),
      );
    }
    final inRoute = route.locationIds.contains(locationId);
    final status = inRoute
        ? p.statusOf(locationId, route)
        : LocationStatus.locked;

    return Scaffold(
      appBar: AppBar(
        leading: homeLeading(context),
        title: Text(loc.place),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: ArchiveLabel(status.label, color: status.color),
            ),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: motion(context, ref),
        child: switch (status) {
          LocationStatus.locked => _Locked(
            key: const ValueKey('locked'),
            loc: loc,
            inRoute: inRoute,
          ),
          LocationStatus.available => _Preview(
            key: const ValueKey('preview'),
            loc: loc,
          ),
          _ => _Unlocked(
            key: const ValueKey('unlocked'),
            loc: loc,
            status: status,
            isFinal: locationId == route.endLocationId,
          ),
        },
      ),
    );
  }
}

class _Locked extends StatelessWidget {
  const _Locked({super.key, required this.loc, required this.inRoute});
  final HistoricalLocation loc;
  final bool inRoute;

  @override
  Widget build(BuildContext context) {
    return PageBody(
      children: [
        Stack(
          children: [
            LocationImage(asset: loc.imageAsset, label: loc.imageCaption),
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: const ColoredBox(
                  color: Colors.black45,
                  child: Center(
                    child: Icon(
                      Icons.lock_outline,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(loc.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          inRoute
              ? 'Deze locatie is nog vergrendeld. Rond eerst de vorige missie af '
                    'om deze plek te ontgrendelen.'
              : 'Deze locatie hoort niet bij de gekozen route.',
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () => context.go('/route'),
          child: const Text('Terug naar de route'),
        ),
      ],
    );
  }
}

/// Before the GPS check: only name, photo, teaser, distance and navigation.
class _Preview extends ConsumerStatefulWidget {
  const _Preview({super.key, required this.loc});
  final HistoricalLocation loc;

  @override
  ConsumerState<_Preview> createState() => _PreviewState();
}

class _PreviewState extends ConsumerState<_Preview> {
  bool _checking = false;
  GpsCheckResult? _result;

  Future<void> _check() async {
    setState(() {
      _checking = true;
      _result = null;
    });
    final result = await ref
        .read(gpsServiceProvider)
        .checkAt(widget.loc, simulated: ref.read(simulatedPositionProvider));
    if (!mounted) return;
    setState(() {
      _checking = false;
      _result = result;
    });
    if (result.success) {
      await showReveal(
        context,
        label: 'Locatie ontdekt',
        title: widget.loc.title,
        icon: Icons.travel_explore,
        duration: motion(context, ref, const Duration(milliseconds: 500)),
        body: const Text(
          'Het dossier van deze plek is nu geopend.',
          textAlign: TextAlign.center,
        ),
        buttonText: 'Open het dossier',
      );
      ref.read(progressProvider.notifier).discoverLocation(widget.loc.id);
    }
  }

  Future<void> _navigate() async {
    const nav = NavigationService();
    MapsApp? app;
    if (nav.isIOS && await nav.hasGoogleMapsApp()) {
      if (!mounted) return;
      app = await showModalBottomSheet<MapsApp>(
        context: context,
        showDragHandle: true,
        builder: (c) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.map_outlined),
                title: const Text('Apple Kaarten'),
                onTap: () => Navigator.pop(c, MapsApp.apple),
              ),
              ListTile(
                leading: const Icon(Icons.map),
                title: const Text('Google Maps'),
                onTap: () => Navigator.pop(c, MapsApp.google),
              ),
            ],
          ),
        ),
      );
      if (app == null) return;
    }
    final ok = await nav.navigateTo(widget.loc, app: app);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Er kon geen navigatie-app worden geopend.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = widget.loc;
    final p = ref.watch(progressProvider);
    final fix = ref.watch(lastFixProvider);
    final distance =
        _result?.distanceMeters ??
        (fix == null ? null : GpsService.distanceTo(fix, loc));
    final text = Theme.of(context).textTheme;

    return PageBody(
      children: [
        Hero(
          tag: 'loc-${loc.id}',
          child: LocationImage(asset: loc.imageAsset, label: loc.imageCaption),
        ),
        const SizedBox(height: 16),
        const ArchiveLabel('Volgende bestemming'),
        const SizedBox(height: 8),
        Text(loc.title, style: text.headlineSmall),
        const SizedBox(height: 8),
        Text(
          ref.watch(selectedRouteProvider)!.texts[loc.id]!.teaser,
          style: text.bodyLarge,
        ),
        if (distance != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.social_distance,
                size: 18,
                color: AppColors.olive,
              ),
              const SizedBox(width: 6),
              Expanded(child: Text('Afstand: ongeveer ${_fmt(distance)}')),
            ],
          ),
        ],
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _navigate,
                icon: const Icon(Icons.directions_bike),
                label: const Text('Navigeer naar locatie'),
              ),
            ),
            const SizedBox(width: 10),
            IconButton.outlined(
              tooltip: 'Toon op kaart',
              style: IconButton.styleFrom(minimumSize: const Size(52, 52)),
              onPressed: () => context.go('/map'),
              icon: const Icon(Icons.map_outlined),
            ),
          ],
        ),
        const SizedBox(height: 24),
        DossierCard(
          accent: AppColors.red,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                byMode(p, 'Ben je er?', 'Zijn jullie er?'),
                style: text.titleLarge,
              ),
              const SizedBox(height: 6),
              const Text(
                'Stop op een veilige plek voordat je de kaart, opdrachten of '
                'GPS-controle gebruikt.',
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _checking ? null : _check,
                  icon: _checking
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.my_location),
                  label: Text(
                    _checking
                        ? 'Locatie wordt gecontroleerd…'
                        : 'Controleer mijn locatie',
                  ),
                ),
              ),
              if (_result != null && !_result!.success) ...[
                const SizedBox(height: 12),
                Semantics(
                  liveRegion: true,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.paperDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppColors.anthracite,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            GpsService.message(_result!, group: p.isGroup),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

String _fmt(double m) => m >= 1000
    ? '${(m / 1000).toStringAsFixed(1).replaceAll('.', ',')} km'
    : '${(m / 10).round() * 10} m';

/// After the GPS check: full history, sources and the mission.
class _Unlocked extends ConsumerStatefulWidget {
  const _Unlocked({
    super.key,
    required this.loc,
    required this.status,
    required this.isFinal,
  });

  final HistoricalLocation loc;
  final LocationStatus status;
  final bool isFinal;

  @override
  ConsumerState<_Unlocked> createState() => _UnlockedState();
}

class _UnlockedState extends ConsumerState<_Unlocked> {
  bool _readMore = false;

  @override
  Widget build(BuildContext context) {
    final loc = widget.loc;
    final p = ref.watch(progressProvider);
    final text = Theme.of(context).textTheme;
    final route = ref.watch(selectedRouteProvider)!;
    final locText = route.texts[loc.id]!;
    final mission = widget.isFinal
        ? route.finalMission
        : route.missions[loc.id];
    final completed = widget.status == LocationStatus.completed;
    final clue = mission?.clueId == null ? null : clues[mission!.clueId];

    return PageBody(
      children: [
        Hero(
          tag: 'loc-${loc.id}',
          child: LocationImage(asset: loc.imageAsset, label: loc.imageCaption),
        ),
        const SizedBox(height: 16),
        Text(loc.title, style: text.headlineMedium),
        const SizedBox(height: 10),
        Text(
          locText.shortDescription,
          style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Text(locText.historyText, style: text.bodyLarge),
        if (locText.readMoreText != null) ...[
          AnimatedSize(
            duration: motion(context, ref, const Duration(milliseconds: 250)),
            alignment: Alignment.topCenter,
            child: _readMore
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(locText.readMoreText!, style: text.bodyLarge),
                  )
                : const SizedBox(width: double.infinity),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(() => _readMore = !_readMore),
              icon: Icon(_readMore ? Icons.expand_less : Icons.expand_more),
              label: Text(_readMore ? 'Minder lezen' : 'Lees meer'),
            ),
          ),
        ],
        Align(
          alignment: Alignment.centerLeft,
          child: SourcesButton(sources: loc.sources),
        ),
        const SizedBox(height: 16),
        if (mission != null)
          DossierCard(
            accent: completed ? AppColors.green : AppColors.red,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ArchiveLabel(
                      widget.isFinal ? 'Eindmissie' : 'Missie',
                      color: AppColors.red,
                    ),
                    const Spacer(),
                    if (completed)
                      const Stamp('Voltooid', color: AppColors.green),
                  ],
                ),
                const SizedBox(height: 10),
                Text(mission.title, style: text.titleLarge),
                const SizedBox(height: 6),
                Text(mission.intro),
                const SizedBox(height: 6),
                Text(
                  '${mission.tasks.length} opdrachten',
                  style: const TextStyle(color: AppColors.muted),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: completed
                      ? OutlinedButton(
                          onPressed: () => context.push(
                            widget.isFinal ? '/complete' : '/mission/${loc.id}',
                          ),
                          child: Text(
                            widget.isFinal
                                ? 'Bekijk het resultaat'
                                : 'Missie opnieuw bekijken',
                          ),
                        )
                      : FilledButton(
                          onPressed: () => context.push(
                            widget.isFinal ? '/final' : '/mission/${loc.id}',
                          ),
                          child: Text(
                            widget.isFinal
                                ? 'Start eindmissie'
                                : 'Start missie',
                          ),
                        ),
                ),
              ],
            ),
          ),
        if (completed && clue != null) ...[
          const SectionTitle('Gevonden aanwijzing'),
          ClueCard(clue: clue),
        ],
        if (completed && !widget.isFinal) ...[
          const SizedBox(height: 20),
          FilledButton.tonal(
            onPressed: () => context.go('/route'),
            style: FilledButton.styleFrom(minimumSize: const Size(64, 52)),
            child: Text(
              byMode(
                p,
                'Naar je volgende bestemming',
                'Naar jullie volgende bestemming',
              ),
            ),
          ),
        ],
      ],
    );
  }
}

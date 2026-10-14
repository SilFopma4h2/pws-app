import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/locations.dart';
import '../../models/progress_model.dart';
import '../../providers/providers.dart';
import '../../utils/motion.dart';
import '../../widgets/common/archive.dart';
import '../../widgets/common/page_body.dart';
import '../../widgets/map/status_style.dart';
import 'home_shell.dart';

class RouteOverviewScreen extends ConsumerWidget {
  const RouteOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(selectedRouteProvider);
    final p = ref.watch(progressProvider);
    if (route == null) return const _NoRoute();

    final text = Theme.of(context).textTheme;
    final missionIds = route.missionLocationIds;
    final done = missionIds.where(p.completedMissionIds.contains).length;
    final steps = route.locationIds.length;
    final stepsDone = done + (p.finalMissionCompleted ? 1 : 0);
    final currentId = p.currentLocationId(route);
    final current = currentId == null ? null : locations[currentId];
    final isFinalNext = currentId == route.endLocationId;

    return Scaffold(
      appBar: AppBar(
        title: Text(route.title),
        actions: const [SettingsAction()],
      ),
      body: PageBody(
        children: [
          Text(route.subtitle, style: text.headlineSmall),
          const SizedBox(height: 12),
          // Route progress
          Row(
            children: [
              Expanded(
                child: Text(
                  '$stepsDone van $steps locaties afgerond',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                '${p.clueIds.length} aanwijzingen',
                style: const TextStyle(color: AppColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TweenAnimationBuilder<double>(
            tween: Tween(end: stepsDone / steps),
            duration: motion(context, ref, const Duration(milliseconds: 700)),
            builder: (_, v, _) => LinearProgressIndicator(
              value: v,
              minHeight: 10,
              color: AppColors.olive,
              backgroundColor: AppColors.paperDark,
              borderRadius: BorderRadius.circular(5),
              semanticsLabel: 'Routevoortgang',
            ),
          ),
          const SizedBox(height: 20),

          if (p.finalMissionCompleted)
            DossierCard(
              accent: AppColors.green,
              onTap: () => context.push('/complete'),
              child: Row(
                children: [
                  const Stamp('Voltooid', color: AppColors.green),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      byMode(
                        p,
                        'Je hebt de missie voltooid. Bekijk je resultaat.',
                        'Jullie hebben de missie voltooid. Bekijk het resultaat.',
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            )
          else if (current != null)
            DossierCard(
              accent: AppColors.red,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ArchiveLabel(
                    isFinalNext
                        ? 'Eindmissie beschikbaar'
                        : byMode(
                            p,
                            'Je volgende missie',
                            'Jullie volgende missie',
                          ),
                    color: AppColors.red,
                  ),
                  const SizedBox(height: 10),
                  Text(current.title, style: text.titleLarge),
                  Text(
                    current.place,
                    style: const TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 8),
                  Text(route.texts[current.id]!.teaser),
                  if (p.allMissionsDone(route) && !p.finalMissionCompleted) ...[
                    const SizedBox(height: 10),
                    Text(
                      byMode(
                        p,
                        'Je route is bijna klaar!',
                        'Jullie route is bijna klaar!',
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.green,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () =>
                              context.push('/location/${current.id}'),
                          child: const Text('Bekijk locatie'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton.outlined(
                        tooltip: 'Toon op kaart',
                        iconSize: 26,
                        style: IconButton.styleFrom(
                          minimumSize: const Size(56, 56),
                        ),
                        onPressed: () => context.go('/map'),
                        icon: const Icon(Icons.map_outlined),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          const SectionTitle('Historische locaties'),
          for (var i = 0; i < route.locationIds.length; i++)
            _LocationRow(
              number: i + 1,
              locationId: route.locationIds[i],
              status: p.statusOf(route.locationIds[i], route),
              isFinal: route.locationIds[i] == route.endLocationId,
              isLast: i == route.locationIds.length - 1,
            ),
        ],
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({
    required this.number,
    required this.locationId,
    required this.status,
    required this.isFinal,
    required this.isLast,
  });

  final int number;
  final String locationId;
  final LocationStatus status;
  final bool isFinal;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final loc = locations[locationId];
    if (loc == null) return const SizedBox.shrink();
    final locked = status == LocationStatus.locked;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline
          SizedBox(
            width: 40,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: status.color,
                  child: status == LocationStatus.completed
                      ? const Icon(Icons.check, size: 18, color: Colors.white)
                      : Text(
                          '$number',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
                if (!isLast)
                  Expanded(child: Container(width: 2, color: AppColors.line)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DossierCard(
                accent: status.color,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                onTap: () => context.push('/location/$locationId'),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: locked ? AppColors.muted : null,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(status.icon, size: 16, color: status.color),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  '${status.label} · ${loc.place}'
                                  '${isFinal ? ' · Eindmissie' : ''}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.muted),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoRoute extends StatelessWidget {
  const _NoRoute();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route')),
      body: PageBody(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.route_outlined, size: 56, color: AppColors.olive),
          const SizedBox(height: 12),
          const Text(
            'Er is nog geen route gekozen.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => context.go('/routes'),
            child: const Text('Kies een route'),
          ),
        ],
      ),
    );
  }
}

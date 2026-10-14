import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/clues.dart';
import '../../data/locations.dart';
import '../../models/progress_model.dart';
import '../../providers/providers.dart';
import '../../widgets/common/archive.dart';
import '../../widgets/common/page_body.dart';
import '../../widgets/map/status_style.dart';
import '../../widgets/missions/clue_card.dart';
import '../home/home_shell.dart';

/// Field book: progress, visited places, clues and key knowledge.
class MissionBookScreen extends ConsumerWidget {
  const MissionBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(selectedRouteProvider);
    final p = ref.watch(progressProvider);
    if (route == null) return const SizedBox.shrink();
    final text = Theme.of(context).textTheme;

    final missionIds = route.missionLocationIds;
    final visited = route.locationIds
        .where(
          (id) =>
              p.discoveredLocationIds.contains(id) ||
              p.completedMissionIds.contains(id),
        )
        .length;
    final completed = missionIds.where(p.completedMissionIds.contains).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Missieboek'),
        actions: const [SettingsAction()],
      ),
      body: PageBody(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ArchiveLabel(
                  'Veldboek · ${route.title}',
                  color: AppColors.paper,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 28,
                  runSpacing: 12,
                  children: [
                    _Count(
                      '$visited/${route.locationIds.length}',
                      'locaties ontdekt',
                    ),
                    _Count(
                      '$completed/${missionIds.length}',
                      'missies voltooid',
                    ),
                    _Count('${p.clueIds.length}', 'aanwijzingen'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      p.finalMissionCompleted
                          ? Icons.verified
                          : p.finalMissionAvailable(route)
                          ? Icons.lock_open
                          : Icons.lock_outline,
                      color: AppColors.paper,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        p.finalMissionCompleted
                            ? 'Eindmissie voltooid'
                            : p.finalMissionAvailable(route)
                            ? 'Eindmissie beschikbaar'
                            : 'Eindmissie vergrendeld',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SectionTitle('Aanwijzingen'),
          LayoutBuilder(
            builder: (context, c) {
              final cols = c.maxWidth > 520 ? 3 : 2;
              final w = (c.maxWidth - (cols - 1) * 10) / cols;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final id in missionIds)
                    if (route.missions[id]?.clueId != null)
                      SizedBox(
                        width: w,
                        child: p.clueIds.contains(route.missions[id]!.clueId)
                            ? GestureDetector(
                                onTap: () => _showClue(
                                  context,
                                  route.missions[id]!.clueId!,
                                ),
                                child: ClueCard(
                                  clue: clues[route.missions[id]!.clueId]!,
                                  compact: true,
                                ),
                              )
                            : LockedClueCard(hint: locations[id]?.title ?? ''),
                      ),
                ],
              );
            },
          ),

          const SectionTitle('Locaties'),
          for (final id in route.locationIds)
            if (locations[id] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _LocationEntry(id: id, status: p.statusOf(id, route)),
              ),

          const SectionTitle('Belangrijke kennis'),
          if (completed == 0)
            const Text(
              'Hier verschijnt wat jullie per locatie hebben ontdekt.',
              style: TextStyle(color: AppColors.muted),
            ),
          for (final id in missionIds)
            if (p.completedMissionIds.contains(id) &&
                route.missions[id] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DossierCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(locations[id]?.title ?? id, style: text.titleMedium),
                      const SizedBox(height: 4),
                      Text(route.missions[id]!.keyInsight),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }

  void _showClue(BuildContext context, String clueId) {
    showDialog<void>(
      context: context,
      builder: (c) => Dialog(
        backgroundColor: AppColors.paper,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClueCard(clue: clues[clueId]!),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(c),
                child: const Text('Sluiten'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Count extends StatelessWidget {
  const _Count(this.value, this.label);
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        value,
        style: const TextStyle(
          fontFamily: AppFonts.heading,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      Text(label, style: const TextStyle(color: AppColors.paper)),
    ],
  );
}

class _LocationEntry extends StatelessWidget {
  const _LocationEntry({required this.id, required this.status});
  final String id;
  final LocationStatus status;

  @override
  Widget build(BuildContext context) {
    final loc = locations[id]!;
    return DossierCard(
      accent: status.color,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: () => context.push('/location/$id'),
      child: Row(
        children: [
          Icon(status.icon, color: status.color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  status.label,
                  style: const TextStyle(color: AppColors.muted),
                ),
              ],
            ),
          ),
          if (status == LocationStatus.completed)
            const Stamp('Voltooid', color: AppColors.green),
        ],
      ),
    );
  }
}

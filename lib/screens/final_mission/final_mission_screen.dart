import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/clues.dart';
import '../../data/final_mission.dart';
import '../../data/locations.dart';
import '../../models/progress_model.dart';
import '../../providers/providers.dart';
import '../../widgets/common/archive.dart';
import '../../widgets/common/home_leading.dart';
import '../../widgets/common/page_body.dart';
import '../../widgets/missions/clue_card.dart';
import '../../widgets/missions/mission_runner.dart';

class FinalMissionScreen extends ConsumerWidget {
  const FinalMissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(selectedRouteProvider);
    final p = ref.watch(progressProvider);
    if (route == null) return const SizedBox.shrink();

    final status = p.statusOf(route.endLocationId, route);
    if (status == LocationStatus.locked || status == LocationStatus.available) {
      final missing = route.missionLocationIds
          .where((id) => !p.completedMissionIds.contains(id))
          .map((id) => locations[id]?.title ?? id)
          .toList();
      return Scaffold(
        appBar: AppBar(
          leading: homeLeading(context),
          title: const Text('Eindmissie'),
        ),
        body: PageBody(
          children: [
            const SizedBox(height: 16),
            const Icon(Icons.lock_outline, size: 52, color: AppColors.muted),
            const SizedBox(height: 12),
            Text(
              'De eindmissie is nog vergrendeld.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              missing.isEmpty
                  ? 'Ontgrendel eerst de locatie van de eindmissie met de GPS-controle.'
                  : 'Nog te voltooien: ${missing.join(', ')}.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => context.go('/route'),
              child: const Text('Terug naar de route'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: homeLeading(context),
        title: const Text('Eindmissie'),
        actions: [
          TextButton.icon(
            onPressed: () => _showClues(context, p),
            icon: const Icon(Icons.key_outlined),
            label: const Text('Aanwijzingen'),
          ),
        ],
      ),
      body: MissionRunner(
        mission: route.finalMission,
        onFinished: () async {
          ref.read(progressProvider.notifier).completeFinalMission();
          if (context.mounted) context.pushReplacement('/complete');
        },
        header: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ArchiveLabel('De centrale vraag', color: AppColors.paper),
              const SizedBox(height: 10),
              Text(
                finalQuestion,
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                byMode(
                  p,
                  'Gebruik alles wat je onderweg hebt ontdekt. Je aanwijzingen '
                      'vind je rechtsboven.',
                  'Gebruik alles wat jullie onderweg hebben ontdekt. Jullie '
                      'aanwijzingen vinden jullie rechtsboven.',
                ),
                style: const TextStyle(color: AppColors.paper),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClues(BuildContext context, ProgressState p) {
    final found = [
      for (final id in p.clueIds)
        if (clues[id] != null) clues[id]!,
    ];
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            Text(
              'Verzamelde aanwijzingen',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (found.isEmpty) const Text('Nog geen aanwijzingen verzameld.'),
            for (final c in found)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ClueCard(clue: c),
              ),
          ],
        ),
      ),
    );
  }
}

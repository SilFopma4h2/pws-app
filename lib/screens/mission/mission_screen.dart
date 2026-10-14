import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/clues.dart';
import '../../data/locations.dart';
import '../../models/mission_model.dart';
import '../../models/progress_model.dart';
import '../../providers/providers.dart';
import '../../utils/motion.dart';
import '../../widgets/common/archive.dart';
import '../../widgets/common/home_leading.dart';
import '../../widgets/common/page_body.dart';
import '../../widgets/common/reveal_dialog.dart';
import '../../widgets/missions/clue_card.dart';
import '../../widgets/missions/mission_runner.dart';

class MissionScreen extends ConsumerStatefulWidget {
  const MissionScreen({super.key, required this.locationId});
  final String locationId;

  @override
  ConsumerState<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends ConsumerState<MissionScreen> {
  bool _done = false;

  Future<void> _finish(Mission mission) async {
    final clue = mission.clueId == null ? null : clues[mission.clueId];
    final alreadyHad =
        clue != null && ref.read(progressProvider).clueIds.contains(clue.id);
    // Save first, so progress is never lost.
    ref
        .read(progressProvider.notifier)
        .completeMission(widget.locationId, mission.clueId);

    if (clue != null && !alreadyHad && mounted) {
      final respectful = mission.tone == MissionTone.respectful;
      await showReveal(
        context,
        label: respectful ? 'Toegevoegd' : 'Nieuwe aanwijzing',
        title: respectful
            ? 'Aanwijzing toegevoegd aan het missieboek'
            : 'Nieuwe aanwijzing ontdekt',
        icon: respectful ? Icons.local_florist_outlined : Icons.key_outlined,
        // Respectful missions: no animation at all.
        duration: respectful
            ? Duration.zero
            : motion(context, ref, const Duration(milliseconds: 500)),
        body: ClueCard(clue: clue),
      );
    }
    if (mounted) setState(() => _done = true);
  }

  @override
  Widget build(BuildContext context) {
    final route = ref.watch(selectedRouteProvider);
    final mission = route?.missions[widget.locationId];
    final loc = locations[widget.locationId];
    final p = ref.watch(progressProvider);

    if (mission == null || loc == null || route == null) {
      return Scaffold(
        appBar: AppBar(leading: homeLeading(context)),
        body: PageBody(
          children: [
            const Text('Voor deze locatie is (nog) geen missie beschikbaar.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/route'),
              child: const Text('Terug naar de route'),
            ),
          ],
        ),
      );
    }

    final status = p.statusOf(widget.locationId, route);
    if (status == LocationStatus.locked || status == LocationStatus.available) {
      // Not unlocked via GPS (yet): send back to the location page.
      return Scaffold(
        appBar: AppBar(leading: homeLeading(context)),
        body: PageBody(
          children: [
            const Text('Ontgrendel eerst deze locatie met de GPS-controle.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/location/${widget.locationId}'),
              child: const Text('Naar de locatie'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(leading: homeLeading(context), title: Text(mission.title)),
      body: AnimatedSwitcher(
        duration: motion(context, ref),
        child: _done
            ? _MissionDone(
                key: const ValueKey('done'),
                mission: mission,
                locationTitle: loc.title,
              )
            : MissionRunner(
                key: const ValueKey('runner'),
                mission: mission,
                onFinished: () => _finish(mission),
                header: DossierCard(
                  accent: AppColors.red,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ArchiveLabel(loc.title, color: AppColors.red),
                      const SizedBox(height: 8),
                      Text(mission.intro),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _MissionDone extends ConsumerWidget {
  const _MissionDone({
    super.key,
    required this.mission,
    required this.locationTitle,
  });

  final Mission mission;
  final String locationTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(progressProvider);
    final route = ref.watch(selectedRouteProvider)!;
    final nextId = p.currentLocationId(route);
    final next = nextId == null ? null : locations[nextId];
    final isFinalNext = nextId == route.endLocationId;
    final respectful = mission.tone == MissionTone.respectful;
    final text = Theme.of(context).textTheme;

    return PageBody(
      children: [
        const SizedBox(height: 12),
        Center(
          child: Stamp(
            respectful ? 'Afgerond' : 'Missie voltooid',
            color: AppColors.green,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          mission.completionText,
          textAlign: TextAlign.center,
          style: text.titleLarge,
        ),
        const SectionTitle('Belangrijke kennis'),
        DossierCard(child: Text(mission.keyInsight)),
        const SizedBox(height: 20),
        if (next != null)
          DossierCard(
            accent: AppColors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ArchiveLabel(
                  isFinalNext
                      ? 'Eindmissie beschikbaar'
                      : byMode(
                          p,
                          'Je volgende bestemming',
                          'Jullie volgende bestemming',
                        ),
                  color: AppColors.red,
                ),
                const SizedBox(height: 8),
                Text(next.title, style: text.titleLarge),
                Text(route.texts[next.id]!.teaser),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () =>
                        context.pushReplacement('/location/${next.id}'),
                    child: const Text('Bekijk volgende bestemming'),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.go('/book'),
                child: const Text('Missieboek'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.go('/map'),
                child: const Text('Kaart'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

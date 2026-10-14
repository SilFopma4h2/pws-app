import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../config/app_config.dart';
import '../../data/clues.dart';
import '../../data/locations.dart';
import '../../providers/providers.dart';
import '../../utils/motion.dart';
import '../../widgets/common/archive.dart';
import '../../widgets/common/home_leading.dart';
import '../../widgets/common/page_body.dart';
import '../../widgets/missions/clue_card.dart';

/// "MISSIE VOLTOOID": meaningful ending without points.
class CompletionScreen extends ConsumerWidget {
  const CompletionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(progressProvider);
    final route = ref.watch(selectedRouteProvider);
    final text = Theme.of(context).textTheme;

    if (route == null || !p.finalMissionCompleted) {
      return Scaffold(
        appBar: AppBar(leading: homeLeading(context)),
        body: PageBody(
          children: [
            const Text('De eindmissie is nog niet voltooid.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/route'),
              child: const Text('Terug naar de route'),
            ),
          ],
        ),
      );
    }

    final visited = [
      for (final id in route.locationIds)
        if (p.discoveredLocationIds.contains(id) ||
            p.completedMissionIds.contains(id))
          locations[id]!,
    ];
    final found = [
      for (final id in p.clueIds)
        if (clues[id] != null) clues[id]!,
    ];
    final insights = [
      for (final id in route.missionLocationIds)
        if (p.completedMissionIds.contains(id) && route.missions[id] != null)
          route.missions[id]!.keyInsight,
    ];

    return Scaffold(
      appBar: AppBar(
        leading: homeLeading(context),
        title: const Text('Missie voltooid'),
      ),
      body: PageBody(
        children: [
          const SizedBox(height: 8),
          const Center(child: Stamp('Missie voltooid', color: AppColors.green)),
          const SizedBox(height: 20),
          Text(
            byMode(
              p,
              'Je hebt het verhaal van Operatie Market Garden gereconstrueerd.',
              'Jullie hebben het verhaal van Operatie Market Garden gereconstrueerd.',
            ),
            textAlign: TextAlign.center,
            style: text.headlineSmall,
          ),
          const SizedBox(height: 24),
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.85, end: 1),
              duration: motion(context, ref, const Duration(milliseconds: 700)),
              curve: Curves.easeOutBack,
              builder: (_, v, child) => Transform.scale(scale: v, child: child),
              child: const _Badge(),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 24,
            runSpacing: 8,
            children: [
              _Stat('${visited.length}', 'locaties bezocht'),
              _Stat('${found.length}', 'aanwijzingen gevonden'),
            ],
          ),
          const SectionTitle('Samenvatting'),
          DossierCard(child: Text(route.finalMission.keyInsight)),
          const SectionTitle('Wat jullie hebben geleerd'),
          for (final i in insights)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(Icons.check, size: 18, color: AppColors.olive),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(i)),
                ],
              ),
            ),
          const SectionTitle('Bezochte locaties'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final l in visited)
                Chip(
                  avatar: const Icon(
                    Icons.place,
                    size: 18,
                    color: AppColors.green,
                  ),
                  label: Text(l.title),
                ),
            ],
          ),
          const SectionTitle('Gevonden aanwijzingen'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final c in found)
                SizedBox(width: 200, child: ClueCard(clue: c, compact: true)),
            ],
          ),
          const SizedBox(height: 28),
          if (AppConfig.enablePostQuiz)
            FilledButton.icon(
              onPressed: () => context.push('/quiz/post'),
              icon: const Icon(Icons.quiz_outlined),
              label: Text(
                p.postQuiz == null
                    ? 'Doe de korte eindquiz'
                    : 'Eindquiz opnieuw doen',
              ),
            ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => context.go('/book'),
            child: const Text('Naar het missieboek'),
          ),
          const SizedBox(height: 20),
          const Text(
            'In september 1944 kwamen bij de Slag om Arnhem duizenden '
            'militairen en burgers om het leven. Deze route is opgedragen aan '
            'hun herinnering.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.muted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Badge: Historisch onderzoeker – Market Garden',
      child: Container(
        width: 190,
        height: 190,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.paperLight,
          border: Border.all(color: AppColors.green, width: 4),
          boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
        ),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.olive, width: 1.5),
          ),
          padding: const EdgeInsets.all(18),
          // Scales down with large system font sizes instead of overflowing.
          child: const FittedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.manage_search, size: 44, color: AppColors.green),
                SizedBox(height: 6),
                Text(
                  'HISTORISCH\nONDERZOEKER',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.heading,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Market Garden',
                  style: TextStyle(
                    fontFamily: AppFonts.stamp,
                    color: AppColors.red,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label);
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(value, style: Theme.of(context).textTheme.headlineMedium),
      Text(label, style: const TextStyle(color: AppColors.muted)),
    ],
  );
}

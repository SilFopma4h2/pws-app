import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../config/app_config.dart';
import '../../data/locations.dart';
import '../../data/routes.dart';
import '../../models/route_model.dart';
import '../../providers/providers.dart';
import '../../widgets/common/archive.dart';
import '../../widgets/common/page_body.dart';

class RouteSelectionScreen extends ConsumerWidget {
  const RouteSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(progressProvider.select((p) => p.routeId));
    return Scaffold(
      appBar: AppBar(title: const Text('Kies een route')),
      body: PageBody(
        children: [
          const Text(
            'Beide routes eindigen bij de John Frostbrug, waar de eindmissie '
            'wacht. Onderweg bezoeken jullie verschillende historische '
            'locaties.',
          ),
          const SizedBox(height: 16),
          for (final r in routes)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _RouteCard(
                route: r,
                selected: r.id == selected,
                onChoose: () {
                  ref.read(progressProvider.notifier).selectRoute(r.id);
                  final preDone = ref.read(progressProvider).preQuiz != null;
                  context.go(
                    AppConfig.enablePreQuiz && !preDone
                        ? '/quiz/pre'
                        : '/route',
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.route,
    required this.selected,
    required this.onChoose,
  });

  final RouteModel route;
  final bool selected;
  final VoidCallback onChoose;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final start = locations[route.startLocationId]?.title ?? '-';
    return DossierCard(
      accent: selected ? AppColors.red : AppColors.green,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ArchiveLabel(route.title),
              const Spacer(),
              if (selected) const ArchiveLabel('Gekozen', color: AppColors.red),
            ],
          ),
          const SizedBox(height: 10),
          Text(route.subtitle, style: text.titleLarge),
          const SizedBox(height: 6),
          Text(route.description),
          const SizedBox(height: 14),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _Fact(
                Icons.place_outlined,
                '${route.locationIds.length} historische locaties',
              ),
              _Fact(Icons.flag_outlined, 'Start: $start'),
              _Fact(Icons.straighten, route.estimatedDistance),
              _Fact(Icons.schedule, route.estimatedDuration),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            route.locationIds
                .map((id) => locations[id]?.title ?? id)
                .join('  →  '),
            style: const TextStyle(color: AppColors.muted, fontSize: 14),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onChoose,
              child: Text('Kies ${route.title}'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact(this.icon, this.text);
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 18, color: AppColors.olive),
      const SizedBox(width: 4),
      Flexible(child: Text(text, style: const TextStyle(fontSize: 14.5))),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../models/progress_model.dart';
import '../../providers/providers.dart';
import '../../widgets/common/archive.dart';
import '../../widgets/common/page_body.dart';

class ModeScreen extends ConsumerWidget {
  const ModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(progressProvider.select((p) => p.mode));

    void choose(PlayMode mode) {
      ref.read(progressProvider.notifier).setMode(mode);
      context.go(
        ref.read(progressProvider).routeId == null ? '/routes' : '/route',
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Alleen of samen')),
      body: PageBody(
        children: [
          Text(
            'Hoe doen jullie deze missie?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          _ModeCard(
            icon: Icons.person_outline,
            title: 'Alleen',
            subtitle: 'Je onderzoekt de route zelfstandig.',
            selected: current == PlayMode.solo,
            onTap: () => choose(PlayMode.solo),
          ),
          const SizedBox(height: 12),
          _ModeCard(
            icon: Icons.groups_outlined,
            title: 'Samen',
            subtitle: 'Jullie onderzoeken de route als groep.',
            selected: current == PlayMode.group,
            onTap: () => choose(PlayMode.group),
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: DossierCard(
        accent: selected ? AppColors.red : AppColors.olive,
        onTap: onTap,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, size: 40, color: AppColors.green),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  Text(subtitle),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

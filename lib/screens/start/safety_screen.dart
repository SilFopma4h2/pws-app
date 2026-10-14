import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../providers/providers.dart';
import '../../widgets/common/page_body.dart';

class SafetyScreen extends ConsumerWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Veiligheid eerst')),
      body: PageBody(
        children: [
          const SizedBox(height: 16),
          const Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.red,
              child: Icon(Icons.pedal_bike, size: 48, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Gebruik je telefoon alleen wanneer je veilig stilstaat.',
            textAlign: TextAlign.center,
            style: text.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            'Stop op een veilige plek voordat je de kaart, opdrachten of '
            'GPS-controle gebruikt.',
            textAlign: TextAlign.center,
            style: text.bodyLarge,
          ),
          const SizedBox(height: 24),
          const _Rule(
            Icons.do_not_touch_outlined,
            'Tijdens het fietsen blijft de telefoon in je tas of zak.',
          ),
          const _Rule(
            Icons.local_parking,
            'Zet je fiets aan de kant, niet op het fietspad.',
          ),
          const _Rule(
            Icons.groups_outlined,
            'Samen? Spreek af wie de telefoon gebruikt en wie oplet.',
          ),
          const _Rule(
            Icons.traffic_outlined,
            'Volg altijd de verkeersregels. De app geeft geen haast.',
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              ref.read(progressProvider.notifier).acceptSafety();
              context.go('/intro');
            },
            child: const Text('Begrepen'),
          ),
        ],
      ),
    );
  }
}

class _Rule extends StatelessWidget {
  const _Rule(this.icon, this.text);
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(icon, color: AppColors.olive, size: 28),
        const SizedBox(width: 14),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
      ],
    ),
  );
}

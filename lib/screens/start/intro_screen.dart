import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../widgets/common/archive.dart';
import '../../widgets/common/page_body.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  // AANPASBARE PWS-INHOUD: introductietekst.
  static const _steps = [
    (
      Icons.place_outlined,
      'Bezoek historische plaatsen',
      'In Oosterbeek, Driel en Arnhem.',
    ),
    (
      Icons.auto_stories_outlined,
      'Ontdek verhalen',
      'Van soldaten, burgers en hulpverleners.',
    ),
    (
      Icons.extension_outlined,
      'Voer missies uit',
      'Kaarten lezen, volgordes leggen, bronnen combineren.',
    ),
    (
      Icons.folder_open_outlined,
      'Verzamel aanwijzingen',
      'Ze komen in jullie missieboek.',
    ),
    (
      Icons.flag_outlined,
      'Ontgrendel de eindmissie',
      'Bij de brug komt alles samen.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Jullie missie')),
      body: PageBody(
        children: [
          const ArchiveLabel('Opdracht'),
          const SizedBox(height: 12),
          Text(
            'Jullie reconstrueren het verhaal van Operatie Market Garden door '
            'echte historische locaties te bezoeken.',
            style: text.titleLarge,
          ),
          const SizedBox(height: 20),
          for (final (icon, title, sub) in _steps)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: DossierCard(
                child: Row(
                  children: [
                    Icon(icon, size: 30, color: AppColors.green),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: text.titleMedium),
                          Text(
                            sub,
                            style: const TextStyle(color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          const Text(
            'Er zijn geen punten en er is geen tijdslimiet. Het gaat om '
            'ontdekken en begrijpen.',
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => context.go('/mode'),
            child: const Text('Verder'),
          ),
        ],
      ),
    );
  }
}

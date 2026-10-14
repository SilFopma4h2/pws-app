import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../config/app_config.dart';
import '../../widgets/common/archive.dart';
import '../../widgets/common/page_body.dart';
import '../home/home_shell.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  // AANPASBARE PWS-INHOUD: informatie over het project.
  static const _about =
      'Deze app is gemaakt als profielwerkstuk. We onderzoeken hoe de '
      'geschiedenis en betekenis van Operatie Market Garden op een '
      'interactieve en educatieve manier aan jongeren kan worden '
      'overgebracht.';

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
        actions: const [SettingsAction()],
      ),
      body: PageBody(
        children: [
          const SafetyNote(),
          const SectionTitle('Operatie Market Garden'),
          const Text(
            'In september 1944 probeerden de geallieerden met luchtlandingstroepen '
            'en grondtroepen een reeks bruggen in Nederland te veroveren. De brug '
            'over de Rijn bij Arnhem was het laatste doel. Na negen dagen strijd '
            'moesten de Britse en Poolse luchtlandingstroepen zich terugtrekken.',
          ),
          const SectionTitle('Zo werkt de app'),
          for (final (icon, t) in const [
            (
              Icons.route_outlined,
              'Route: jullie voortgang en de volgende bestemming.',
            ),
            (Icons.map_outlined, 'Kaart: alle locaties en de route.'),
            (
              Icons.my_location,
              'Ter plekke: controleer je locatie om het dossier te openen.',
            ),
            (
              Icons.menu_book_outlined,
              'Missieboek: aanwijzingen en ontdekkingen.',
            ),
            (Icons.flag_outlined, 'Eindmissie: bij de brug komt alles samen.'),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Icon(icon, color: AppColors.olive),
                  const SizedBox(width: 12),
                  Expanded(child: Text(t)),
                ],
              ),
            ),
          const SectionTitle('Over dit project'),
          const Text(_about),
          const SizedBox(height: 20),
          Text(
            'Versie ${AppConfig.appVersion}',
            style: text.bodySmall?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined),
            label: const Text('Instellingen'),
          ),
        ],
      ),
    );
  }
}

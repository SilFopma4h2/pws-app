import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../config/app_config.dart';
import '../../models/progress_model.dart';
import '../../providers/providers.dart';
import '../../widgets/common/archive.dart';
import '../../widgets/common/home_leading.dart';
import '../../widgets/common/page_body.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  int _versionTaps = 0;

  Future<void> _confirmReset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Voortgang opnieuw beginnen'),
        content: const Text(
          'Weet je zeker dat je alle voortgang wilt verwijderen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Annuleren'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Verwijderen'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(progressProvider.notifier).reset();
      if (mounted) context.go('/');
    }
  }

  void _onVersionTap() {
    if (ref.read(devModeProvider)) return;
    _versionTaps++;
    if (_versionTaps >= 7) {
      ref.read(progressProvider.notifier).unlockDevMode();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Developer Mode is ingeschakeld.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = ref.watch(progressProvider);
    final dev = ref.watch(devModeProvider);
    final route = ref.watch(selectedRouteProvider);

    return Scaffold(
      appBar: AppBar(
        leading: homeLeading(context),
        title: const Text('Instellingen'),
      ),
      body: PageBody(
        children: [
          const SectionTitle('Missie'),
          const Text('Hoe doen jullie deze missie?'),
          const SizedBox(height: 8),
          SegmentedButton<PlayMode>(
            segments: const [
              ButtonSegment(
                value: PlayMode.solo,
                icon: Icon(Icons.person_outline),
                label: Text('Alleen'),
              ),
              ButtonSegment(
                value: PlayMode.group,
                icon: Icon(Icons.groups_outlined),
                label: Text('Samen'),
              ),
            ],
            selected: {p.mode ?? PlayMode.group},
            onSelectionChanged: (s) =>
                ref.read(progressProvider.notifier).setMode(s.first),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.route_outlined),
            title: const Text('Route wijzigen'),
            subtitle: Text(
              route == null
                  ? 'Nog geen route gekozen'
                  : '${route.title} – ${route.subtitle}',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/routes'),
          ),
          const SectionTitle('Weergave'),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Minder beweging'),
            subtitle: const Text('Zet animaties uit.'),
            value: p.reduceMotion,
            onChanged: (v) =>
                ref.read(progressProvider.notifier).setReduceMotion(v),
          ),
          const SectionTitle('Voortgang'),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.red,
              side: const BorderSide(color: AppColors.red),
            ),
            onPressed: _confirmReset,
            icon: const Icon(Icons.restart_alt),
            label: const Text('Voortgang opnieuw beginnen'),
          ),
          const SizedBox(height: 28),
          const Divider(),
          if (dev)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.developer_mode),
              title: const Text('Developer Mode'),
              subtitle: const Text('Alleen voor testen'),
              trailing: const ArchiveLabel('Test', color: AppColors.red),
              onTap: () => context.push('/developer'),
            ),
          GestureDetector(
            onTap: _onVersionTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                '${AppConfig.appTitle} · versie ${AppConfig.appVersion}',
                style: const TextStyle(color: AppColors.muted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/locations.dart';
import '../../data/routes.dart';
import '../../models/progress_model.dart';
import '../../models/quiz_model.dart';
import '../../providers/providers.dart';
import '../../services/gps_service.dart';
import '../../widgets/common/home_leading.dart';
import '../../widgets/common/page_body.dart';
import '../../widgets/map/status_style.dart';

/// Testing tools. Reachable from Instellingen when developer mode is on.
class DeveloperScreen extends ConsumerStatefulWidget {
  const DeveloperScreen({super.key});

  @override
  ConsumerState<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends ConsumerState<DeveloperScreen> {
  String _simLocationId = locations.keys.first;
  double _simAccuracy = 10;

  ProgressNotifier get _n => ref.read(progressProvider.notifier);

  void _toast(String msg) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
  );

  void _simulate({double offsetMeters = 0}) {
    final l = locations[_simLocationId]!;
    // ~111 320 m per degree latitude.
    ref
        .read(simulatedPositionProvider.notifier)
        .set(
          SimulatedPosition(
            l.latitude + offsetMeters / 111320,
            l.longitude,
            _simAccuracy,
          ),
        );
    _toast(
      offsetMeters == 0
          ? 'GPS gesimuleerd bij ${l.title}'
          : 'GPS gesimuleerd ${offsetMeters.round()} m van ${l.title}',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!ref.watch(devModeProvider)) {
      return Scaffold(
        appBar: AppBar(leading: homeLeading(context)),
        body: const Center(child: Text('Developer Mode staat uit.')),
      );
    }
    final p = ref.watch(progressProvider);
    final route = ref.watch(selectedRouteProvider);
    final sim = ref.watch(simulatedPositionProvider);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: homeLeading(context),
        title: const Text('Developer Mode'),
        backgroundColor: AppColors.anthracite,
        foregroundColor: Colors.white,
        titleTextStyle: text.titleLarge?.copyWith(color: Colors.white),
      ),
      body: PageBody(
        children: [
          // ── GPS ────────────────────────────────────────────────────────────
          _Header('GPS simuleren'),
          Text(
            sim == null
                ? 'Nu: echte GPS'
                : 'Nu gesimuleerd: ${sim.latitude.toStringAsFixed(5)}, '
                      '${sim.longitude.toStringAsFixed(5)} (±${sim.accuracy.round()} m)',
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _simLocationId,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Locatie'),
            items: [
              for (final l in locations.values)
                DropdownMenuItem(value: l.id, child: Text(l.title)),
            ],
            onChanged: (v) => setState(() => _simLocationId = v!),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final a in [10.0, 40.0, 150.0])
                ChoiceChip(
                  label: Text('nauwkeurigheid ±${a.round()} m'),
                  selected: _simAccuracy == a,
                  onSelected: (_) => setState(() => _simAccuracy = a),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton(
                onPressed: _simulate,
                child: const Text('Op locatie'),
              ),
              OutlinedButton(
                onPressed: () => _simulate(offsetMeters: 90),
                child: const Text('90 m ernaast'),
              ),
              OutlinedButton(
                onPressed: () => _simulate(offsetMeters: 300),
                child: const Text('300 m ernaast'),
              ),
              TextButton(
                onPressed: () {
                  ref.read(simulatedPositionProvider.notifier).set(null);
                  _toast('Echte GPS ingeschakeld');
                },
                child: const Text('Uit (echte GPS)'),
              ),
            ],
          ),

          // ── Route ──────────────────────────────────────────────────────────
          _Header('Route'),
          Wrap(
            spacing: 8,
            children: [
              for (final r in routes)
                ChoiceChip(
                  label: Text(r.title),
                  selected: p.routeId == r.id,
                  onSelected: (_) => _n.selectRoute(r.id),
                ),
            ],
          ),
          if (route != null) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonal(
                  onPressed: () {
                    final id = p.currentLocationId(route);
                    if (id == null) return _toast('Geen volgende locatie');
                    if (p.statusOf(id, route) == LocationStatus.available) {
                      _n.discoverLocation(id);
                      _toast('${locations[id]?.title} ontgrendeld');
                    } else if (id != route.endLocationId) {
                      _n.completeMission(id, route.missions[id]?.clueId);
                      _toast('${locations[id]?.title} voltooid');
                    }
                  },
                  child: const Text('Volgende stap openen'),
                ),
                FilledButton.tonal(
                  onPressed: () => _n.replace(
                    p.copyWith(
                      discoveredLocationIds: {
                        ...p.discoveredLocationIds,
                        ...route.locationIds,
                      },
                    ),
                  ),
                  child: const Text('Alle locaties ontgrendelen'),
                ),
                FilledButton.tonal(
                  onPressed: () {
                    _n.replace(
                      p.copyWith(
                        discoveredLocationIds: {
                          ...p.discoveredLocationIds,
                          ...route.locationIds,
                        },
                        completedMissionIds: {
                          ...p.completedMissionIds,
                          ...route.missionLocationIds,
                        },
                        clueIds: {
                          ...p.clueIds,
                          for (final id in route.missionLocationIds)
                            if (route.missions[id]?.clueId != null)
                              route.missions[id]!.clueId!,
                        },
                      ),
                    );
                    context.push('/final');
                  },
                  child: const Text('Eindmissie openen'),
                ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Eindmissie voltooid'),
              value: p.finalMissionCompleted,
              onChanged: _n.setFinalMissionCompleted,
            ),

            // ── Locations ────────────────────────────────────────────────────
            _Header('Locaties in ${route.title}'),
            for (final id in route.locationIds)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            p.statusOf(id, route).icon,
                            color: p.statusOf(id, route).color,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              locations[id]?.title ?? id,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(p.statusOf(id, route).label),
                        ],
                      ),
                      Wrap(
                        spacing: 4,
                        children: [
                          TextButton(
                            onPressed: () => _n.discoverLocation(id),
                            child: const Text('Ontgrendel'),
                          ),
                          if (id != route.endLocationId)
                            TextButton(
                              onPressed: () => _n.completeMission(
                                id,
                                route.missions[id]?.clueId,
                              ),
                              child: const Text('Voltooi'),
                            ),
                          if (id != route.endLocationId)
                            TextButton(
                              onPressed: () => _n.reopenMission(
                                id,
                                route.missions[id]?.clueId,
                              ),
                              child: const Text('Heropen missie'),
                            ),
                          TextButton(
                            onPressed: () => _n.lockLocation(id),
                            child: const Text('Vergrendel'),
                          ),
                          TextButton(
                            onPressed: () => context.push('/location/$id'),
                            child: const Text('Open'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],

          // ── Quiz ───────────────────────────────────────────────────────────
          _Header('Quizstatus'),
          _QuizRow(
            label: 'Voorkennisquiz',
            result: p.preQuiz,
            onClear: () => _n.clearQuiz('pre'),
            onMarkDone: () => _n.saveQuiz(
              QuizResult(
                quizId: 'pre',
                answers: const {},
                completedAt: DateTime.now(),
              ),
            ),
            onOpen: () => context.push('/quiz/pre'),
          ),
          _QuizRow(
            label: 'Eindquiz',
            result: p.postQuiz,
            onClear: () => _n.clearQuiz('post'),
            onMarkDone: () => _n.saveQuiz(
              QuizResult(
                quizId: 'post',
                answers: const {},
                completedAt: DateTime.now(),
              ),
            ),
            onOpen: () => context.push('/quiz/post'),
          ),

          // ── Storage ────────────────────────────────────────────────────────
          _Header('Opslag (SharedPreferences)'),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.anthracite,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SelectableText(
              _prettyStorage(ref.read(storageProvider).debugDump()),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () async {
              await _n.reset();
              ref.read(simulatedPositionProvider.notifier).set(null);
              ref.read(lastFixProvider.notifier).set(null);
              if (context.mounted) context.go('/');
            },
            icon: const Icon(Icons.delete_forever),
            label: const Text('Snelle reset (alles wissen)'),
          ),
        ],
      ),
    );
  }

  String _prettyStorage(Map<String, Object?> dump) {
    final decoded = dump.map((k, v) {
      if (v is String) {
        try {
          return MapEntry(k, jsonDecode(v));
        } catch (_) {}
      }
      return MapEntry(k, v);
    });
    return const JsonEncoder.withIndent('  ').convert(decoded);
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 8),
    child: Text(text, style: Theme.of(context).textTheme.titleLarge),
  );
}

class _QuizRow extends StatelessWidget {
  const _QuizRow({
    required this.label,
    required this.result,
    required this.onClear,
    required this.onMarkDone,
    required this.onOpen,
  });

  final String label;
  final QuizResult? result;
  final VoidCallback onClear;
  final VoidCallback onMarkDone;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ${result == null ? 'niet ingevuld' : '${result!.answers.length} antwoorden opgeslagen'}',
          ),
          Wrap(
            spacing: 4,
            children: [
              TextButton(onPressed: onOpen, child: const Text('Open')),
              TextButton(
                onPressed: onMarkDone,
                child: const Text('Markeer als ingevuld'),
              ),
              TextButton(onPressed: onClear, child: const Text('Wis')),
            ],
          ),
        ],
      ),
    );
  }
}

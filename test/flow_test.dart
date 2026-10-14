import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market_garden/app/app.dart';
import 'package:market_garden/data/locations.dart';
import 'package:market_garden/data/routes.dart';
import 'package:market_garden/models/mission_model.dart';
import 'package:market_garden/providers/providers.dart';
import 'package:market_garden/services/gps_service.dart';
import 'package:market_garden/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Walks the main flow: onboarding → route → pre quiz → GPS unlock → Hartenstein
/// mission (incl. a wrong answer and a hint) → clue → next location.
void main() {
  testWidgets('Hartenstein reference flow', (tester) async {
    tester.view.physicalSize = const Size(390, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final route = routeById('route_a')!;
    final mission = route.missions['hartenstein']!;
    final history = route.texts['hartenstein']!.historyText;

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = StorageService(prefs);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [storageProvider.overrideWithValue(storage)],
        child: const MarketGardenApp(),
      ),
    );
    await tester.pumpAndSettle();

    Future<void> tap(String text) async {
      final f = find.text(text).last;
      await tester.ensureVisible(f);
      await tester.pumpAndSettle();
      await tester.tap(f);
      await tester.pumpAndSettle();
    }

    await tap('Start de missie');
    expect(
      find.text('Gebruik je telefoon alleen wanneer je veilig stilstaat.'),
      findsOneWidget,
    );
    await tap('Begrepen');
    await tap('Verder');
    await tap('Samen');
    await tap('Kies Route A');
    // Pre-knowledge quiz comes after the route choice: skip it.
    expect(find.text('Overslaan'), findsOneWidget);
    await tap('Overslaan');
    expect(find.text('Jullie volgende missie'.toUpperCase()), findsOneWidget);

    await tap('Bekijk locatie');
    expect(find.text('Controleer mijn locatie'), findsOneWidget);
    // History text must not be visible before the GPS check.
    expect(find.text(history), findsNothing);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(MarketGardenApp)),
    );
    final h = locations['hartenstein']!;

    // Too far away first.
    container
        .read(simulatedPositionProvider.notifier)
        .set(SimulatedPosition(h.latitude + 300 / 111320, h.longitude, 10));
    await tap('Controleer mijn locatie');
    expect(find.textContaining('nog ongeveer'), findsOneWidget);

    // Now on the spot.
    container
        .read(simulatedPositionProvider.notifier)
        .set(SimulatedPosition(h.latitude, h.longitude, 10));
    await tap('Controleer mijn locatie');
    expect(find.text('LOCATIE ONTDEKT'), findsOneWidget);
    await tap('Open het dossier');
    expect(find.text(history), findsOneWidget);

    await tap('Start missie');
    for (final t in mission.tasks) {
      if (t.type == MissionType.textInput) {
        // First wrong + hint.
        await tester.enterText(find.byType(TextField), 'Maas');
        await tap('Controleer antwoord');
        expect(find.text('Nog niet helemaal.'), findsOneWidget);
        if (t.hints.isNotEmpty) {
          await tap('Toon een hint');
          expect(find.text(t.hints.first), findsOneWidget);
        }
        await tester.enterText(find.byType(TextField), t.acceptedAnswers.first);
      } else {
        for (final i in t.correctIndices) {
          await tap(t.options[i]);
        }
      }
      await tap('Controleer antwoord');
      expect(find.text('Nog niet helemaal.'), findsNothing, reason: t.id);
      await tap(
        t == mission.tasks.last ? 'Missie afronden' : 'Volgende opdracht',
      );
    }

    expect(find.text('Nieuwe aanwijzing ontdekt'), findsOneWidget);
    await tap('Verder');
    expect(find.text('MISSIE VOLTOOID'), findsOneWidget);

    // Progress is persisted and the next location is unlocked.
    final saved = storage.loadProgress();
    expect(saved.completedMissionIds, contains('hartenstein'));
    expect(saved.clueIds, contains(mission.clueId));
    expect(find.text(locations[route.locationIds[1]]!.title), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market_garden/app/app.dart';
import 'package:market_garden/app/router.dart';
import 'package:market_garden/data/routes.dart';
import 'package:market_garden/models/mission_model.dart';
import 'package:market_garden/models/progress_model.dart';
import 'package:market_garden/providers/providers.dart';
import 'package:market_garden/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('final mission → completion screen', (tester) async {
    tester.view.physicalSize = const Size(390, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final route = routeById('route_b')!;
    SharedPreferences.setMockInitialValues({});
    final storage = StorageService(await SharedPreferences.getInstance());
    await storage.saveProgress(
      ProgressState(
        routeId: route.id,
        mode: PlayMode.solo,
        safetyAccepted: true,
        discoveredLocationIds: route.locationIds.toSet(),
        completedMissionIds: route.missionLocationIds.toSet(),
        clueIds: {
          for (final id in route.missionLocationIds)
            route.missions[id]!.clueId!,
        },
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [storageProvider.overrideWithValue(storage)],
        child: const MarketGardenApp(),
      ),
    );
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(MarketGardenApp)),
    );
    container.read(routerProvider).go('/final');
    await tester.pumpAndSettle();

    Future<void> tap(Finder f) async {
      await tester.ensureVisible(f);
      await tester.pumpAndSettle();
      await tester.tap(f);
      await tester.pumpAndSettle();
    }

    Future<void> solveOrdering(MissionTask t) async {
      for (var k = 0; k < t.items.length; k++) {
        while (true) {
          final sorted = [...t.items]
            ..sort(
              (a, b) => tester
                  .getTopLeft(find.text(a))
                  .dy
                  .compareTo(tester.getTopLeft(find.text(b)).dy),
            );
          if (sorted.indexOf(t.items[k]) == k) break;
          await tap(
            find.descendant(
              of: find.byKey(ValueKey('order-$k')),
              matching: find.byTooltip('Omhoog'),
            ),
          );
        }
      }
    }

    Future<void> solveMatching(MissionTask t) async {
      for (var i = 0; i < t.pairs.length; i++) {
        await tap(find.byType(DropdownButtonFormField<int>).at(i));
        await tap(find.text(t.pairs[i].right).last);
      }
    }

    final finalMission = route.finalMission;
    for (final t in finalMission.tasks) {
      switch (t.type) {
        case MissionType.ordering:
          await solveOrdering(t);
        case MissionType.matching:
          await solveMatching(t);
        case MissionType.textInput:
          await tester.enterText(
            find.byType(TextField),
            t.acceptedAnswers.first,
          );
          await tester.pumpAndSettle();
        default:
          for (final i in t.correctIndices) {
            await tap(find.text(t.options[i]));
          }
      }
      await tap(find.textContaining(RegExp('^Controleer')));
      expect(find.text('Nog niet helemaal.'), findsNothing, reason: t.id);
      await tap(
        find.text(
          t == finalMission.tasks.last
              ? 'Missie afronden'
              : 'Volgende opdracht',
        ),
      );
    }

    expect(find.text('MISSIE VOLTOOID'), findsOneWidget);
    expect(
      find.text(
        'Je hebt het verhaal van Operatie Market Garden gereconstrueerd.',
      ),
      findsOneWidget,
    );
    expect(storage.loadProgress().finalMissionCompleted, isTrue);
    expect(container.read(routerProvider).state.matchedLocation, '/complete');
  });
}

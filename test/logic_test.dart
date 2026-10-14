import 'package:flutter_test/flutter_test.dart';
import 'package:market_garden/config/app_config.dart';
import 'package:market_garden/data/clues.dart';
import 'package:market_garden/data/locations.dart';
import 'package:market_garden/data/missions.dart';
import 'package:market_garden/data/routes.dart';
import 'package:market_garden/models/mission_model.dart';
import 'package:market_garden/models/progress_model.dart';
import 'package:market_garden/models/quiz_model.dart';
import 'package:market_garden/services/gps_service.dart';
import 'package:market_garden/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('GPS tolerance', () {
    GpsOutcome eval(double d, double acc) =>
        GpsService.evaluate(distance: d, accuracy: acc, radius: 75);

    test(
      'inside radius passes',
      () => expect(eval(40, 10), GpsOutcome.success),
    );
    test(
      'just outside radius passes thanks to accuracy bonus',
      () => expect(eval(95, 25), GpsOutcome.success),
    );
    test('bonus is capped', () => expect(eval(120, 60), GpsOutcome.tooFar));
    test('far away is too far', () => expect(eval(240, 10), GpsOutcome.tooFar));
    test(
      'very inaccurate fix is rejected',
      () => expect(eval(150, 300), GpsOutcome.poorAccuracy),
    );
    test(
      'inaccurate but clearly inside still passes',
      () => expect(eval(0, 75), GpsOutcome.success),
    );

    test('real distance Hartenstein -> John Frostbrug is ~5.4 km', () {
      final h = locations['hartenstein']!;
      final fix = Fix(h.latitude, h.longitude, 5);
      final d = GpsService.distanceTo(fix, locations['john_frostbrug']!);
      expect(d, inInclusiveRange(5000, 6000));
    });

    test('message mentions rounded distance', () {
      final msg = GpsService.message(
        const GpsCheckResult(GpsOutcome.tooFar, distanceMeters: 238),
        group: true,
      );
      expect(msg, contains('240 meter'));
      expect(msg, startsWith('Jullie'));
    });
  });

  group('Route progress', () {
    final route = routeById('route_a')!;

    test('first location is available, rest locked', () {
      const p = ProgressState();
      expect(p.statusOf(route.locationIds[0], route), LocationStatus.available);
      expect(p.statusOf(route.locationIds[1], route), LocationStatus.locked);
      expect(p.statusOf(route.endLocationId, route), LocationStatus.locked);
      expect(p.currentLocationId(route), route.locationIds[0]);
    });

    test('completing a mission unlocks the next location', () {
      final p = ProgressState(
        discoveredLocationIds: {route.locationIds[0]},
        completedMissionIds: {route.locationIds[0]},
      );
      expect(p.statusOf(route.locationIds[0], route), LocationStatus.completed);
      expect(p.statusOf(route.locationIds[1], route), LocationStatus.available);
      expect(p.currentLocationId(route), route.locationIds[1]);
    });

    test('final mission only available when all missions are done', () {
      final almost = ProgressState(
        completedMissionIds: route.missionLocationIds.skip(1).toSet(),
      );
      expect(almost.finalMissionAvailable(route), isFalse);
      final all = ProgressState(
        completedMissionIds: route.missionLocationIds.toSet(),
      );
      expect(all.finalMissionAvailable(route), isTrue);
      expect(
        all.statusOf(route.endLocationId, route),
        LocationStatus.available,
      );
      final done = all.copyWith(finalMissionCompleted: true);
      expect(
        done.statusOf(route.endLocationId, route),
        LocationStatus.completed,
      );
      expect(done.currentLocationId(route), isNull);
    });

    test('JSON round trip keeps everything', () {
      final p = ProgressState(
        routeId: 'route_b',
        mode: PlayMode.group,
        safetyAccepted: true,
        discoveredLocationIds: const {'hartenstein'},
        completedMissionIds: const {'hartenstein'},
        clueIds: const {'clue_distance'},
        preQuiz: QuizResult(
          quizId: 'pre',
          answers: const {'q_goal': 0},
          completedAt: DateTime(2026, 9, 17),
        ),
        finalMissionCompleted: true,
        reduceMotion: true,
      );
      final back = ProgressState.fromJson(p.toJson());
      expect(back.toJson(), p.toJson());
    });
  });

  group('Storage', () {
    test('saves and loads progress', () async {
      SharedPreferences.setMockInitialValues({});
      final s = StorageService(await SharedPreferences.getInstance());
      await s.saveProgress(const ProgressState(routeId: 'route_a'));
      expect(s.loadProgress().routeId, 'route_a');
      await s.clear();
      expect(s.loadProgress().routeId, isNull);
    });

    test('old storage version is ignored', () async {
      SharedPreferences.setMockInitialValues({
        'storageVersion': AppConfig.storageVersion - 1,
        'progress': '{"routeId":"route_a"}',
      });
      final s = StorageService(await SharedPreferences.getInstance());
      expect(s.loadProgress().routeId, isNull);
    });

    test('corrupt data does not crash', () async {
      SharedPreferences.setMockInitialValues({
        'storageVersion': AppConfig.storageVersion,
        'progress': 'not json',
      });
      final s = StorageService(await SharedPreferences.getInstance());
      expect(s.loadProgress().routeId, isNull);
    });
  });

  group('Answer checking', () {
    test('ordering', () {
      const t = MissionTask(
        id: 'o',
        type: MissionType.ordering,
        prompt: '',
        items: ['a', 'b', 'c'],
      );
      expect(t.isCorrect([0, 1, 2]), isTrue);
      expect(t.isCorrect([1, 0, 2]), isFalse);
    });

    test('matching', () {
      const t = MissionTask(
        id: 'm',
        type: MissionType.matching,
        prompt: '',
        pairs: [MatchPair('a', '1'), MatchPair('b', '2')],
      );
      expect(t.isCorrect({0: 0, 1: 1}), isTrue);
      expect(t.isCorrect({0: 1, 1: 0}), isFalse);
      expect(t.isCorrect({0: 0}), isFalse);
    });

    test('text input ignores case, spaces and accents', () {
      final t = missionsA['hartenstein']!.tasks.firstWhere(
        (t) => t.type == MissionType.textInput,
      );
      expect(t.isCorrect('  RIJN '), isTrue);
      expect(t.isCorrect('neder rijn'), isTrue);
      expect(t.isCorrect('Maas'), isFalse);
    });

    test('multi select needs exactly the right set', () {
      final t = missionsA['hartenstein']!.tasks.firstWhere(
        (t) => t.type == MissionType.informationCombination,
      );
      expect(t.isCorrect({0, 1}), isTrue);
      expect(t.isCorrect({0}), isFalse);
      expect(t.isCorrect({0, 1, 2}), isFalse);
    });
  });

  group('Content integrity', () {
    test('every route location exists and has a mission (except the end)', () {
      for (final r in routes) {
        for (final id in r.locationIds) {
          expect(locations[id], isNotNull, reason: '${r.id}: $id');
          expect(r.texts[id], isNotNull, reason: '${r.id}: text for $id');
        }
        for (final id in r.missionLocationIds) {
          expect(r.missions[id], isNotNull, reason: '${r.id}: mission for $id');
        }
        expect(r.endLocationId, 'john_frostbrug');
      }
    });

    test('all eight locations exist', () {
      expect(locations.length, greaterThanOrEqualTo(8));
    });

    test('every quiz question is answerable', () {
      for (final r in routes) {
        for (final q in [...r.preQuiz.questions, ...r.postQuiz.questions]) {
          expect(q.correctIndex, lessThan(q.options.length), reason: q.id);
        }
      }
    });

    test('every task is answerable', () {
      for (final m in [
        for (final r in routes) ...[...r.missions.values, r.finalMission],
      ]) {
        expect(
          m.clueId == null || clues.containsKey(m.clueId),
          isTrue,
          reason: m.id,
        );
        for (final t in m.tasks) {
          final reason = '${m.id}/${t.id}';
          switch (t.type) {
            case MissionType.ordering:
              expect(t.items.length, greaterThan(1), reason: reason);
            case MissionType.matching:
              expect(t.pairs.length, greaterThan(1), reason: reason);
            case MissionType.textInput:
              expect(t.acceptedAnswers, isNotEmpty, reason: reason);
            case MissionType.mapQuestion:
              expect(t.mapPoints.length, t.options.length, reason: reason);
              continue choice;
            choice:
            case MissionType.multipleChoice:
            case MissionType.trueFalse:
            case MissionType.imageObservation:
            case MissionType.informationCombination:
              expect(t.correctIndices, isNotEmpty, reason: reason);
              expect(
                t.correctIndices.every((i) => i < t.options.length),
                isTrue,
                reason: reason,
              );
          }
        }
      }
    });
  });
}

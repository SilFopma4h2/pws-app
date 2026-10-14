import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../data/routes.dart';
import '../models/progress_model.dart';
import '../models/quiz_model.dart';
import '../models/route_model.dart';
import '../services/gps_service.dart';
import '../services/navigation_service.dart';
import '../services/storage_service.dart';

/// Overridden in main() with the real instance.
final storageProvider = Provider<StorageService>(
  (ref) => throw UnimplementedError('storageProvider must be overridden'),
);

final gpsServiceProvider = Provider((ref) => const GpsService());
final navigationServiceProvider = Provider((ref) => const NavigationService());

/// All persisted progress. Every change is saved immediately.
class ProgressNotifier extends Notifier<ProgressState> {
  @override
  ProgressState build() => ref.read(storageProvider).loadProgress();

  void _set(ProgressState next) {
    state = next;
    ref.read(storageProvider).saveProgress(next);
  }

  void acceptSafety() => _set(state.copyWith(safetyAccepted: true));
  void setMode(PlayMode mode) => _set(state.copyWith(mode: mode));
  void selectRoute(String routeId) => _set(state.copyWith(routeId: routeId));
  void setReduceMotion(bool v) => _set(state.copyWith(reduceMotion: v));
  void unlockDevMode() => _set(state.copyWith(devModeUnlocked: true));

  void discoverLocation(String id) => _set(
    state.copyWith(discoveredLocationIds: {...state.discoveredLocationIds, id}),
  );

  void completeMission(String locationId, String? clueId) => _set(
    state.copyWith(
      discoveredLocationIds: {...state.discoveredLocationIds, locationId},
      completedMissionIds: {...state.completedMissionIds, locationId},
      clueIds: {...state.clueIds, ?clueId},
    ),
  );

  /// Developer Mode: make a location fully open again.
  void reopenMission(String locationId, String? clueId) => _set(
    state.copyWith(
      completedMissionIds: {...state.completedMissionIds}..remove(locationId),
      clueIds: {...state.clueIds}..remove(clueId),
    ),
  );

  void lockLocation(String locationId) => _set(
    state.copyWith(
      discoveredLocationIds: {...state.discoveredLocationIds}
        ..remove(locationId),
    ),
  );

  void completeFinalMission() =>
      _set(state.copyWith(finalMissionCompleted: true));

  void setFinalMissionCompleted(bool v) =>
      _set(state.copyWith(finalMissionCompleted: v));

  void saveQuiz(QuizResult result) => _set(
    result.quizId == 'pre'
        ? state.copyWith(preQuiz: result)
        : state.copyWith(postQuiz: result),
  );

  void clearQuiz(String quizId) => _set(
    quizId == 'pre'
        ? state.copyWith(clearPreQuiz: true)
        : state.copyWith(clearPostQuiz: true),
  );

  /// Developer Mode: replace everything at once.
  void replace(ProgressState next) => _set(next);

  Future<void> reset() async {
    await ref.read(storageProvider).clear();
    state = const ProgressState();
  }
}

final progressProvider = NotifierProvider<ProgressNotifier, ProgressState>(
  ProgressNotifier.new,
);

final selectedRouteProvider = Provider<RouteModel?>(
  (ref) => routeById(ref.watch(progressProvider.select((p) => p.routeId))),
);

final devModeProvider = Provider<bool>(
  (ref) =>
      AppConfig.developerMode ||
      ref.watch(progressProvider.select((p) => p.devModeUnlocked)),
);

/// Simulated GPS position from Developer Mode (not persisted).
class SimulatedPositionNotifier extends Notifier<SimulatedPosition?> {
  @override
  SimulatedPosition? build() => null;
  void set(SimulatedPosition? p) => state = p;
}

final simulatedPositionProvider =
    NotifierProvider<SimulatedPositionNotifier, SimulatedPosition?>(
      SimulatedPositionNotifier.new,
    );

/// Last known position, only set when the user pressed a GPS button.
class LastFixNotifier extends Notifier<Fix?> {
  @override
  Fix? build() => null;
  void set(Fix? f) => state = f;
}

final lastFixProvider = NotifierProvider<LastFixNotifier, Fix?>(
  LastFixNotifier.new,
);

/// Small helper for je/jullie texts.
String byMode(ProgressState p, String solo, String group) =>
    p.isGroup ? group : solo;

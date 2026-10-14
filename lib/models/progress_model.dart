import 'quiz_model.dart';
import 'route_model.dart';

enum PlayMode { solo, group }

enum LocationStatus {
  /// Previous location not finished yet.
  locked,

  /// Next destination: visible as preview, needs GPS check.
  available,

  /// GPS check passed, mission can be done.
  discovered,

  completed,
}

/// All persisted progress. Immutable; the ProgressNotifier swaps it out.
class ProgressState {
  const ProgressState({
    this.routeId,
    this.mode,
    this.safetyAccepted = false,
    this.discoveredLocationIds = const {},
    this.completedMissionIds = const {},
    this.clueIds = const {},
    this.preQuiz,
    this.postQuiz,
    this.finalMissionCompleted = false,
    this.reduceMotion = false,
    this.devModeUnlocked = false,
  });

  final String? routeId;
  final PlayMode? mode;
  final bool safetyAccepted;
  final Set<String> discoveredLocationIds;

  /// Location ids whose mission is finished.
  final Set<String> completedMissionIds;
  final Set<String> clueIds;
  final QuizResult? preQuiz;
  final QuizResult? postQuiz;
  final bool finalMissionCompleted;
  final bool reduceMotion;
  final bool devModeUnlocked;

  bool get isGroup => mode == PlayMode.group;

  bool allMissionsDone(RouteModel route) =>
      route.missionLocationIds.every(completedMissionIds.contains);

  bool finalMissionAvailable(RouteModel route) => allMissionsDone(route);

  LocationStatus statusOf(String locationId, RouteModel route) {
    if (locationId == route.endLocationId) {
      if (finalMissionCompleted) return LocationStatus.completed;
      if (!allMissionsDone(route)) return LocationStatus.locked;
      return discoveredLocationIds.contains(locationId)
          ? LocationStatus.discovered
          : LocationStatus.available;
    }
    if (completedMissionIds.contains(locationId)) {
      return LocationStatus.completed;
    }
    if (discoveredLocationIds.contains(locationId)) {
      return LocationStatus.discovered;
    }
    final index = route.locationIds.indexOf(locationId);
    if (index == 0 ||
        (index > 0 &&
            completedMissionIds.contains(route.locationIds[index - 1]))) {
      return LocationStatus.available;
    }
    return LocationStatus.locked;
  }

  /// The location the group should work on now, or null when all is done.
  String? currentLocationId(RouteModel route) {
    for (final id in route.locationIds) {
      final s = statusOf(id, route);
      if (s == LocationStatus.available || s == LocationStatus.discovered) {
        return id;
      }
    }
    return null;
  }

  ProgressState copyWith({
    String? routeId,
    PlayMode? mode,
    bool? safetyAccepted,
    Set<String>? discoveredLocationIds,
    Set<String>? completedMissionIds,
    Set<String>? clueIds,
    QuizResult? preQuiz,
    QuizResult? postQuiz,
    bool clearPreQuiz = false,
    bool clearPostQuiz = false,
    bool? finalMissionCompleted,
    bool? reduceMotion,
    bool? devModeUnlocked,
  }) => ProgressState(
    routeId: routeId ?? this.routeId,
    mode: mode ?? this.mode,
    safetyAccepted: safetyAccepted ?? this.safetyAccepted,
    discoveredLocationIds: discoveredLocationIds ?? this.discoveredLocationIds,
    completedMissionIds: completedMissionIds ?? this.completedMissionIds,
    clueIds: clueIds ?? this.clueIds,
    preQuiz: clearPreQuiz ? null : (preQuiz ?? this.preQuiz),
    postQuiz: clearPostQuiz ? null : (postQuiz ?? this.postQuiz),
    finalMissionCompleted: finalMissionCompleted ?? this.finalMissionCompleted,
    reduceMotion: reduceMotion ?? this.reduceMotion,
    devModeUnlocked: devModeUnlocked ?? this.devModeUnlocked,
  );

  Map<String, dynamic> toJson() => {
    'routeId': routeId,
    'mode': mode?.name,
    'safetyAccepted': safetyAccepted,
    'discoveredLocationIds': discoveredLocationIds.toList(),
    'completedMissionIds': completedMissionIds.toList(),
    'clueIds': clueIds.toList(),
    'preQuiz': preQuiz?.toJson(),
    'postQuiz': postQuiz?.toJson(),
    'finalMissionCompleted': finalMissionCompleted,
    'reduceMotion': reduceMotion,
    'devModeUnlocked': devModeUnlocked,
  };

  factory ProgressState.fromJson(Map<String, dynamic> json) {
    Set<String> strings(String key) =>
        ((json[key] as List?) ?? const []).cast<String>().toSet();
    QuizResult? quiz(String key) => json[key] == null
        ? null
        : QuizResult.fromJson((json[key] as Map).cast<String, dynamic>());
    final modeName = json['mode'] as String?;
    return ProgressState(
      routeId: json['routeId'] as String?,
      mode: modeName == null ? null : PlayMode.values.byName(modeName),
      safetyAccepted: json['safetyAccepted'] as bool? ?? false,
      discoveredLocationIds: strings('discoveredLocationIds'),
      completedMissionIds: strings('completedMissionIds'),
      clueIds: strings('clueIds'),
      preQuiz: quiz('preQuiz'),
      postQuiz: quiz('postQuiz'),
      finalMissionCompleted: json['finalMissionCompleted'] as bool? ?? false,
      reduceMotion: json['reduceMotion'] as bool? ?? false,
      devModeUnlocked: json['devModeUnlocked'] as bool? ?? false,
    );
  }
}

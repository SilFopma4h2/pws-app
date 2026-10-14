import 'location_model.dart';
import 'mission_model.dart';
import 'quiz_model.dart';

class RouteModel {
  const RouteModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.locationIds,
    required this.estimatedDistance,
    required this.estimatedDuration,
    required this.difficulty,
    required this.texts,
    required this.missions,
    required this.finalMission,
    required this.preQuiz,
    required this.postQuiz,
    this.imageAsset,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;

  /// Volgorde waarin de locaties bezocht worden. De laatste locatie is de
  /// plek van de eindmissie.
  final List<String> locationIds;

  final String estimatedDistance;
  final String estimatedDuration;
  final String difficulty;
  final String? imageAsset;

  /// Inhoud op het niveau van deze route, per locatie-id.
  final Map<String, LocationText> texts;
  final Map<String, Mission> missions;
  final Mission finalMission;
  final Quiz preQuiz;
  final Quiz postQuiz;

  String get startLocationId => locationIds.first;
  String get endLocationId => locationIds.last;

  /// Locaties met een gewone missie (alles behalve het eindpunt).
  List<String> get missionLocationIds =>
      locationIds.sublist(0, locationIds.length - 1);
}

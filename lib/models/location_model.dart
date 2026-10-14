import 'package:latlong2/latlong.dart';

import '../config/app_config.dart';
import 'source_model.dart';

class HistoricalLocation {
  const HistoricalLocation({
    required this.id,
    required this.title,
    required this.place,
    required this.latitude,
    required this.longitude,
    required this.imageAsset,
    this.imageCaption,
    this.gpsRadiusMeters = AppConfig.defaultGpsRadius,
    this.sources = const [],
  });

  final String id;
  final String title;

  /// Oosterbeek, Driel of Arnhem.
  final String place;
  final String imageAsset;
  final String? imageCaption;
  final double latitude;
  final double longitude;
  final double gpsRadiusMeters;
  final List<HistoricalSource> sources;

  LatLng get position => LatLng(latitude, longitude);
}

/// Teksten bij een locatie. Verschilt per route, omdat iedere route een
/// eigen niveau heeft.
class LocationText {
  const LocationText({
    required this.teaser,
    required this.shortDescription,
    required this.historyText,
    this.readMoreText,
  });

  /// Korte tekst in de preview, vóór de GPS-controle.
  final String teaser;

  /// Eerste alinea op de ontgrendelde locatiepagina.
  final String shortDescription;

  final String historyText;
  final String? readMoreText;
}

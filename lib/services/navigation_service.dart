import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/location_model.dart';

enum MapsApp { apple, google }

/// Opens external navigation apps. The app itself does no turn-by-turn.
class NavigationService {
  const NavigationService();

  bool get isIOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  Uri _googleWeb(HistoricalLocation l) => Uri.parse(
    'https://www.google.com/maps/dir/?api=1'
    '&destination=${l.latitude},${l.longitude}&travelmode=bicycling',
  );

  Future<bool> hasGoogleMapsApp() async {
    if (!isIOS) return false;
    try {
      return await canLaunchUrl(Uri.parse('comgooglemaps://'));
    } catch (_) {
      return false;
    }
  }

  /// Tries the native app first, then falls back to the Google Maps website.
  Future<bool> navigateTo(HistoricalLocation l, {MapsApp? app}) async {
    final candidates = <Uri>[];
    if (isIOS) {
      if (app == MapsApp.google) {
        candidates.add(
          Uri.parse(
            'comgooglemaps://?daddr=${l.latitude},${l.longitude}&directionsmode=bicycling',
          ),
        );
      } else {
        candidates.add(
          Uri.parse(
            'https://maps.apple.com/?daddr=${l.latitude},${l.longitude}',
          ),
        );
      }
    } else if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      candidates.add(
        Uri.parse('google.navigation:q=${l.latitude},${l.longitude}&mode=b'),
      );
    }
    candidates.add(_googleWeb(l));

    for (final uri in candidates) {
      try {
        if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          return true;
        }
      } catch (_) {
        // Try the next option.
      }
    }
    return false;
  }

  Future<bool> openUrl(String url) async {
    try {
      return await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      return false;
    }
  }
}

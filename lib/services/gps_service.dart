import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../config/app_config.dart';
import '../models/location_model.dart';

enum GpsOutcome {
  success,
  tooFar,
  permissionDenied,
  permissionDeniedForever,
  serviceDisabled,
  unavailable,
  timeout,
  poorAccuracy,
}

class GpsCheckResult {
  const GpsCheckResult(this.outcome, {this.distanceMeters, this.accuracy});

  final GpsOutcome outcome;
  final double? distanceMeters;
  final double? accuracy;

  bool get success => outcome == GpsOutcome.success;
}

/// A position set from Developer Mode instead of real GPS.
class SimulatedPosition {
  const SimulatedPosition(this.latitude, this.longitude, this.accuracy);
  final double latitude;
  final double longitude;
  final double accuracy;
}

/// Simple position value (real or simulated).
class Fix {
  const Fix(this.latitude, this.longitude, this.accuracy);
  final double latitude;
  final double longitude;
  final double accuracy;
}

/// GPS is only read when the user presses a button. Nothing is tracked
/// in the background.
class GpsService {
  const GpsService();

  /// Tolerance logic:
  /// 1. If the phone reports accuracy worse than
  ///    [AppConfig.maxAcceptedAccuracyMeters], the fix is not trusted
  ///    (poorAccuracy) – unless the distance is clearly within the radius
  ///    even in the worst case.
  /// 2. Otherwise the user passes when
  ///      distance - min(accuracy, maxAccuracyBonusMeters) <= radius.
  ///    So someone standing on the spot with a 20 m GPS error is not
  ///    rejected, but the bonus is capped so the radius stays the main limit.
  static GpsOutcome evaluate({
    required double distance,
    required double accuracy,
    required double radius,
  }) {
    if (distance + accuracy <= radius) return GpsOutcome.success;
    if (accuracy > AppConfig.maxAcceptedAccuracyMeters) {
      return GpsOutcome.poorAccuracy;
    }
    final bonus = accuracy.clamp(0, AppConfig.maxAccuracyBonusMeters);
    return distance - bonus <= radius ? GpsOutcome.success : GpsOutcome.tooFar;
  }

  static double distanceTo(Fix fix, HistoricalLocation loc) =>
      Geolocator.distanceBetween(
        fix.latitude,
        fix.longitude,
        loc.latitude,
        loc.longitude,
      );

  /// Reads the current position once. Returns the fix, or an error outcome
  /// when that fails.
  Future<(Fix?, GpsOutcome?)> currentFix({SimulatedPosition? simulated}) async {
    if (simulated != null) {
      return (
        Fix(simulated.latitude, simulated.longitude, simulated.accuracy),
        null,
      );
    }
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return (null, GpsOutcome.serviceDisabled);
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        return (null, GpsOutcome.permissionDeniedForever);
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.unableToDetermine) {
        return (null, GpsOutcome.permissionDenied);
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: AppConfig.gpsTimeout,
        ),
      );
      return (Fix(pos.latitude, pos.longitude, pos.accuracy), null);
    } on TimeoutException {
      return (null, GpsOutcome.timeout);
    } on PermissionDeniedException {
      return (null, GpsOutcome.permissionDenied);
    } on LocationServiceDisabledException {
      return (null, GpsOutcome.serviceDisabled);
    } catch (_) {
      return (null, GpsOutcome.unavailable);
    }
  }

  Future<GpsCheckResult> checkAt(
    HistoricalLocation location, {
    SimulatedPosition? simulated,
  }) async {
    final (fix, error) = await currentFix(simulated: simulated);
    if (fix == null) return GpsCheckResult(error ?? GpsOutcome.unavailable);
    final distance = distanceTo(fix, location);
    return GpsCheckResult(
      evaluate(
        distance: distance,
        accuracy: fix.accuracy,
        radius: location.gpsRadiusMeters,
      ),
      distanceMeters: distance,
      accuracy: fix.accuracy,
    );
  }

  /// User-facing Dutch message. [group] switches je/jullie.
  static String message(GpsCheckResult r, {required bool group}) {
    final je = group ? 'jullie' : 'je';
    final jeCap = group ? 'Jullie' : 'Je';
    final zijn = group ? 'zijn' : 'bent';
    switch (r.outcome) {
      case GpsOutcome.success:
        return 'Locatie ontdekt!';
      case GpsOutcome.tooFar:
        final d = r.distanceMeters ?? 0;
        final rounded = d >= 1000
            ? '${(d / 1000).toStringAsFixed(1).replaceAll('.', ',')} kilometer'
            : '${(d / 10).round() * 10} meter';
        return '$jeCap $zijn nog ongeveer $rounded van deze locatie verwijderd. '
            'Fiets veilig verder en probeer het opnieuw als $je er $zijn.';
      case GpsOutcome.permissionDenied:
        return 'De app mag $je locatie nog niet gebruiken. Sta locatietoegang '
            'toe om deze plek te ontgrendelen.';
      case GpsOutcome.permissionDeniedForever:
        return 'Locatietoegang staat uit voor deze app. Zet dit aan in de '
            'instellingen van $je telefoon en probeer het opnieuw.';
      case GpsOutcome.serviceDisabled:
        return 'Locatievoorzieningen (GPS) staan uit. Zet ze aan en probeer '
            'het opnieuw.';
      case GpsOutcome.unavailable:
        return 'We kunnen $je locatie op dit moment niet bepalen. Probeer het '
            'over een paar seconden opnieuw.';
      case GpsOutcome.timeout:
        return 'Het bepalen van $je locatie duurt te lang. Ga eventueel even '
            'op een open plek staan en probeer het opnieuw.';
      case GpsOutcome.poorAccuracy:
        return 'We kunnen $je locatie nog niet nauwkeurig genoeg bepalen. '
            'Controleer of locatievoorzieningen aanstaan en probeer het '
            'opnieuw.';
    }
  }
}

/// Central switches for the prototype. Change values here, not in widgets.
class AppConfig {
  AppConfig._();

  // AANPASBARE PWS-INHOUD: naam en ondertitel van de app.
  static const String appTitle = 'MISSIE MARKET GARDEN';
  static const String appSubtitle = 'Een interactieve historische fietsmissie';
  static const String appVersion = '0.1.0';

  /// true = Developer Mode is direct zichtbaar in Instellingen.
  /// false = alleen bereikbaar door 7x op het versienummer te tikken.
  /// Zet op false voordat leerlingen de app gebruiken.
  static const bool developerMode = true;

  static const bool enablePreQuiz = true;
  static const bool enablePostQuiz = true;

  /// Standaard GPS-straal als een locatie zelf geen straal opgeeft.
  static const double defaultGpsRadius = 40;

  /// Maximale extra tolerantie (meters) die we geven op basis van de
  /// gemelde GPS-nauwkeurigheid. Zie GpsService.evaluate.
  static const double maxAccuracyBonusMeters = 30;

  /// Boven deze onnauwkeurigheid (meters) vertrouwen we de meting niet.
  static const double maxAcceptedAccuracyMeters = 100;

  static const Duration gpsTimeout = Duration(seconds: 20);

  /// Verhoog dit getal als het opslagmodel verandert: oude voortgang wordt
  /// dan bij de volgende start automatisch gewist.
  static const int storageVersion = 1;

  /// Gebruikt door OpenStreetMap om de app te identificeren.
  static const String mapUserAgentPackage = 'nl.pws.market_garden';
}

// AANPASBARE PWS-INHOUD
// Alle historische locaties staan in dit bestand: naam, coördinaten,
// GPS-straal, afbeelding en bronnen. De teksten per niveau staan in
// lib/data/location_texts.dart.
//
// Coördinaten komen uit OpenStreetMap (okt 2026) en wijzen naar de plek waar
// je met de fiets staat (ingang/infobord). Controleer ze ter plekke of in
// Google Maps (rechtsklik > coördinaten kopiëren) voordat leerlingen fietsen.

import '../models/location_model.dart';
import '../models/source_model.dart';

const _airborneMuseum = HistoricalSource(
  title: 'Airborne Museum Hartenstein',
  organization: 'Airborne Museum',
  url: 'https://www.airbornemuseum.nl',
);

const _cwgc = HistoricalSource(
  title: 'Arnhem Oosterbeek War Cemetery',
  organization: 'Commonwealth War Graves Commission',
  url: 'https://www.cwgc.org',
);

const _tracesOfWar = HistoricalSource(
  title: 'Slag om Arnhem – overzicht',
  organization: 'TracesOfWar',
  url: 'https://www.tracesofwar.nl',
);

const _bridgeMuseum = HistoricalSource(
  title: 'Airborne at the Bridge',
  organization: 'Airborne at the Bridge',
  url: 'https://www.airborneatthebridge.nl',
);

const Map<String, HistoricalLocation> locations = {
  'hartenstein': HistoricalLocation(
    id: 'hartenstein',
    title: 'Airborne Museum Hartenstein',
    place: 'Oosterbeek',
    imageAsset: 'assets/images/locations/hartenstein.jpg',
    imageCaption: 'Villa Hartenstein, Oosterbeek',
    latitude: 51.98785,
    longitude: 5.83310,
    sources: [_airborneMuseum, _tracesOfWar],
  ),
  'cemetery': HistoricalLocation(
    id: 'cemetery',
    title: 'Airborne War Cemetery',
    place: 'Oosterbeek',
    imageAsset: 'assets/images/locations/cemetery.jpg',
    imageCaption: 'Arnhem Oosterbeek War Cemetery',
    latitude: 51.99350,
    longitude: 5.84877,
    sources: [_cwgc],
  ),
  'oude_kerk': HistoricalLocation(
    id: 'oude_kerk',
    title: 'De Oude Kerk',
    place: 'Oosterbeek',
    imageAsset: 'assets/images/locations/oude_kerk.jpg',
    imageCaption: 'De Oude Kerk aan de Benedendorpsweg',
    latitude: 51.97822,
    longitude: 5.83778,
    sources: [_airborneMuseum, _tracesOfWar],
  ),
  'mortierput': HistoricalLocation(
    id: 'mortierput',
    title: 'De Mortierput',
    place: 'Oosterbeek',
    imageAsset: 'assets/images/locations/mortierput.jpg',
    imageCaption: 'Beukenlaan in de bossen van Oosterbeek',
    latitude: 51.98655,
    longitude: 5.82925,
    sources: [_tracesOfWar],
  ),
  'dreyeroord': HistoricalLocation(
    id: 'dreyeroord',
    title: 'Hotel Dreyeroord',
    place: 'Oosterbeek',
    imageAsset: 'assets/images/locations/dreyeroord.jpg',
    imageCaption: 'Hotel Dreyeroord, “Het Witte Huis”',
    latitude: 51.99400,
    longitude: 5.83800,
    sources: [_airborneMuseum, _tracesOfWar],
  ),
  'drielse_veer': HistoricalLocation(
    id: 'drielse_veer',
    title: 'Het Drielse Veer',
    place: 'Driel',
    imageAsset: 'assets/images/locations/drielse_veer.jpg',
    imageCaption: 'Het Engineers-monument bij de Rijn in Driel',
    latitude: 51.97155,
    longitude: 5.82510,
    sources: [_tracesOfWar],
  ),
  'airborne_bridge': HistoricalLocation(
    id: 'airborne_bridge',
    title: 'Airborne at the Bridge',
    place: 'Arnhem',
    imageAsset: 'assets/images/locations/airborne_bridge.jpg',
    imageCaption: 'Airborne-monument bij de John Frostbrug',
    latitude: 51.97640,
    longitude: 5.90925,
    sources: [_bridgeMuseum],
  ),
  'john_frostbrug': HistoricalLocation(
    id: 'john_frostbrug',
    title: 'De John Frostbrug',
    place: 'Arnhem',
    imageAsset: 'assets/images/locations/john_frostbrug.jpg',
    imageCaption: 'De John Frostbrug over de Rijn',
    latitude: 51.97580,
    longitude: 5.91234,
    sources: [_bridgeMuseum, _tracesOfWar],
  ),
};

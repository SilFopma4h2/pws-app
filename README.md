# Missie Market Garden

Een educatieve fietsmissie over **Operatie Market Garden** en de **Slag om Arnhem**, gemaakt als prototype voor ons profielwerkstuk (PWS).

Leerlingen (ca. 10–16 jaar) fietsen langs echte historische locaties in Oosterbeek, Driel en Arnhem. Op iedere plek ontgrendelen ze met GPS een "dossier", lezen ze een stuk van het verhaal en voeren ze een opdracht uit. Elke voltooide missie levert een aanwijzing op voor het missieboek. Bij de John Frostbrug komt alles samen in de eindmissie: *Waarom slaagde Operatie Market Garden bij Arnhem niet zoals gepland?*

Er zijn geen punten, geen scores en geen timers. Voortgang zie je aan ontdekte locaties, voltooide missies en verzamelde aanwijzingen.

---

## Benodigdheden

- **Flutter SDK** 3.47 of nieuwer (met Dart 3.13; getest met Flutter 3.47.7), zie <https://docs.flutter.dev/get-started/install>
- Een IDE: **VS Code** (met de Flutter-extensie) of **Android Studio**
- Iets om de app op te draaien:
  - Android-telefoon of -emulator (Android Studio)
  - iPhone of iOS-simulator (alleen op een Mac, met Xcode)
  - Google Chrome (Flutter Web)

Controleer je installatie met:

```bash
flutter doctor
```

## Installeren

```bash
cd pws-app
flutter pub get
```

## Starten

```bash
flutter run              # kiest een aangesloten telefoon/emulator
flutter run -d chrome    # in Chrome op je laptop
```

Handig tijdens het ontwikkelen: druk in de terminal op `r` (hot reload) na het aanpassen van teksten of data.

## Gebruikte packages

| Package | Waarvoor |
|---|---|
| `flutter_riverpod` | Globale status (route, voortgang, instellingen) |
| `go_router` | Navigatie tussen schermen |
| `flutter_map` + `latlong2` | OpenStreetMap-kaart met markers en routelijn |
| `geolocator` | GPS-positie (alleen op knopdruk) en afstandsberekening |
| `shared_preferences` | Voortgang lokaal opslaan |
| `url_launcher` | Externe navigatie (Google Maps / Apple Kaarten) en bronnen openen |

Lettertypen (Zilla Slab, Special Elite) zitten lokaal in `assets/fonts/` (open licentie), zodat ze ook offline werken.

---

## Projectstructuur

```
lib/
  main.dart                 Start van de app
  app/
    app.dart                MaterialApp
    router.dart             Alle schermen/URL's
    theme.dart              Kleuren, lettertypen, knopstijlen
  config/
    app_config.dart         Centrale schakelaars (developer mode, GPS-straal, quizzen)
  models/                   Datamodellen (route, locatie, missie, aanwijzing, quiz, voortgang)
  data/                     ★ ALLE INHOUD (zie hieronder)
    routes.dart             Route A en Route B
    locations.dart          De locaties: teksten, coördinaten, GPS-straal, bronnen
    missions.dart           Opdrachten per locatie
    final_mission.dart      De eindmissie
    clues.dart              Aanwijzingen
    quizzes.dart            Voorkennisquiz en eindquiz
  services/
    gps_service.dart        GPS-controle + tolerantielogica + foutmeldingen
    storage_service.dart    Opslaan/laden (enige plek die SharedPreferences gebruikt)
    navigation_service.dart Externe navigatie-apps openen
  providers/providers.dart  Riverpod-status (voortgang, gesimuleerde GPS)
  screens/                  Alle schermen (start, route, kaart, locatie, missie, ...)
  widgets/
    common/                 Herbruikbare onderdelen (dossierkaart, afbeelding, bronnen)
    missions/               Eén widget per opdrachtsoort + de missie-engine
    map/                    Kaarttekening en statuskleuren
assets/
  images/locations/         Foto's van de locaties
  images/documents/         Historische afbeeldingen voor opdrachten
  images/maps/              Eventuele kaartafbeeldingen
  fonts/                    Lettertypen
test/                       Automatische tests
```

Alle plekken met inhoud die jullie mogen aanpassen zijn gemarkeerd met:

```dart
// AANPASBARE PWS-INHOUD
```

---

## Routes aanpassen

Bestand: **`lib/data/routes.dart`**

Iedere route heeft een lijst `locationIds`. De volgorde in die lijst is de fietsvolgorde.

- De **eerste** id is het startpunt.
- De **laatste** id is de plek van de **eindmissie** (nu voor beide routes `john_frostbrug`).

```dart
RouteModel(
  id: 'route_a',
  title: 'Route A',
  subtitle: 'De perimeter van Oosterbeek',
  locationIds: ['hartenstein', 'cemetery', 'mortierput', 'dreyeroord', 'oude_kerk', 'john_frostbrug'],
  estimatedDistance: 'ca. 14 km',
  estimatedDuration: 'ca. 3 uur',
  ...
),
```

Een locatie verplaatsen naar de andere route = de id in de andere lijst zetten. De app-logica is voor beide routes hetzelfde; je hoeft verder niets aan te passen.

## Locaties aanpassen

Bestand: **`lib/data/locations.dart`**

Per locatie:

| Veld | Betekenis |
|---|---|
| `title` | Naam van de locatie |
| `place` | Oosterbeek / Driel / Arnhem |
| `teaser` | Korte tekst in de preview (vóór de GPS-check) |
| `shortDescription` | Eerste vetgedrukte alinea na ontgrendelen |
| `historyText` | De historische uitleg (gebruik `\n\n` voor een nieuwe alinea) |
| `readMoreText` | Optionele extra tekst achter "Lees meer" |
| `latitude`, `longitude` | **GPS-coördinaten** |
| `gpsRadiusMeters` | **GPS-straal** in meters (standaard 40, zie `AppConfig.defaultGpsRadius`) |
| `imageAsset` | Pad naar de foto |
| `sources` | Bronnen |

> ⚠️ De huidige coördinaten zijn **benaderingen**. Controleer ze voordat leerlingen gaan fietsen: rechtsklik in Google Maps op de juiste plek → de coördinaten worden gekopieerd.

## Missies aanpassen

Bestand: **`lib/data/missions.dart`** (eindmissie: **`lib/data/final_mission.dart`**)

Een missie bestaat uit een of meer opdrachten (`tasks`). Iedere opdracht heeft een `type`:

| Type | Wat de leerling doet | Goede antwoord staat in |
|---|---|---|
| `multipleChoice` | Eén of meer antwoorden kiezen | `correctIndices` |
| `trueFalse` | Juist/onjuist | `correctIndices` (0 = Juist, 1 = Onjuist) |
| `imageObservation` | Afbeelding bekijken + kiezen | `correctIndices` |
| `informationCombination` | Dossierstukken combineren, meerdere antwoorden | `correctIndices` |
| `mapQuestion` | Punt kiezen op een schematische kaart | `correctIndices` |
| `ordering` | Gebeurtenissen in volgorde slepen | `items` (in de **goede** volgorde, de app husselt) |
| `matching` | Persoon ↔ rol koppelen | `pairs` (goede combinaties, de app husselt) |
| `textInput` | Kort antwoord/code typen | `acceptedAnswers` (hoofdletters/spaties maken niet uit) |

`correctIndices` telt vanaf 0: `{0}` = eerste optie, `{1, 2}` = tweede én derde optie. Met meer dan één goed antwoord wordt het automatisch een meerkeuzevraag met vinkjes.

Verder per opdracht:

- `hints` – hints die de leerling na een fout antwoord één voor één kan openen
- `wrongFeedback` – vriendelijke tekst bij een fout antwoord
- `explanation` – uitleg na een goed antwoord
- `infoCards` – korte dossierstukjes boven de vraag

Per missie: `intro`, `completionText`, `keyInsight` (komt in het missieboek onder "Belangrijke kennis") en `clueId`.

**Kaartopdrachten** gebruiken een schematische kaart die offline werkt. Posities (`MapPoint`, `MapLabel`) lopen van `0` tot `1` (links→rechts, boven→onder). De Rijn ligt ongeveer op hoogte `y = 0.6`.

`tone: MissionTone.respectful` (zoals bij de begraafplaats) zet animaties en "Goed gezien!"-teksten uit.

## Aanwijzingen aanpassen

Bestand: **`lib/data/clues.dart`**. Types: letter, nummer, kaartfragment, naam, historisch feit, document, symbool, tijdlijnfragment. Een missie verwijst ernaar met `clueId`.

## Quizzen aanpassen

Bestand: **`lib/data/quizzes.dart`**. Vragen met dezelfde `id` in voor- en eindquiz worden vergeleken. Antwoorden worden opgeslagen als `QuizResult` (vraag-id → gekozen optie + tijdstip). Die structuur is geschikt om later naar CSV te exporteren (export is nog niet gebouwd).

Quizzen uitzetten: `enablePreQuiz` / `enablePostQuiz` in `lib/config/app_config.dart`.

## Afbeeldingen toevoegen

Zet foto's in `assets/images/locations/` met precies deze namen:

```
hartenstein.jpg   cemetery.jpg      oude_kerk.jpg      mortierput.jpg
dreyeroord.jpg    drielse_veer.jpg  airborne_bridge.jpg john_frostbrug.jpg
```

De historische afbeelding voor de Mortierput-opdracht: `assets/images/documents/mortierput_1944.jpg`.

Andere naam of formaat (bijv. `.png`)? Pas dan `imageAsset` aan in `locations.dart` of `missions.dart`. Ontbreekt een bestand, dan toont de app automatisch een nette placeholder. Na het toevoegen van nieuwe bestanden: app helemaal opnieuw starten (hot reload is niet genoeg).

Let op auteursrecht bij historische foto's: noem de bron (bijvoorbeeld via `imageCaption` en `sources`).

De huidige foto's komen van Wikimedia Commons (CC0, publiek domein, CC BY of CC BY-SA). Maker, licentie en link staan in **`lib/data/photo_credits.dart`** en worden getoond op het Info-scherm. Vervang je een foto, werk die lijst dan ook bij.

## Bronnen aanpassen

Bovenaan **`lib/data/locations.dart`** staan bronnen als `HistoricalSource(title, organization, url)`. Per locatie kies je welke bronnen getoond worden via `sources: [...]`. Ze verschijnen achter het kleine knopje "Bronnen".

## Teksten op schermen

Historische inhoud staat in `lib/data/`. Introductie- en uitlegteksten staan bovenaan het bijbehorende scherm (gemarkeerd met `AANPASBARE PWS-INHOUD`), bijvoorbeeld `lib/screens/start/intro_screen.dart` en `lib/screens/info/info_screen.dart`. Naam en ondertitel van de app: `lib/config/app_config.dart`.

---

## Developer Mode

Hiermee testen jullie de app zonder naar iedere locatie te fietsen.

**Activeren:**

- Nu staat `developerMode = true` in `lib/config/app_config.dart`. Dan staat **Developer Mode** onderaan **Instellingen** (tandwiel rechtsboven).
- Voor leerlingen: zet `developerMode = false`. Developer Mode is dan verborgen, maar nog bereikbaar door in Instellingen **7× op het versienummer** te tikken.

**Mogelijkheden:**

- GPS simuleren (op een locatie, 90 m of 300 m ernaast, met verschillende nauwkeurigheid)
- Route wisselen
- "Volgende stap openen", alle locaties ontgrendelen, eindmissie openen
- Per locatie: ontgrendelen, voltooien, missie heropenen, vergrendelen
- Quizstatus wissen / als ingevuld markeren
- Opgeslagen data (SharedPreferences) bekijken
- Snelle reset

## GPS testen

1. Open Developer Mode → **GPS simuleren**.
2. Kies een locatie en tik op **Op locatie**.
3. Ga naar die locatie in de app en tik op **Controleer mijn locatie**. De locatie wordt ontgrendeld.
4. Test meldingen met **300 m ernaast** ("nog ongeveer 300 meter") of nauwkeurigheid **±150 m** ("niet nauwkeurig genoeg").
5. **Uit (echte GPS)** zet de echte GPS weer aan. De simulatie wordt niet opgeslagen en staat na een herstart dus weer uit.

In de Android-emulator kun je ook een nep-locatie instellen (⋯ → Location); in de iOS-simulator via Features → Location.

### Hoe de GPS-controle werkt

- GPS wordt **alleen** gelezen als de leerling op de knop drukt. De app volgt niemand op de achtergrond.
- Afstand: `Geolocator.distanceBetween` (correcte afstand over de aardbol).
- Tolerantie (`GpsService.evaluate` in `lib/services/gps_service.dart`):
  - geslaagd als `afstand − min(nauwkeurigheid, 30 m) ≤ gpsRadius`;
  - is de gemelde onnauwkeurigheid groter dan 100 m, dan vragen we om het opnieuw te proberen (tenzij de leerling zelfs in het slechtste geval binnen de straal staat).
  - Een leerling die op de juiste plek staat met 20 m GPS-afwijking wordt dus niet geweigerd, maar de straal blijft de belangrijkste grens. Beide getallen staan in `app_config.dart`.

## Opslag wissen

- In de app: **Instellingen → Voortgang opnieuw beginnen** (met bevestiging).
- Snel: **Developer Mode → Snelle reset**.
- Bij een aangepast datamodel: verhoog `storageVersion` in `app_config.dart`. Oude voortgang wordt dan bij de volgende start automatisch genegeerd.
- Web: de data staat in de `localStorage` van de browser (wissen via de ontwikkelaarstools van de browser).

---

## Flutter Web

```bash
flutter run -d chrome
flutter build web        # resultaat in build/web
```

Beperkingen rond locatie:

- Browsers geven GPS alleen vrij op een **veilige verbinding**: **HTTPS** of **`localhost`**. Via `http://192.168.x.x` op je telefoon werkt GPS dus níét. Gebruik daarvoor Developer Mode of zet de site op HTTPS.
- De browser vraagt zelf om toestemming. Weigert de leerling, dan toont de app een nette melding. Toestemming terugzetten gaat via het slotje in de adresbalk.
- Laptops zonder GPS bepalen hun locatie via wifi; die is vaak honderden meters onnauwkeurig.
- Safari (iOS) en Chrome (Android) ondersteunen locatie; Firefox ook, maar soms minder nauwkeurig.
- De web-build bevat een `manifest.json` en kan als PWA aan het beginscherm worden toegevoegd. Een offline-cache voor de app zelf is niet ingesteld.

## Offline

Werkt zonder internet:

- alle historische teksten, opdrachten, hints, aanwijzingen en quizzen (staan in de app)
- het missieboek, de eindmissie en de schematische kaartopdrachten
- afbeeldingen die in `assets/` staan
- opgeslagen voortgang
- de GPS-controle (GPS heeft geen internet nodig)

Werkt **niet** zonder internet:

- de **OpenStreetMap-kaart** (de kaarttegels komen van internet). De app toont dan een melding; de markers en routelijn blijven zichtbaar op een lege achtergrond.
- externe navigatie (Google Maps / Apple Kaarten hebben zelf internet nodig)
- links naar bronnen

Op het web moet de app zelf de eerste keer met internet geladen worden.

---

## Later publiceren

**Android**

```bash
flutter build appbundle   # voor Google Play (.aab)
flutter build apk         # los installeerbaar bestand
```

Daarvoor nodig: een eigen app-id (`applicationId` in `android/app/build.gradle.kts`, nu `nl.pws.market_garden`), een signing key en een Google Play-ontwikkelaarsaccount.

**iOS** (alleen op een Mac met Xcode)

```bash
flutter build ipa
```

Daarvoor nodig: een Apple Developer-account, een bundle-id en signing in Xcode (`ios/Runner.xcworkspace`). De locatietekst voor toestemming staat in `ios/Runner/Info.plist`.

**Web**

```bash
flutter build web
```

Zet de inhoud van `build/web` op een host met **HTTPS** (bijvoorbeeld GitHub Pages, Netlify of Firebase Hosting).

> Gebruik je in productie veel kaartverkeer, lees dan de [OpenStreetMap tile usage policy](https://operations.osmfoundation.org/policies/tiles/); voor een schoolproject is het standaardgebruik prima.

## Tests

```bash
flutter analyze
flutter test
```

De tests controleren onder andere de GPS-tolerantie, het ontgrendelen van locaties, het opslaan van voortgang, het nakijken van alle opdrachtsoorten, of alle inhoud klopt (bestaan alle locaties, heeft iedere vraag een goed antwoord), en twee volledige doorlopen: de Hartenstein-missie en de eindmissie.

## Historische inhoud

Alle teksten zijn **voorbeeldteksten** voor het prototype. Controleer feiten, namen en data met betrouwbare bronnen (bijvoorbeeld het Airborne Museum) voordat leerlingen de app gebruiken. Plekken die extra controle nodig hebben zijn gemarkeerd met `CONTROLEER` of `[VOORBEELDTEKST]`.

// AANPASBARE PWS-INHOUD
// De eindmissies bij de John Frostbrug: één per niveau. Route A
// (basisschool) gebruikt `finalMissionA`, route B (havo/vwo) `finalMissionB`.
// Ze gebruiken dezelfde opdrachtsoorten als de gewone missies (zie
// lib/data/missions.dart voor uitleg van de velden).

import '../models/mission_model.dart';

const String finalQuestion =
    'Waarom slaagde Operatie Market Garden bij Arnhem niet zoals gepland?';

// ── ROUTE A: BASISSCHOOL (GROEP 7-8) ─────────────────────────────────────

const Mission finalMissionA = Mission(
  id: 'm_final_a',
  title: 'De eindmissie',
  intro:
      'Jullie staan bij de brug waar alles om draaide. Gebruik alles wat '
      'jullie onderweg hebben ontdekt om één vraag te beantwoorden:\n\n'
      '$finalQuestion',
  keyInsight:
      'Het plan mislukte door meerdere dingen tegelijk: de soldaten landden '
      'ver van de brug, ze hadden te weinig eten en kogels, en de hulp uit '
      'het zuiden kwam niet op tijd.',
  completionText:
      'Goed gedaan! Jullie hebben het verhaal van de Slag om Arnhem '
      'opgelost.',
  tasks: [
    MissionTask(
      id: 'fa1',
      type: MissionType.ordering,
      prompt:
          'Stap 1 – Wat gebeurde er eerst? Zet de gebeurtenissen op volgorde.',
      items: [
        '17 september – Britse soldaten landen met parachutes op de hei.',
        '17 september, avond – John Frost en zijn soldaten komen bij de brug.',
        'De Britten verdedigen zich in Oosterbeek.',
        '21 september – De laatste soldaten bij de brug geven zich over.',
        '25/26 september – De overlevenden gaan in bootjes over de rivier.',
      ],
      wrongFeedback:
          'Nog niet helemaal. Kijk naar de data. Wat gebeurde er op de '
          'eerste dag?',
      hints: [
        'Alles begon met de landing. Het eindigde met de tocht over de rivier.',
      ],
      explanation:
          'Goed! Eerst de landing, dan de brug, dan Oosterbeek. Aan het eind '
          'moesten de soldaten terug over de rivier.',
    ),
    MissionTask(
      id: 'fa2',
      type: MissionType.matching,
      prompt: 'Stap 2 – Welke plek hoort bij welke rol? Koppel ze aan elkaar.',
      pairs: [
        MatchPair(
          'Hartenstein',
          'Hoofdkwartier: hier maakten de leiders plannen',
        ),
        MatchPair('Begraafplaats', 'Hier herdenken we de gesneuvelde soldaten'),
        MatchPair(
          'Het Witte Huis',
          'Schotse soldaten met te weinig eten en kogels',
        ),
        MatchPair('Oude Kerk', 'Kate ter Horst zorgde voor de gewonden'),
        MatchPair(
          'Mortierput',
          'Een kuil waaruit met een mortier werd geschoten',
        ),
      ],
      wrongFeedback:
          'Nog niet helemaal. Denk terug aan wat je bij iedere plek hebt '
          'gezien.',
      hints: ['Het Witte Huis is nu een hotel: Dreyeroord.'],
      explanation: 'Klopt! Iedere plek vertelt een stukje van het verhaal.',
    ),
    MissionTask(
      id: 'fa3',
      type: MissionType.informationCombination,
      prompt:
          'Stap 3 – Pak je aanwijzingen erbij. Welke TWEE aanwijzingen laten '
          'zien waarom het zo moeilijk was voor de Britten?',
      options: [
        '8–12 KM – Te ver van de brug',
        'TE WEINIG – Rapport Witte Huis',
        'DAVID LORD – Herinnering',
      ],
      correctIndices: {0, 1},
      wrongFeedback:
          'Nog niet helemaal. Lees de uitleg bij je aanwijzingen nog eens.',
      hints: ['Het gaat om een lange afstand en om te weinig spullen.'],
      explanation:
          'Precies! De brug was ver weg en de soldaten hadden te weinig eten, '
          'water en kogels. David Lord is een held die we herdenken, maar hij '
          'verklaart niet waarom het mislukte.',
    ),
    MissionTask(
      id: 'fa4',
      type: MissionType.multipleChoice,
      prompt: 'Stap 4 – $finalQuestion Kies het beste antwoord.',
      options: [
        'Alleen omdat het regende.',
        'Door meerdere dingen samen: ze landden ver van de brug, hadden te '
            'weinig spullen en de hulp kwam te laat.',
        'Omdat de Britten de brug niet konden vinden.',
      ],
      correctIndices: {1},
      wrongFeedback:
          'Nog niet helemaal. Was er maar één ding mis, of waren het er meer?',
      hints: ['Kijk terug naar je aanwijzingen uit stap 3.'],
      explanation:
          'Ja! Het mislukte niet door één ding, maar door meerdere dingen '
          'tegelijk. Daarom heet de brug in Arnhem ook wel “een brug te ver”.',
    ),
  ],
);

// ── ROUTE B: MIDDELBARE SCHOOL (HAVO/VWO) ────────────────────────────────

const Mission finalMissionB = Mission(
  id: 'm_final_b',
  title: 'De eindmissie',
  intro:
      'Jullie staan bij de brug waar de hele operatie om draaide. Reconstrueer '
      'het verloop, onderscheid oorzaken in het plan van problemen in de '
      'uitvoering, en beantwoord dan de centrale vraag:\n\n'
      '$finalQuestion',
  keyInsight:
      'Market Garden liep bij Arnhem vast door een samenspel van oorzaken. '
      'Een deel zat al in het plan (landing ver van de brug, aanvoer over '
      'meerdere dagen, genegeerde inlichtingen), een deel ontstond in de '
      'uitvoering (slechte radio’s, vertraging van XXX Corps, het weer).',
  completionText:
      'Jullie hebben het verloop gereconstrueerd en oorzaken tegen elkaar '
      'afgewogen – precies wat een historicus doet.',
  tasks: [
    MissionTask(
      id: 'fb1',
      type: MissionType.ordering,
      prompt: 'Stap 1 – Zet de gebeurtenissen in chronologische volgorde.',
      items: [
        '17 sept – Britse luchtlandingstroepen landen bij Wolfheze en Renkum.',
        '17 sept, avond – Het bataljon van Frost bereikt de noordkant van de '
            'brug.',
        '18 sept – Een Duitse aanval onder Gräbner over de brug wordt '
            'afgeslagen.',
        '20 sept – XXX Corps en de Amerikaanse 82e Divisie veroveren de brug '
            'bij Nijmegen.',
        '21 sept, ochtend – De laatste verdedigers bij de brug geven zich over.',
        '21 sept, middag – De Poolse brigade landt bij Driel.',
        '25/26 sept – Operatie Berlin: de overlevenden worden over de Rijn '
            'geëvacueerd.',
      ],
      wrongFeedback:
          'Nog niet helemaal. Let op de data en op de volgorde binnen '
          '21 september.',
      hints: [
        'De Polen landden pas toen de strijd bij de brug al voorbij was.',
      ],
      explanation:
          'Goed. Zie je het patroon? De brug bij Nijmegen viel pas op dag 4, '
          'en de Polen kwamen pas toen de brug in Arnhem al verloren was.',
    ),
    MissionTask(
      id: 'fb2',
      type: MissionType.matching,
      prompt: 'Stap 2 – Koppel ieder probleem aan het directe gevolg.',
      infoCards: [
        'Let op: sommige gevolgen lijken op elkaar. Zoek het gevolg dat '
            'rechtstreeks uit het probleem volgt.',
      ],
      pairs: [
        MatchPair(
          'Landingsterreinen 8–12 km van de brug',
          'Alleen één bataljon bereikte de brug; de rest werd onderweg '
              'tegengehouden',
        ),
        MatchPair(
          'Aanvoer van de divisie over meerdere dagen',
          'Een deel van de troepen moest de landingsterreinen bewaken',
        ),
        MatchPair(
          'Slecht werkende radioverbindingen',
          'Urquhart had lange tijd geen contact met zijn eenheden',
        ),
        MatchPair(
          'XXX Corps over één smalle weg',
          'De Duitsers konden de opmars op één plek blokkeren en vertragen',
        ),
        MatchPair(
          'Slecht weer in Engeland',
          'De Poolse brigade landde dagen later dan gepland',
        ),
      ],
      wrongFeedback:
          'Nog niet helemaal. Vraag je bij ieder paar af: volgt dit gevolg '
          'rechtstreeks uit dit probleem?',
      hints: [
        'Begin met het weer en de radio’s: die gevolgen zijn het meest '
            'direct.',
      ],
      explanation:
          'Alle oorzaken en gevolgen zijn goed gekoppeld. Merk op hoe de '
          'problemen elkaar versterkten.',
    ),
    MissionTask(
      id: 'fb3',
      type: MissionType.informationCombination,
      prompt:
          'Stap 3 – Plan of uitvoering? Welke DRIE oorzaken zaten al in het '
          'plan, dus vóór 17 september?',
      options: [
        'De landingsterreinen lagen ver van de brug.',
        'De divisie werd over meerdere dagen aangevoerd.',
        'Inlichtingen over de 9e en 10e SS-Panzerdivisie werden niet serieus '
            'genomen.',
        'De radioverbindingen werkten slecht.',
        'Gräbner viel de brug aan vanuit het zuiden.',
      ],
      correctIndices: {0, 1, 2},
      wrongFeedback:
          'Nog niet helemaal. Welke problemen ontstonden pas tijdens de '
          'gevechten?',
      hints: [
        'Een keuze van de planners kun je vóór de operatie al zien. Een '
            'Duitse aanval of kapotte radio’s niet.',
      ],
      explanation:
          'Juist. Landingsplaats, aanvoerschema en de omgang met inlichtingen '
          'waren keuzes in het plan. De radio’s en de aanval van Gräbner '
          'hoorden bij de uitvoering.',
    ),
    MissionTask(
      id: 'fb4',
      type: MissionType.informationCombination,
      prompt:
          'Stap 4 – Gebruik je aanwijzingen. Welke TWEE aanwijzingen verklaren '
          'het best waarom versterkingen de brug niet bereikten?',
      options: [
        '8–12 KM – Te ver van de brug',
        '∩ – Hoefijzer aan de Rijn',
        'RIJN – De Rijn als barrière',
        '4 STEMMEN – Vele perspectieven',
      ],
      correctIndices: {0, 2},
      wrongFeedback:
          'Nog niet helemaal. Welke aanwijzingen gaan over de weg naar de '
          'brug, en welke over iets anders?',
      hints: [
        'Het hoefijzer gaat over de verdediging in Oosterbeek, niet over de '
            'weg naar de brug.',
      ],
      explanation:
          'Precies: de afstand van 8–12 km en de Rijn zonder pont maakten het '
          'bijna onmogelijk om de brug te versterken. Het hoefijzer laat zien '
          'waar de Britten daarna vastzaten; de vier stemmen gaan over '
          'perspectieven, niet over oorzaken.',
    ),
    MissionTask(
      id: 'fb5',
      type: MissionType.multipleChoice,
      prompt:
          'Stap 5 – Een historicus beweert: “Market Garden mislukte door het '
          'weer.” Welke beoordeling van die bewering is het best?',
      infoCards: [
        // CONTROLEER: invloed van het weer op aanvoer en Poolse landing.
        'Door slecht weer werd de Poolse landing van 19 naar 21 september '
            'uitgesteld en kwamen bevoorradingsvluchten minder goed aan.',
      ],
      options: [
        'Klopt: zonder het slechte weer was de brug zeker veroverd.',
        'Klopt niet: het weer speelde helemaal geen rol.',
        'Deels: het weer was een factor (Polen en bevoorrading vertraagd), '
            'maar het plan en de Duitse kracht wogen zwaarder. Eén oorzaak '
            'verklaart zelden een historische gebeurtenis.',
        'Niet te beoordelen: bronnen spreken elkaar tegen, dus elke '
            'verklaring is even goed.',
      ],
      correctIndices: {2},
      wrongFeedback:
          'Nog niet helemaal. Is het weer de enige oorzaak, of één van '
          'meerdere?',
      hints: [
        'Denk aan stap 3: welke oorzaken lagen er al vóór het weer een rol '
            'ging spelen?',
      ],
      explanation:
          'Ja. Het weer vertraagde de Polen en de bevoorrading, maar de '
          'landing ver van de brug, de sterke Duitse troepen en de trage '
          'opmars van XXX Corps wogen zwaarder. Juist de combinatie verklaart '
          'waarom Arnhem “een brug te ver” was.',
    ),
  ],
);

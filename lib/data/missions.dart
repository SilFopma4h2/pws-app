// AANPASBARE PWS-INHOUD
// Missies per locatie, per niveau. Route A (basisschool, groep 7-8) gebruikt
// `missionsA`, route B (havo/vwo bovenbouw) gebruikt `missionsB`. De sleutel
// van de map is de locatie-id uit lib/data/locations.dart. Per opdracht
// staan hier de vraag, de antwoordopties, de goede antwoorden, hints en
// feedback.
//
// Goede antwoorden:
// - keuzevragen: `correctIndices` (0 = eerste optie, 1 = tweede, ...)
// - volgorde: `items` staan hier in de GOEDE volgorde; de app husselt ze
// - koppelen: `pairs` bevatten de goede combinaties; de app husselt rechts
// - tekst: `acceptedAnswers` (hoofdletters/accenten/spaties maken niet uit)
//
// Kaartopdrachten gebruiken een schematische kaart (werkt offline).
// x en y lopen van 0 (links/boven) tot 1 (rechts/onder). De Rijn loopt
// ongeveer horizontaal op y ≈ 0.6.

import '../models/mission_model.dart';

const List<String> trueFalseOptions = ['Juist', 'Onjuist'];

// ── ROUTE A: BASISSCHOOL (GROEP 7-8) ─────────────────────────────────────
// Korte zinnen, meestal 3 antwoorden, 1-2 hints per opdracht.

const Map<String, Mission> missionsA = {
  'hartenstein': Mission(
    id: 'm_hartenstein_a',
    title: 'Het grote plan',
    intro:
        'In dit huis zaten in 1944 de leiders van de Britse soldaten. Ontdek '
        'wat hun plan was.',
    clueId: 'clue_distance',
    keyInsight:
        'De geallieerden wilden de brug over de Rijn in Arnhem veroveren. '
        'Maar ze landden ver van die brug.',
    completionText:
        'Goed gedaan! Jullie weten nu wat het plan was: de brug in Arnhem '
        'veroveren.',
    tasks: [
      MissionTask(
        id: 'a_h1',
        type: MissionType.mapQuestion,
        prompt:
            'Tik op de plek van de brug in Arnhem. Die brug wilden de '
            'geallieerden veroveren.',
        mapLabels: [
          MapLabel('Wolfheze', 0.12, 0.14),
          MapLabel('Oosterbeek', 0.36, 0.38),
          MapLabel('ARNHEM', 0.76, 0.30),
          MapLabel('Rijn', 0.58, 0.68),
        ],
        mapPoints: [
          MapPoint('A', 0.17, 0.24),
          MapPoint('B', 0.40, 0.48),
          MapPoint('C', 0.79, 0.575),
        ],
        options: [
          'A – de hei bij Wolfheze',
          'B – Oosterbeek',
          'C – bij Arnhem, op de rivier',
        ],
        correctIndices: {2},
        wrongFeedback: 'Nog niet. Een brug ligt altijd over water.',
        hints: ['Zoek de rivier op de kaart.', 'Kijk bij de grootste stad.'],
        explanation:
            'Klopt! Punt C ligt bij Arnhem, op de rivier. Daar lag de brug.',
      ),
      MissionTask(
        id: 'a_h2',
        type: MissionType.textInput,
        prompt: 'Over welke rivier lag de brug in Arnhem? Typ de naam.',
        acceptedAnswers: ['Rijn', 'Nederrijn', 'Neder-Rijn', 'de Rijn'],
        wrongFeedback:
            'Nog niet. De naam staat in de uitleg en op de kaart.',
        hints: ['De naam heeft vier letters en begint met een R.'],
        explanation: 'Goed! Het is de Rijn.',
      ),
      MissionTask(
        id: 'a_h3',
        type: MissionType.informationCombination,
        prompt:
            'Lees de kaartjes. Welke TWEE dingen maakten het moeilijk om snel '
            'bij de brug te komen?',
        infoCards: [
          'De soldaten landden op de hei. Die lag ongeveer 10 kilometer van '
              'de brug.',
          'Er waren te weinig vliegtuigen. Niet alle soldaten kwamen op de '
              'eerste dag.',
          'Op 17 september was de brug nog heel.',
        ],
        options: [
          'De soldaten landden ver van de brug.',
          'Niet alle soldaten kwamen op de eerste dag.',
          'De brug was al kapot.',
        ],
        correctIndices: {0, 1},
        wrongFeedback: 'Nog niet. Kies alleen wat op de kaartjes staat.',
        hints: ['Eén antwoord klopt niet met het laatste kaartje.'],
        explanation:
            'Goed gecombineerd! Ver lopen en weinig soldaten tegelijk: zo '
            'kregen de Duitsers tijd om zich voor te bereiden.',
      ),
    ],
  ),

  'cemetery': Mission(
    id: 'm_cemetery_a',
    title: 'Niet vergeten',
    intro:
        'Dit is een stille plek. Ga rustig bij de ingang of op een bankje '
        'zitten. Lees het verhaal. Er is geen haast.',
    clueId: 'clue_remembrance',
    tone: MissionTone.respectful,
    keyInsight:
        'Hier liggen jonge mensen die in de oorlog stierven. Door te '
        'herdenken vergeten we hen niet.',
    completionText:
        'Dank je voor het lezen. Ieder jaar worden deze verhalen opnieuw '
        'verteld bij de herdenking.',
    tasks: [
      MissionTask(
        id: 'a_c1',
        type: MissionType.multipleChoice,
        prompt: 'Wat laat het verhaal van David Lord zien?',
        infoCards: [
          // CONTROLEER: verhaal is gebaseerd op openbare bronnen (CWGC).
          'David Lord was piloot. Op 19 september 1944 vloog hij boven '
              'Oosterbeek. Hij gooide eten en kogels af voor de soldaten.',
          'Zijn vliegtuig werd geraakt en ging branden. Toch vloog hij nog '
              'een rondje, zodat alles kon worden afgegooid.',
          'Daarna moest zijn bemanning springen. Hij kwam zelf om. Hij ligt '
              'hier begraven.',
        ],
        options: [
          'Dat hij veel gevaar liep om anderen te helpen.',
          'Dat piloten geen gevaar liepen.',
          'Dat alles zonder problemen ging.',
        ],
        correctIndices: {0},
        wrongFeedback: 'Lees het verhaal nog een keer rustig door.',
        hints: ['Wat deed hij terwijl zijn vliegtuig al brandde?'],
        explanation:
            'Dat klopt. Zijn verhaal laat zien hoeveel mensen hier gaven '
            'voor anderen.',
      ),
      MissionTask(
        id: 'a_c2',
        type: MissionType.trueFalse,
        prompt:
            'Kinderen uit Oosterbeek leggen hier al sinds 1945 ieder jaar '
            'bloemen bij de graven.',
        options: trueFalseOptions,
        correctIndices: {0},
        wrongFeedback: 'Lees de uitleg nog een keer rustig door.',
        hints: ['Kijk in de uitleg bij welk jaar het begon.'],
        explanation:
            'Dat klopt. Ieder jaar opnieuw, al sinds 1945.',
      ),
      MissionTask(
        id: 'a_c3',
        type: MissionType.multipleChoice,
        prompt: 'Waarom leggen kinderen hier bloemen, denk je?',
        options: [
          'Zodat we deze mensen niet vergeten.',
          'Zodat ze een prijs kunnen winnen.',
          'Omdat de begraafplaats anders dicht gaat.',
        ],
        correctIndices: {0},
        wrongFeedback: 'Denk rustig na over wat herdenken betekent.',
        hints: ['Herdenken betekent: samen terugdenken aan iemand.'],
        explanation:
            'Ja. Zo geven we de herinnering door aan nieuwe kinderen.',
      ),
    ],
  ),

  'mortierput': Mission(
    id: 'm_mortierput_a',
    title: 'Sporen in het bos',
    intro:
        'Het lijkt een gewone kuil. Maar soldaten hebben hem gegraven. '
        'Kijk goed om je heen.',
    clueId: 'clue_traces',
    keyInsight:
        'Kuilen in het bos zijn sporen van de strijd. Soldaten beschermden '
        'zich erin.',
    completionText:
        'Goed gekeken! Jullie hebben sporen van 1944 gevonden in het bos.',
    tasks: [
      MissionTask(
        id: 'a_p1',
        type: MissionType.imageObservation,
        prompt: 'Bekijk de foto. Waarvoor was deze kuil?',
        imageAsset: 'assets/images/documents/mortierput_1944.jpg',
        imageCaption:
            'Een ronde kuil met een wal van aarde eromheen. Naast de kuil '
            'liggen lege kisten.',
        options: [
          'Om veilig te zitten en te schieten.',
          'Om water uit te halen.',
          'Om fietsen in te zetten.',
        ],
        correctIndices: {0},
        wrongFeedback: 'Nog niet. Let op de wal en de lege kisten.',
        hints: ['In de kisten zat munitie. Dat zijn kogels en granaten.'],
        explanation:
            'Goed! De wal beschermde de soldaten. In de kisten zat munitie.',
      ),
      MissionTask(
        id: 'a_p2',
        type: MissionType.trueFalse,
        prompt:
            'Een mortier is een soort kanon. Het schiet in een hoge boog, over '
            'bomen en huizen heen.',
        options: trueFalseOptions,
        correctIndices: {0},
        wrongFeedback: 'Nog niet. Lees de uitleg over de mortier nog eens.',
        hints: ['Kijk in de uitleg hoe een mortier schiet.'],
        explanation:
            'Juist! Zo konden de soldaten in de kuil blijven zitten en toch '
            'schieten.',
      ),
      MissionTask(
        id: 'a_p3',
        type: MissionType.multipleChoice,
        prompt: 'Waarom zie je de meeste kuilen nu bijna niet meer?',
        options: [
          'Ze zijn in 80 jaar vol blaadjes en zand gekomen.',
          'Ze zijn er nooit geweest.',
          'Ze zijn naar een museum gebracht.',
        ],
        correctIndices: {0},
        wrongFeedback: 'Nog niet. Wat gebeurt er met een bos in 80 jaar?',
        hints: ['Denk aan de herfst.'],
        explanation:
            'Precies. Daarom is het belangrijk om de sporen die er nog zijn '
            'te beschermen.',
      ),
    ],
  ),

  'dreyeroord': Mission(
    id: 'm_dreyeroord_a',
    title: 'Het Witte Huis',
    intro:
        'Dit hotel heette in 1944 “Het Witte Huis”. Ontdek wat hier gebeurde.',
    clueId: 'clue_white_house',
    keyInsight:
        'De Schotse soldaten hadden bijna geen eten, water en kogels meer. '
        'Ook de mensen van het hotel hadden het zwaar.',
    completionText:
        'Goed gedaan! Jullie weten nu wat er bij het Witte Huis gebeurde.',
    tasks: [
      MissionTask(
        id: 'a_d1',
        type: MissionType.multipleChoice,
        prompt: 'Waarom noemden de Britten dit hotel “The White House”?',
        options: [
          'Het was wit en je kon het van ver zien.',
          'De Amerikaanse president woonde er.',
          'Er lag altijd sneeuw op het dak.',
        ],
        correctIndices: {0},
        wrongFeedback: 'Nog niet. Kijk eens naar de kleur van het hotel.',
        hints: ['Lees de eerste zin van de uitleg.'],
        explanation: 'Klopt! Het witte hotel was een goed herkenningspunt.',
      ),
      MissionTask(
        id: 'a_d2',
        type: MissionType.multipleChoice,
        prompt: 'Wat hadden de Schotse soldaten hier bijna niet meer?',
        options: [
          'Eten, water en kogels.',
          'Schoenen en jassen.',
          'Kaarten en kompassen.',
        ],
        correctIndices: {0},
        wrongFeedback: 'Nog niet. Lees de tweede alinea van de uitleg.',
        hints: ['Wat heb je nodig om te leven én te vechten?'],
        explanation:
            'Juist. Zonder eten, water en kogels konden ze het niet lang '
            'volhouden.',
      ),
      MissionTask(
        id: 'a_d3',
        type: MissionType.trueFalse,
        prompt:
            'De mensen van het hotel zaten tijdens de gevechten in de kelder.',
        options: trueFalseOptions,
        correctIndices: {0},
        wrongFeedback: 'Nog niet. Lees de laatste alinea van de uitleg.',
        hints: ['Waar was het het veiligst?'],
        explanation:
            'Juist. Oorlog raakt niet alleen soldaten, maar ook gewone mensen.',
      ),
    ],
  ),

  'oude_kerk': Mission(
    id: 'm_oude_kerk_a',
    title: 'Het hoefijzer',
    intro:
        'De Britten zaten vast in Oosterbeek. Ontdek hoe hun gebied eruitzag '
        'en wie hier hielp.',
    clueId: 'clue_perimeter',
    keyInsight:
        'Het gebied van de Britten had de vorm van een hoefijzer. Alleen de '
        'kant van de rivier was nog open.',
    completionText:
        'Goed gedaan! Jullie weten nu hoe de Britten zich verdedigden.',
    tasks: [
      MissionTask(
        id: 'a_k1',
        type: MissionType.ordering,
        prompt: 'Zet in de goede volgorde. Wat gebeurde eerst?',
        items: [
          'Britse soldaten landen met parachutes op de hei.',
          'Ze komen niet bij de brug in Arnhem.',
          'Ze verdedigen zich in Oosterbeek, ook bij deze kerk.',
        ],
        wrongFeedback: 'Nog niet. Begin bij de landing.',
        hints: ['Eerst landen, dan lopen, dan verdedigen.'],
        explanation:
            'Goed! Eerst wilden ze naar de brug. Toen dat niet lukte, '
            'moesten ze zich verdedigen.',
      ),
      MissionTask(
        id: 'a_k2',
        type: MissionType.mapQuestion,
        prompt:
            'Het gebied van de Britten leek op een hoefijzer. Een hoefijzer '
            'heeft één open kant. Waar lag de open kant?',
        mapLabels: [
          MapLabel('Oosterbeek', 0.38, 0.32),
          MapLabel('Rijn', 0.20, 0.70),
          MapLabel('Driel', 0.42, 0.88),
        ],
        mapPoints: [
          MapPoint('A', 0.45, 0.16),
          MapPoint('B', 0.66, 0.42),
          MapPoint('C', 0.45, 0.58),
        ],
        options: [
          'A – noordkant (bos)',
          'B – oostkant (richting Arnhem)',
          'C – zuidkant (bij de rivier)',
        ],
        correctIndices: {2},
        wrongFeedback: 'Nog niet. Welke kant was nog open, volgens de uitleg?',
        hints: ['Deze kerk ligt vlak bij de open kant.'],
        explanation:
            'Klopt! De open kant lag aan de Rijn. Daar stonden geen Duitsers.',
      ),
      MissionTask(
        id: 'a_k3',
        type: MissionType.multipleChoice,
        prompt: 'Wat deed Kate ter Horst in het huis naast de kerk?',
        options: [
          'Ze zorgde voor honderden gewonde soldaten.',
          'Ze vocht mee met een geweer.',
          'Ze vluchtte meteen naar een ander land.',
        ],
        correctIndices: {0},
        wrongFeedback: 'Nog niet. Lees de tweede alinea van de uitleg.',
        hints: ['Ze las de soldaten ook voor uit de Bijbel.'],
        explanation:
            'Juist. Ze troostte de gewonden, terwijl ze ook voor haar vijf '
            'kinderen zorgde.',
      ),
    ],
  ),
};

// ── ROUTE B: HAVO/VWO BOVENBOUW ──────────────────────────────────────────
// 4 opties, weinig hints. Oorzaak/gevolg, bronkritiek, perspectieven,
// plan versus uitvoering.

const Map<String, Mission> missionsB = {
  'hartenstein': Mission(
    id: 'm_hartenstein_b',
    title: 'Plan en werkelijkheid',
    intro:
        'In deze villa zat het hoofdkwartier van generaal Urquhart. Vergelijk '
        'het plan van Market Garden met wat er in werkelijkheid gebeurde.',
    clueId: 'clue_distance',
    keyInsight:
        'Market Garden was een gok op snelheid. Landingen verspreid over '
        'meerdere dagen, ver van de brug, slechte verbindingen en genegeerde '
        'inlichtingen maakten die snelheid onmogelijk.',
    completionText:
        'Jullie hebben het plan van Market Garden vergeleken met de '
        'uitvoering en de zwakke plekken blootgelegd.',
    tasks: [
      MissionTask(
        id: 'b_h1',
        type: MissionType.multipleChoice,
        prompt: 'Wat was het strategische doel van Montgomery met Market Garden?',
        options: [
          'De Siegfriedlinie omzeilen, de Rijn oversteken en het Ruhrgebied '
              'bereiken.',
          'Amsterdam en Rotterdam bevrijden om de havens te gebruiken.',
          'Berlijn innemen vóór de Sovjet-Unie dat kon doen.',
          'Een Duitse tegenaanval in de Ardennen voorkomen.',
        ],
        correctIndices: {0},
        wrongFeedback:
            'Nog niet. Het doel lag over de grens, in het industriële hart '
            'van Duitsland.',
        explanation:
            'Juist. Zonder het Ruhrgebied kon Duitsland de oorlog nauwelijks '
            'volhouden; de oorlog zou dan vóór Kerstmis voorbij kunnen zijn.',
      ),
      MissionTask(
        id: 'b_h2',
        type: MissionType.ordering,
        prompt:
            'XXX Corps moest over één weg naar het noorden. Zet de bruggen in '
            'de volgorde waarin XXX Corps ze moest passeren (zuid → noord).',
        // CONTROLEER: Grave (Maas) staat niet in de locatietekst.
        items: [
          'Eindhoven',
          'Grave (Maas)',
          'Nijmegen (Waal)',
          'Arnhem (Rijn)',
        ],
        wrongFeedback:
            'Nog niet. XXX Corps begon bij de Belgische grens en Arnhem was '
            'het verste doel.',
        explanation:
            'Klopt. Elke brug moest heel blijven; één opgeblazen brug kon de '
            'hele opmars stilleggen.',
      ),
      MissionTask(
        id: 'b_h3',
        type: MissionType.informationCombination,
        prompt:
            'Plan versus uitvoering. Welke factoren uit het dossier verklaren '
            'dat de Britten de brug niet met voldoende troepen bereikten? '
            'Kies alle juiste.',
        infoCards: [
          'Door een tekort aan vliegtuigen werd de divisie in meerdere dagen '
              'aangevoerd.',
          'De landingsterreinen lagen 8 tot 12 km van de brug; een deel van '
              'de troepen bleef achter om ze te bewaken.',
          // CONTROLEER: inlichtingen over Duitse pantsertroepen.
          'Verzet en luchtfoto’s wezen op de 9e en 10e SS-Panzerdivisie '
              '(Bittrich) bij Arnhem. De planners namen dat niet serieus.',
          'Veel radio’s werkten slecht; Urquhart had lang geen contact met '
              'zijn eenheden.',
        ],
        options: [
          'Op dag 1 was maar een deel van de divisie beschikbaar voor de '
              'aanval.',
          'De troepen moesten ver lopen en de aanvalskracht werd verder '
              'verkleind.',
          'Er stonden sterkere Duitse eenheden klaar dan de planners '
              'verwachtten.',
          'De verkeersbrug was al vóór de landing door de Duitsers '
              'opgeblazen.',
        ],
        correctIndices: {0, 1, 2},
        wrongFeedback:
            'Nog niet. Controleer elke optie aan het dossier: wat wordt '
            'bevestigd en wat niet?',
        hints: ['Eén optie wordt door geen enkel kaartje ondersteund.'],
        explanation:
            'Goed. Tijdverlies, afstand en een onderschatte tegenstander '
            'versterkten elkaar. De slechte radio’s maakten bijsturen '
            'vervolgens bijna onmogelijk.',
      ),
      MissionTask(
        id: 'b_h4',
        type: MissionType.matching,
        prompt: 'Koppel elk begrip of elke persoon aan de juiste rol.',
        pairs: [
          MatchPair('Market', 'Luchtlandingsdivisies nemen de bruggen in'),
          MatchPair('Garden', 'XXX Corps rukt over één weg naar het noorden'),
          MatchPair('Urquhart', 'Commandant van de Britse 1e Luchtlandingsdivisie'),
          MatchPair('Bittrich', 'Duitse generaal van de SS-pantsertroepen bij Arnhem'),
        ],
        wrongFeedback: 'Nog niet. Eén of meer koppelingen kloppen niet.',
        explanation:
            'Alles klopt. Market en Garden waren afhankelijk van elkaar: '
            'zonder Garden konden de luchtlandingstroepen niet lang standhouden.',
      ),
    ],
  ),

  'oude_kerk': Mission(
    id: 'm_oude_kerk_b',
    title: 'De Hexenkessel',
    intro:
        'Vanaf 19 september zaten de Britten ingesloten in Oosterbeek. '
        'Onderzoek hoe de perimeter werkte en hoe verschillende partijen '
        'de strijd beleefden.',
    clueId: 'clue_perimeter',
    keyInsight:
        'De Britten verdedigden een hoefijzervormige perimeter met de open '
        'kant aan de Rijn. Soldaten en burgers zaten samen in de '
        '“Hexenkessel”.',
    completionText:
        'Jullie begrijpen nu hoe de perimeter in elkaar zat en waarom de '
        'Rijn de enige uitweg bleef.',
    tasks: [
      MissionTask(
        id: 'b_k1',
        type: MissionType.ordering,
        prompt: 'Zet de gebeurtenissen in chronologische volgorde.',
        items: [
          '17 sept: landingen bij Wolfheze en Renkum.',
          '17 sept (avond): het bataljon van Frost bereikt de noordkant van de '
              'brug.',
          '19 sept: de rest van de divisie bereikt de brug niet meer; de '
              'perimeter ontstaat.',
          '21 sept: Poolse parachutisten landen bij Driel.',
          'Nacht 25/26 sept: Operatie Berlin, de evacuatie over de Rijn.',
        ],
        wrongFeedback: 'Nog niet. Let op de data.',
        explanation:
            'Goed. Van aanval naar verdediging naar terugtocht in negen dagen.',
      ),
      MissionTask(
        id: 'b_k2',
        type: MissionType.mapQuestion,
        prompt:
            'Waar lag de OPEN kant van de perimeter, en waarom was die kant '
            'van levensbelang?',
        mapLabels: [
          MapLabel('Oosterbeek', 0.38, 0.32),
          MapLabel('Rijn', 0.20, 0.70),
          MapLabel('Driel', 0.42, 0.88),
        ],
        mapPoints: [
          MapPoint('A', 0.45, 0.16),
          MapPoint('B', 0.22, 0.42),
          MapPoint('C', 0.66, 0.42),
          MapPoint('D', 0.45, 0.58),
        ],
        options: [
          'A – noordkant (bossen)',
          'B – westkant',
          'C – oostkant (richting Arnhem)',
          'D – zuidkant (aan de Rijn)',
        ],
        correctIndices: {3},
        wrongFeedback:
            'Nog niet. Waarlangs konden nog versterkingen komen?',
        explanation:
            'Klopt. Alleen via de Rijn konden versterkingen komen – en later '
            'vond daarlangs de terugtocht plaats.',
      ),
      MissionTask(
        id: 'b_k3',
        type: MissionType.textInput,
        prompt:
            'Bij de Oude Kerk werden soldaten uit uiteengeslagen eenheden '
            'samengevoegd onder één majoor. Hoe heette deze groep?',
        acceptedAnswers: [
          'Lonsdale Force',
          'Lonsdale',
          'de Lonsdale Force',
          'Lonsdaleforce',
        ],
        wrongFeedback: 'Nog niet. De groep is genoemd naar de majoor.',
        explanation:
            'Juist: de Lonsdale Force van majoor Richard Lonsdale verdedigde '
            'de zuidoostkant van de perimeter.',
      ),
      MissionTask(
        id: 'b_k4',
        type: MissionType.multipleChoice,
        prompt:
            'De Duitsers noemden het gebied de “Hexenkessel” (heksenketel). '
            'Wat zegt deze naam vooral?',
        options: [
          'Dat de Duitsers het gebied zagen als een ingesloten, chaotische '
              'plek waar van alle kanten werd gevochten.',
          'Dat de Britten het gebied volledig beheersten.',
          'Dat er in Oosterbeek een Duitse fabriek stond.',
          'Dat de burgers het gebied al hadden verlaten.',
        ],
        correctIndices: {0},
        wrongFeedback:
            'Nog niet. Denk aan wie de naam bedacht en vanuit welk perspectief.',
        explanation:
            'Klopt. Een naam als deze is zelf een bron: hij laat zien hoe de '
            'aanvallers de strijd beleefden.',
      ),
    ],
  ),

  'drielse_veer': Mission(
    id: 'm_drielse_veer_b',
    title: 'De oversteek',
    intro:
        'Jullie staan aan de zuidkant van de Rijn. Aan de overkant zaten de '
        'Britten. Onderzoek waarom de Poolse hulp te laat en te klein was.',
    clueId: 'clue_river',
    keyInsight:
        'Vertraging door het weer, een verdwenen veerpont en een brede, '
        'snelle rivier maakten versterking bijna onmogelijk. De rivier werd '
        'uiteindelijk de route voor de terugtocht.',
    completionText:
        'Jullie zien nu waarom de Rijn de afloop van de slag bepaalde.',
    tasks: [
      MissionTask(
        id: 'b_v1',
        type: MissionType.mapQuestion,
        prompt:
            'Waar probeerden de Polen van Sosabowski de rivier over te steken?',
        mapLabels: [
          MapLabel('Oosterbeek', 0.30, 0.36),
          MapLabel('ARNHEM', 0.78, 0.30),
          MapLabel('Driel', 0.36, 0.86),
          MapLabel('Rijn', 0.58, 0.68),
        ],
        mapPoints: [
          MapPoint('A', 0.36, 0.635),
          MapPoint('B', 0.79, 0.575),
          MapPoint('C', 0.30, 0.18),
          MapPoint('D', 0.62, 0.86),
        ],
        options: [
          'A – tussen Driel en Oosterbeek',
          'B – de brug bij Arnhem',
          'C – ten noorden van Oosterbeek',
          'D – ten oosten van Driel',
        ],
        correctIndices: {0},
        wrongFeedback:
            'Nog niet. De brug bij Arnhem was op 21 september al in Duitse '
            'handen.',
        explanation:
            'Klopt. Tussen Driel en Oosterbeek, waar je nu bent, probeerden '
            'de Polen ’s nachts over te steken.',
      ),
      MissionTask(
        id: 'b_v2',
        type: MissionType.informationCombination,
        prompt:
            'Waarom bereikten maar enkele honderden Polen de Britten? Kies '
            'alle oorzaken die kloppen.',
        options: [
          'Door slecht weer landden ze pas op 21 in plaats van 19 september.',
          'De veerpont tussen Driel en Heveadorp was niet meer beschikbaar.',
          'De Rijn is hier zo’n 400 m breed en snel; ze staken over in kleine '
              'boten onder Duits vuur.',
          'De Polen landden per ongeluk aan de noordkant van de Rijn.',
        ],
        correctIndices: {0, 1, 2},
        wrongFeedback:
            'Nog niet. Er zijn meerdere oorzaken, maar niet alle opties '
            'kloppen met de uitleg.',
        explanation:
            'Goed. Vertraging, het ontbreken van de pont en de rivier zelf '
            'versterkten elkaar.',
      ),
      MissionTask(
        id: 'b_v3',
        type: MissionType.ordering,
        prompt: 'Zet de gebeurtenissen rond Driel in de juiste volgorde.',
        items: [
          '19 sept: geplande landing van de Poolse brigade, uitgesteld door '
              'het weer.',
          '21 sept: de Polen landen bij Driel.',
          'Nachten van 22 en 23 sept: oversteekpogingen in kleine boten.',
          'Nacht 25/26 sept: Operatie Berlin, ca. 2.400 man geëvacueerd.',
        ],
        wrongFeedback: 'Nog niet. Let op de data.',
        explanation:
            'Juist. De rivier die versterking tegenhield, werd de route '
            'voor de terugtocht.',
      ),
      MissionTask(
        id: 'b_v4',
        type: MissionType.multipleChoice,
        // CONTROLEER: rol van Sosabowski na de slag.
        prompt:
            'Na de slag gaven Britse leiders Sosabowski deels de schuld. '
            'Hoe beoordeelt een historicus dat oordeel het best?',
        options: [
          'Kritisch: de betrokkenen hadden er belang bij de schuld bij een '
              'ander te leggen, dus je vergelijkt met andere bronnen.',
          'Als betrouwbaar, want Britse leiders waren zelf bij de slag.',
          'Als onbelangrijk, want het gaat om een mening.',
          'Als betrouwbaar, want het oordeel werd direct na de slag gegeven.',
        ],
        correctIndices: {0},
        wrongFeedback:
            'Nog niet. Vraag je af: wie gaf dit oordeel en met welk doel?',
        hints: ['Sosabowski had vóór de operatie al kritiek op het plan.'],
        explanation:
            'Juist. Pas veel later werd zijn rol eerlijker beoordeeld; in 2006 '
            'kreeg de Poolse brigade de Militaire Willems-Orde.',
      ),
    ],
  ),

  'airborne_bridge': Mission(
    id: 'm_airborne_bridge_b',
    title: 'Wie vertelt het verhaal?',
    intro:
        'Eén brug, vier dagen, verschillende perspectieven. Onderzoek wie wat '
        'meemaakte en hoe betrouwbaar de bronnen zijn.',
    clueId: 'clue_perspectives',
    keyInsight:
        'Dezelfde gebeurtenis ziet er anders uit vanuit Britse, Duitse, Poolse '
        'en Nederlandse ogen. Bij elke bron vraag je: wie, wanneer en waarom?',
    completionText:
        'Jullie hebben de slag vanuit meerdere perspectieven bekeken en de '
        'bronnen kritisch gewogen.',
    tasks: [
      MissionTask(
        id: 'b_b1',
        type: MissionType.matching,
        prompt: 'Koppel iedere persoon aan de juiste rol.',
        // CONTROLEER: korte rolbeschrijvingen van historische personen.
        pairs: [
          MatchPair(
            'John Frost (Brits)',
            'Leidde het 2e Bataljon dat de noordkant van de brug bezette',
          ),
          MatchPair(
            'Viktor Gräbner (Duits)',
            'Leidde een verkenningseenheid die de brug vanuit het zuiden '
                'probeerde over te steken',
          ),
          MatchPair(
            'Kate ter Horst (Nederlands)',
            'Verzorgde honderden gewonden in de pastorie bij de Oude Kerk',
          ),
          MatchPair(
            'Stanisław Sosabowski (Pools)',
            'Generaal van de parachutistenbrigade die bij Driel landde',
          ),
        ],
        wrongFeedback: 'Nog niet. Eén of meer koppelingen kloppen niet.',
        explanation:
            'Alles klopt. Vier mensen, vier totaal verschillende ervaringen '
            'van dezelfde dagen.',
      ),
      MissionTask(
        id: 'b_b2',
        type: MissionType.ordering,
        prompt: 'Zet de strijd om de brug in chronologische volgorde.',
        // CONTROLEER: tijdstippen.
        items: [
          '17 sept (avond): Frost bereikt de noordkant van de brug.',
          '18 sept: de aanval van Gräbner over de brug wordt afgeslagen.',
          '20 sept: XXX Corps verovert de brug bij Nijmegen.',
          '21 sept (ochtend): de laatste verdedigers geven zich over.',
        ],
        wrongFeedback: 'Nog niet. Let op de data.',
        explanation:
            'Juist. XXX Corps was pas op 20 september in Nijmegen: te laat '
            'voor Frost, die zich de volgende ochtend moest overgeven.',
      ),
      MissionTask(
        id: 'b_b3',
        type: MissionType.multipleChoice,
        prompt:
            'Je vindt een officieel Brits legerrapport uit oktober 1944 over '
            'de verliezen bij de brug. Welke vraag stel je als historicus '
            'als eerste?',
        options: [
          'Wie schreef het rapport, en met welk doel?',
          'Hoeveel bladzijden heeft het rapport?',
          'Staat het rapport in een museum?',
          'Is het rapport in het Engels geschreven?',
        ],
        correctIndices: {0},
        wrongFeedback: 'Nog niet. Denk aan wie, wanneer en waarom.',
        explanation:
            'Juist. Een officieel rapport kan verliezen kleiner maken; '
            'wie en waarom bepalen hoe je de bron leest.',
      ),
      MissionTask(
        id: 'b_b4',
        type: MissionType.informationCombination,
        prompt:
            'Het boek “A Bridge Too Far” (Cornelius Ryan, 1974) en de film '
            '(1977) bepaalden lang het beeld van de slag. Welke uitspraken '
            'kloppen? Kies alle juiste.',
        options: [
          'Boek en film zijn ruim dertig jaar na de slag gemaakt.',
          'De film is een ooggetuigenverslag uit 1944.',
          'De film zegt ook iets over hoe men in de jaren zeventig over de '
              'slag dacht.',
          'Omdat de film zo bekend is, is hij betrouwbaarder dan '
              'legerrapporten.',
        ],
        correctIndices: {0, 2},
        wrongFeedback:
            'Nog niet. Let op wanneer de bron gemaakt is en wat bekendheid '
            'zegt over betrouwbaarheid.',
        hints: ['Twee uitspraken kloppen.'],
        explanation:
            'Goed. Populaire verhalen zijn zelf ook een bron: ze laten zien '
            'hoe er later over de gebeurtenissen werd gedacht.',
      ),
    ],
  ),
};

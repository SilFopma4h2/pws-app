// AANPASBARE PWS-INHOUD
// Teksten per locatie, per niveau. Route A (basisschool) gebruikt
// `locationTextsA`, route B (middelbare school) gebruikt `locationTextsB`.
// De sleutel is de locatie-id uit lib/data/locations.dart.

import '../models/location_model.dart';

// ── ROUTE A: BASISSCHOOL (GROEP 7-8) ─────────────────────────────────────
// Korte zinnen. Moeilijke woorden worden uitgelegd.

const Map<String, LocationText> locationTextsA = {
  'hartenstein': LocationText(
    teaser:
        'Een groot wit huis in Oosterbeek. In 1944 gebeurde hier iets '
        'heel belangrijks. Wat dan?',
    shortDescription:
        'In de oorlog was dit huis het hoofdkwartier van de Britse soldaten. '
        'Een hoofdkwartier is de plek waar de leiders de plannen maken.',
    historyText:
        'In 1944 was Nederland al vier jaar bezet door Duitsland. Bezet betekent: de '
        'Duitsers waren de baas. Soldaten '
        'uit Engeland, Amerika en andere landen wilden Nederland bevrijden. '
        'Zij heten de geallieerden.\n\n'
        'Ze bedachten een groot plan: Operatie Market Garden. Ze wilden een '
        'paar bruggen veroveren. De laatste en belangrijkste brug lag in '
        'Arnhem, over de rivier de Rijn.\n\n'
        'Op 17 september 1944 sprongen duizenden Britse soldaten met een '
        'parachute uit vliegtuigen. Ze landden op de hei, ver van de brug. '
        'Ze moesten nog ongeveer 10 kilometer lopen!\n\n'
        'Vanuit dit huis gaf de Britse generaal Urquhart zijn bevelen. Dat zijn '
        'opdrachten voor de soldaten. Hier werd de verdediging van '
        'Oosterbeek geleid. Nu is het huis een museum: het Airborne Museum.',
  ),
  'cemetery': LocationText(
    teaser:
        'Een stille plek tussen de bomen. Hier liggen soldaten begraven die '
        'nooit meer thuiskwamen.',
    shortDescription:
        'Op deze begraafplaats liggen 1.770 soldaten van de geallieerden. De '
        'meesten stierven tijdens de Slag om Arnhem.',
    historyText:
        'Veel van deze soldaten waren nog heel jong, soms pas 18 of 19 jaar. '
        'Ze hadden ouders, broers, zussen en vrienden.\n\n'
        'Elk jaar leggen kinderen uit Oosterbeek hier bloemen bij de graven. '
        'Dat doen ze al sinds 1945. Zo vergeten we deze mensen niet.\n\n'
        'Doe hier rustig. Je doet de opdracht bij de ingang of op een bankje, '
        'niet tussen de graven.',
  ),
  'mortierput': LocationText(
    teaser: 'Het lijkt gewoon een kuil in het bos. Maar kijk eens goed...',
    shortDescription:
        'Aan de Van Lennepweg zie je nog een spoor van de strijd uit 1944: '
        'een kuil waaruit soldaten met een mortier schoten.',
    historyText:
        'Tijdens de gevechten groeven soldaten kuilen in de grond. In zo’n '
        'kuil waren ze beter beschermd tegen kogels.\n\n'
        'Vanuit sommige kuilen schoten ze met een mortier. Een mortier is een '
        'soort kanon dat in een hoge boog schiet, over bomen en huizen heen.\n\n'
        'In deze kuil zaten Britse soldaten van het Border Regiment. Ze '
        'schoten op Duitse soldaten die van de noordkant kwamen.\n\n'
        'Na 80 jaar zijn de meeste kuilen vol blaadjes en zand. Maar deze '
        'kuil kun je nog steeds zien in de grond.',
  ),
  'dreyeroord': LocationText(
    teaser:
        'Nu is dit een hotel. In 1944 noemden de soldaten het “Het Witte '
        'Huis”.',
    shortDescription:
        'Dit witte hotel lag aan de rand van het gebied van de Britten. Hier '
        'vochten soldaten uit Schotland.',
    historyText:
        'Het hotel was wit en je kon het van ver zien. Daarom noemden de '
        'Britten het “The White House”.\n\n'
        'De Schotse soldaten vochten hier dagenlang. Veel van hen raakten '
        'gewond. Ze hadden bijna geen eten, water en kogels meer.\n\n'
        'Op 21 september vielen de Duitsers het hotel aan. Dat heet nu de '
        'Slag om het Witte Huis. De Schotten moesten het hotel daarna '
        'verlaten.\n\n'
        'De mensen van het hotel zaten al die tijd in de kelder. Buiten werd '
        'gevochten en hun hotel ging kapot.',
    // CONTROLEER: sloop en herbouw van het hotel.
    readMoreText:
        'Het oude hotel is in 2018 afgebroken. Het gebouw dat je nu ziet, is '
        'in 2019 nagebouwd in de oude stijl.',
  ),
  'oude_kerk': LocationText(
    teaser:
        'Een heel oude kerk vlak bij de rivier. In 1944 werd hier gevochten.',
    shortDescription:
        'De Britten konden de brug in Arnhem niet bereiken. Daarom '
        'beschermden ze zich in Oosterbeek, ook hier bij de kerk.',
    historyText:
        'De Britten zaten vast in Oosterbeek. Om hen heen stonden de Duitsers. '
        'Alleen aan de kant van de rivier was nog een weg open. Op een kaart '
        'leek hun gebied op een hoefijzer.\n\n'
        'Deze kerk lag aan de zuidkant van dat gebied. Majoor Lonsdale '
        'bracht hier soldaten van verschillende groepen bij elkaar. Samen '
        'heetten ze de Lonsdale Force. Op 20 september gingen ze terug naar '
        'deze kerk.\n\n'
        'In het huis naast de kerk woonde Kate ter Horst met haar vijf '
        'kinderen. Zij zorgde voor honderden gewonde soldaten. Ze las hen voor '
        'uit de Bijbel, zodat ze zich beter voelden.\n\n'
        'De gevechten waren tussen gewone huizen en tuinen, waar mensen '
        'gewoon woonden.',
  ),
  'airborne_bridge': LocationText(
    teaser:
        'Vlak bij de brug staat een klein museum. Hier hoor je de verhalen '
        'van mensen die bij de brug waren.',
    shortDescription:
        'Airborne at the Bridge ligt aan de Rijnkade, vlak bij de John '
        'Frostbrug. Hier worden verhalen verteld van mensen uit '
        'verschillende landen.',
    historyText:
        'Bij de brug vochten Britse en Duitse soldaten tegen elkaar. Er was '
        'ook een Nederlandse soldaat bij.\n\n'
        // CONTROLEER: korte levensverhalen van historische personen.
        'Hier leer je drie van hen kennen. John Grayburn was een Britse '
        'luitenant. Na zijn dood kreeg hij een medaille omdat hij zo dapper '
        'was. Viktor Gräbner was een Duitse kapitein. Hij probeerde met zijn '
        'legerwagens over de brug te rijden. Jacob Groenewoud was een '
        'Nederlandse kapitein die de Britten hielp.\n\n'
        'Alle drie kwamen ze om bij de brug. Hun verhalen laten zien dat de '
        'oorlog mensen uit veel landen raakte.',
  ),
  'john_frostbrug': LocationText(
    teaser: 'Het einddoel! Hier komt alles samen wat je onderweg hebt ontdekt.',
    shortDescription:
        'Dit is de brug waar het allemaal om draaide. Hij heet nu de John '
        'Frostbrug, naar de Britse leider die hier vocht.',
    historyText:
        'Op de avond van 17 september kwamen een paar honderd Britse soldaten '
        'bij de brug aan. Hun leider was John Frost. De andere soldaten '
        'kwamen niet zo ver.\n\n'
        'Drie dagen en nachten hielden ze de brug vast. Ze wachtten op hulp '
        'van tanks uit het zuiden. Maar die hulp kwam niet op tijd.\n\n'
        'Op 21 september konden de soldaten niet meer en gaven ze zich over. '
        'De brug werd later kapotgemaakt. Na de oorlog is hij opnieuw '
        'gebouwd.',
  ),
};

// ── ROUTE B: MIDDELBARE SCHOOL (HAVO/VWO) ────────────────────────────────
// Meer feiten, namen en verbanden. Leerlingen moeten informatie combineren.

const Map<String, LocationText> locationTextsB = {
  'hartenstein': LocationText(
    teaser:
        'Een statige villa in Oosterbeek. In september 1944 werden hier '
        'beslissingen genomen die de afloop van de slag bepaalden.',
    shortDescription:
        'Villa Hartenstein was tijdens de Slag om Arnhem het hoofdkwartier van '
        'de Britse 1e Luchtlandingsdivisie onder generaal-majoor Roy Urquhart. '
        'Vanuit hier werd de verdediging van Oosterbeek aangestuurd.',
    historyText:
        'Na de doorbraak in Normandië leek de Duitse weerstand in het westen '
        'te breken. Veldmaarschalk Montgomery wilde met Operatie Market Garden '
        'de Siegfriedlinie omzeilen, de Rijn oversteken en het Ruhrgebied '
        'bereiken – het industriële hart van Duitsland. De oorlog zou dan '
        'vóór Kerstmis 1944 voorbij kunnen zijn.\n\n'
        'Drie luchtlandingsdivisies (Market) moesten bruggen innemen bij '
        'Eindhoven, Nijmegen en Arnhem. Het Britse XXX Corps van generaal '
        'Horrocks (Garden) moest daarna over één weg ruim 100 km naar het '
        'noorden oprukken. Arnhem was het verste doel.\n\n'
        'Omdat er te weinig vliegtuigen waren, werd de Britse divisie in '
        'meerdere dagen aangevoerd. De landingsterreinen bij Wolfheze en '
        'Renkum lagen 8 tot 12 km van de brug, omdat de planners bang waren '
        'voor Duits luchtafweergeschut dichter bij Arnhem en de grond daar '
        'minder geschikt leek. Een deel van de troepen moest achterblijven '
        'om die terreinen te bewaken.',
    readMoreText:
        // CONTROLEER: inlichtingen over Duitse pantsertroepen.
        'Er waren waarschuwingen: het Nederlandse verzet en luchtfoto’s '
        'wezen op Duitse pantservoertuigen bij Arnhem. Daar rustten de 9e en '
        '10e SS-Panzerdivisie uit onder generaal Bittrich. De planners namen '
        'die signalen niet serieus genoeg. Daarnaast werkten veel '
        'radioverbindingen slecht, waardoor Urquhart lange tijd geen '
        'contact had met zijn eenheden. Sinds 1978 is Hartenstein het '
        'Airborne Museum.',
  ),
  'mortierput': LocationText(
    teaser:
        'Een ondiepe kuil langs de Van Lennepweg. Wie goed kijkt, ziet een '
        'stelling uit 1944.',
    shortDescription:
        'Aan de Van Lennepweg lag in september 1944 een mortierstelling van '
        'het 1st Battalion, The Border Regiment, aan de westkant van de '
        'perimeter.',
    historyText:
        'Een mortier vuurt granaten in een steile boog af. De bemanning kan '
        'daardoor vanuit een ingegraven, beschermde positie over bomen en '
        'huizen heen schieten, zonder de vijand zelf te zien. Een waarnemer '
        'verderop gaf door waar de granaten moesten neerkomen.\n\n'
        'Vanuit deze put vuurden mannen van het 1st Border Regiment op Duitse '
        'troepen die de perimeter vanuit het noorden aanvielen.\n\n'
        'De kuil van de oorspronkelijke mortierput is nog steeds in de grond '
        'te herkennen. Zo’n spoor in het landschap is een materiële bron: '
        'het bevestigt en verrijkt wat rapporten en ooggetuigen vertellen.',
  ),
  'dreyeroord': LocationText(
    teaser:
        'Nu een gebouw in vooroorlogse stijl. In 1944 heette het “The White '
        'House” en werd hier fel gevochten.',
    shortDescription:
        'Hotel Dreyeroord was in september 1944 enkele dagen het hoofdkwartier '
        'van het 7th Battalion, King’s Own Scottish Borderers (KOSB), aan de '
        'noordkant van de perimeter.',
    historyText:
        'Het witte hotel was een opvallend herkenningspunt; de Britten '
        'noemden het “The White House”. De KOSB moesten van hieruit de '
        'noordkant van de perimeter verdedigen.\n\n'
        'Op 21 september 1944 vielen Duitse troepen het hotel en de omgeving '
        'aan. Bij deze “Battle of the White House” leden de Schotten zware '
        'verliezen. Uiteindelijk moesten ze het hotel verlaten en zich '
        'verder terugtrekken in de perimeter.\n\n'
        'Ook burgers waren bij de gevechten betrokken: de familie die het '
        'hotel bewoonde, schuilde dagenlang in de kelder.',
    // CONTROLEER: sloop en herbouw van het hotel.
    readMoreText:
        'Het oorspronkelijke hotel sloot in 2014 en werd in 2018 gesloopt. Het '
        'huidige gebouw is in 2019 in de vooroorlogse stijl teruggebouwd.',
  ),
  'cemetery': LocationText(
    teaser:
        'Rijen witte grafstenen tussen de bomen. Achter elke steen zit een '
        'verhaal.',
    shortDescription:
        'Op de Arnhem Oosterbeek War Cemetery liggen 1.770 geallieerde '
        'militairen begraven. De meesten sneuvelden tijdens de Slag om Arnhem '
        'in september 1944.',
    historyText:
        // CONTROLEER: herbegraving na de oorlog.
        'Direct na de slag werden doden vaak begraven waar ze vielen: in '
        'tuinen, parken en bermen. Na de oorlog werden de graven op deze '
        'begraafplaats bijeengebracht. De Commonwealth War Graves Commission '
        'onderhoudt haar.\n\n'
        'Op de grafstenen staan naam, rang, eenheid, leeftijd en soms een '
        'tekst van de familie. Veel gesneuvelden waren nog geen twintig. Het '
        'aantal graven maakt zichtbaar hoeveel mensen bij de strijd '
        'betrokken waren.\n\n'
        'Sinds 1945 leggen schoolkinderen uit Oosterbeek bij de jaarlijkse '
        'herdenking bloemen op de graven. Zo wordt de herinnering '
        'doorgegeven.\n\n'
        'Gedraag je hier rustig. Doe de opdrachten bij de ingang of op een '
        'bankje, niet tussen de graven.',
  ),
  'oude_kerk': LocationText(
    teaser:
        'Een eeuwenoude kerk vlak bij de Rijn. In 1944 lag hij midden in de '
        'frontlinie van een ingesloten divisie.',
    shortDescription:
        'De Oude Kerk lag aan de zuidoostkant van de Britse perimeter in '
        'Oosterbeek, vlak bij de rivier.',
    historyText:
        'Vanaf 19 september was duidelijk dat de rest van de divisie de brug '
        'niet meer zou bereiken. De Britten trokken zich terug in een '
        'hoefijzervormige perimeter rond Hartenstein. De open kant lag aan de '
        'Rijn: alleen daarlangs konden nog versterkingen komen. De Duitsers '
        'noemden het gebied de “Hexenkessel” (heksenketel).\n\n'
        'Majoor Richard Lonsdale verzamelde soldaten uit verschillende, '
        'uiteengeslagen eenheden. Op 20 september trok deze “Lonsdale Force” '
        'zich terug op de Oude Kerk, een van de zuidelijkste punten van de '
        'perimeter. Vanaf hier verdedigden ze de zuidoostkant tegen '
        'aanvallen met tanks en artillerie.\n\n'
        'In de pastorie naast de kerk, die als hulppost diende, verzorgde '
        'Kate ter Horst honderden '
        'gewonden, terwijl haar eigen kinderen in de kelder zaten. Ook andere '
        'burgers werden overvallen door de strijd in hun straat.\n\n'
        'Vanaf de kerk kijk je over de Rijn naar Driel. Daar landden op 21 '
        'september, twee dagen later dan gepland door slecht weer, Poolse '
        'parachutisten van generaal Sosabowski. De veerpont was onbruikbaar; '
        'in kleine boten bereikten maar enkele honderden Polen de perimeter. '
        'In de nacht van 25 op 26 september werden zo’n 2.400 man juist '
        'andersom over de rivier geëvacueerd: Operatie Berlin.',
    readMoreText:
        'Burgers in de perimeter zaten dagenlang in kelders zonder stromend '
        'water of elektriciteit. Na de slag moesten alle inwoners van '
        'Oosterbeek en Arnhem vertrekken. Hun huizen werden daarna vaak '
        'geplunderd. De Hongerwinter die volgde, trof het westen van '
        'Nederland zwaar.',
  ),
  'drielse_veer': LocationText(
    teaser:
        'Aan de overkant van de Rijn lag Oosterbeek. Zo dichtbij – en toch '
        'bijna onbereikbaar.',
    shortDescription:
        'Bij Driel landden op 21 september 1944 Poolse parachutisten van de 1e '
        'Onafhankelijke Parachutistenbrigade onder generaal Stanisław '
        'Sosabowski.',
    historyText:
        'De Poolse brigade zou eigenlijk op 19 september landen, maar door '
        'slecht weer in Engeland werd de landing steeds uitgesteld. Toen de '
        'Polen eindelijk bij Driel neerkwamen, was de strijd bij de brug al '
        'verloren. De veerpont tussen Driel en Heveadorp, waarmee ze wilden '
        'oversteken, was niet meer beschikbaar.\n\n'
        'De Rijn is hier zo’n 400 meter breed en stroomt snel. In de nachten '
        'van 22 en 23 september probeerden de Polen in kleine boten over te '
        'steken, onder Duits vuur. Slechts enkele honderden bereikten de '
        'Britten.\n\n'
        'In de nacht van 25 op 26 september volgde Operatie Berlin: ongeveer '
        '2.400 overlevenden werden juist andersom over de rivier geëvacueerd.',
    readMoreText:
        // CONTROLEER: rol van Sosabowski na de slag.
        'Sosabowski had al vóór de operatie kritiek op het plan. Na de slag '
        'kreeg hij van Britse leiders deels de schuld van het mislukken en '
        'werd hij uit zijn functie gezet. Pas veel later werd zijn rol '
        'eerlijker beoordeeld; in 2006 kreeg de Poolse brigade postuum de '
        'Militaire Willems-Orde. Het Drielse Veer ligt nu op fietsroutes '
        'als de Liberation Route, die plekken uit de oorlog met elkaar '
        'verbinden.',
  ),
  'airborne_bridge': LocationText(
    teaser:
        'Eén brug, vier dagen, honderden verhalen. Wie vertelt het verhaal – '
        'en waarom vertelt iedereen het anders?',
    shortDescription:
        // CONTROLEER: rollen van historische personen.
        'Airborne at the Bridge aan de Rijnkade vertelt het verhaal van de '
        'strijd om de brug vanuit verschillende perspectieven, onder meer '
        'via de Britse luitenant John Grayburn, de Duitse '
        'Hauptsturmführer (SS-kapitein) Viktor Eberhard Gräbner en de '
        'Nederlandse kapitein Jacob Groenewoud.',
    historyText:
        'Britse en Poolse soldaten, Duitse troepen en Nederlandse burgers '
        'maakten dezelfde dagen mee, maar zagen ze heel anders. Ieder '
        'perspectief levert andere bronnen op: dagboeken, legerrapporten, '
        'interviews, foto’s en propaganda.\n\n'
        'Bronnen zijn niet neutraal. Een officieel rapport kan verliezen '
        'kleiner maken, een herinnering van veertig jaar later kan '
        'onnauwkeurig zijn. Een historicus vraagt daarom steeds: wie maakte '
        'deze bron, wanneer en met welk doel?\n\n'
        'Na de slag moesten bijna alle inwoners van Arnhem hun stad '
        'verlaten. Toen zij in 1945 terugkeerden, was veel verwoest of '
        'geplunderd.',
    readMoreText:
        'Het boek “A Bridge Too Far” (Cornelius Ryan, 1974) en de gelijknamige '
        'film (1977) bepaalden lang het beeld van de slag. Zulke populaire '
        'verhalen zijn zelf ook een bron: ze laten zien hoe er later over '
        'de gebeurtenissen werd gedacht.',
  ),
  'john_frostbrug': LocationText(
    teaser:
        'Het einddoel van de operatie. Hier komt alles samen wat jullie '
        'onderweg hebben ontdekt.',
    shortDescription:
        'De verkeersbrug over de Rijn was het laatste en belangrijkste doel van '
        'Operatie Market Garden. Sinds 1977 heet hij de John Frostbrug.',
    historyText:
        'Op de avond van 17 september 1944 bereikte het 2e Bataljon van '
        'luitenant-kolonel John Frost de noordkant van de brug. Een aanval op '
        'de zuidkant mislukte. De andere bataljons werden in Arnhem en '
        'Oosterbeek tegengehouden.\n\n'
        // CONTROLEER: aantallen en tijdstippen.
        'Op 18 september probeerde een Duitse verkenningseenheid onder '
        'Viktor Gräbner de brug vanuit het zuiden over te steken; de aanval '
        'werd afgeslagen. Ongeveer 740 man hielden de noordkant drie dagen '
        'en nachten vast, terwijl XXX Corps pas op 20 september de brug bij '
        'Nijmegen veroverde.\n\n'
        'Op de ochtend van 21 september gaven de laatste verdedigers zich '
        'over. Van de ruim 10.000 man van de divisie keerde minder dan een '
        'kwart terug; de rest sneuvelde, raakte gewond of werd '
        'krijgsgevangen genomen.',
  ),
};

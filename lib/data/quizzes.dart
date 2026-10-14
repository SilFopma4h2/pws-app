// AANPASBARE PWS-INHOUD
// Voorkennisquiz en eindquiz, per niveau. Route A (basisschool) gebruikt
// `preQuizA`/`postQuizA`, route B (havo/vwo) `preQuizB`/`postQuizB`.
// Vragen met dezelfde `id` worden na afloop met elkaar vergeleken.
// `correctIndex`: 0 = eerste optie. De laatste optie is altijd “Weet ik niet”.

import '../models/quiz_model.dart';

// ── ROUTE A: BASISSCHOOL (GROEP 7-8) ─────────────────────────────────────

const List<QuizQuestion> _questionsA = [
  QuizQuestion(
    id: 'q_goal',
    question: 'Wat wilden de geallieerden met Operatie Market Garden?',
    options: [
      'Bruggen veroveren en zo snel naar Duitsland gaan',
      'Een nieuwe stad bouwen',
      'Op vakantie gaan in Nederland',
      'Weet ik niet',
    ],
    correctIndex: 0,
  ),
  QuizQuestion(
    id: 'q_river',
    question: 'Over welke rivier ligt de brug in Arnhem?',
    options: ['De Maas', 'De Rijn', 'De Amstel', 'Weet ik niet'],
    correctIndex: 1,
  ),
  QuizQuestion(
    id: 'q_bridges',
    question: 'Waarom waren de bruggen zo belangrijk?',
    options: [
      'Omdat er geld onder de bruggen lag',
      'Omdat tanks en auto’s zo over de rivier konden',
      'Omdat de soldaten er wilden slapen',
      'Weet ik niet',
    ],
    correctIndex: 1,
  ),
  QuizQuestion(
    id: 'q_airborne',
    question: 'Hoe kwamen de Britse soldaten bij Arnhem aan?',
    options: [
      'Met de trein',
      'Met de boot over de zee',
      'Met parachutes en zweefvliegtuigen',
      'Weet ik niet',
    ],
    correctIndex: 2,
  ),
  QuizQuestion(
    id: 'q_oosterbeek',
    question: 'Wat gebeurde er in Oosterbeek?',
    options: [
      'De Britten verdedigden zich daar, met de Duitsers om hen heen',
      'Daar werd een groot feest gevierd',
      'Er gebeurde niets',
      'Weet ik niet',
    ],
    correctIndex: 0,
  ),
  QuizQuestion(
    id: 'q_result',
    question: 'Hoe liep het af bij Arnhem?',
    options: [
      'De oorlog was meteen voorbij',
      'Arnhem werd in één dag bevrijd',
      'De Britten konden de brug niet houden en moesten terug',
      'Weet ik niet',
    ],
    correctIndex: 2,
  ),
];

const Quiz preQuizA = Quiz(
  id: 'pre',
  title: 'Wat weten jullie al?',
  intro:
      'Een paar vragen vooraf. Dit is geen toets en je krijgt geen cijfer. '
      'Weet je het niet? Kies dan gewoon “Weet ik niet”.',
  questions: _questionsA,
);

const Quiz postQuizA = Quiz(
  id: 'post',
  title: 'Wat weten jullie nu?',
  intro:
      'Dezelfde vragen als aan het begin. Zo zie je wat je onderweg hebt '
      'geleerd. Ook nu geen cijfer.',
  questions: _questionsA,
);

// ── ROUTE B: MIDDELBARE SCHOOL (HAVO/VWO) ────────────────────────────────

const List<QuizQuestion> _questionsB = [
  QuizQuestion(
    id: 'q_aim',
    question: 'Wat was het strategische doel van Operatie Market Garden?',
    options: [
      'Amsterdam en Rotterdam bevrijden',
      'De Siegfriedlinie omzeilen en via de Rijn het Ruhrgebied bereiken',
      'De Duitse marine in de Noordzee uitschakelen',
      'Een luchtmachtbasis bij Arnhem veroveren',
      'Weet ik niet',
    ],
    correctIndex: 1,
  ),
  QuizQuestion(
    id: 'q_market_garden',
    question: 'Wat betekenen “Market” en “Garden” in de naam van de operatie?',
    options: [
      'Market = de Britse divisie, Garden = de Amerikaanse divisies',
      'Market = de aanval op Arnhem, Garden = de aanval op Nijmegen',
      'Market = luchtlandingstroepen die bruggen innemen, Garden = XXX Corps '
          'dat over land oprukt',
      'Market = de bevoorrading, Garden = de evacuatie',
      'Weet ik niet',
    ],
    correctIndex: 2,
  ),
  QuizQuestion(
    id: 'q_german',
    question: 'Waarom stuitten de Britten bij Arnhem op zo veel verzet?',
    options: [
      'Arnhem was de Duitse hoofdstad van Nederland',
      'De 9e en 10e SS-Panzerdivisie rustten vlak bij Arnhem uit',
      'Duitse troepen waren vooraf precies op de hoogte van het plan',
      'De Nederlandse bevolking hielp de Duitsers',
      'Weet ik niet',
    ],
    correctIndex: 1,
  ),
  // CONTROLEER: reden landingsterreinen (luchtafweer, ongeschikte polder).
  QuizQuestion(
    id: 'q_landing_zones',
    question:
        'Waarom landden de Britten 8 tot 12 km van de brug in plaats van '
        'er vlak naast?',
    options: [
      'Ze wilden de Duitsers verrassen door van achteren te komen',
      'De brug was op 17 september nog niet gebouwd',
      'Open terrein dichtbij ontbrak en planners vreesden luchtafweer bij '
          'de stad',
      'De piloten kenden de weg niet',
      'Weet ik niet',
    ],
    correctIndex: 2,
  ),
  QuizQuestion(
    id: 'q_poles',
    question: 'Wat was de rol van de Poolse brigade van Sosabowski?',
    options: [
      'Ze landden bij Driel om de Britten over de Rijn te versterken',
      'Ze veroverden de brug bij Nijmegen',
      'Ze verdedigden de brug in Arnhem samen met Frost',
      'Ze vormden de voorhoede van XXX Corps',
      'Weet ik niet',
    ],
    correctIndex: 0,
  ),
  QuizQuestion(
    id: 'q_berlin',
    question: 'Wat was Operatie Berlin (25/26 september 1944)?',
    options: [
      'Een nieuwe aanval op de brug in Arnhem',
      'De luchtlanding van de Polen bij Driel',
      'Een geallieerde opmars naar Berlijn',
      'De evacuatie van de overlevenden over de Rijn',
      'Weet ik niet',
    ],
    correctIndex: 3,
  ),
  QuizQuestion(
    id: 'q_civilians',
    question: 'Wat waren de gevolgen van de slag voor de burgers?',
    options: [
      'Arnhem en Oosterbeek werden direct bevrijd',
      'Inwoners moesten hun stad verlaten en het westen kreeg de Hongerwinter',
      'Burgers merkten weinig van de gevechten',
      'Alle burgers werden naar Engeland gebracht',
      'Weet ik niet',
    ],
    correctIndex: 1,
  ),
  QuizQuestion(
    id: 'q_sources',
    question:
        'Een Brits legerrapport uit 1944 beschrijft de slag. Wat is de '
        'belangrijkste vraag die je over die bron stelt?',
    options: [
      'Hoe lang is het rapport?',
      'Is het rapport getypt of met de hand geschreven?',
      'Staan er foto’s in?',
      'Wie maakte het, wanneer en met welk doel?',
      'Weet ik niet',
    ],
    correctIndex: 3,
  ),
];

const Quiz preQuizB = Quiz(
  id: 'pre',
  title: 'Wat weten jullie al?',
  intro:
      'Een korte check vooraf. Dit is geen toets en er komt geen cijfer. '
      'Twijfel je? Kies dan gerust “Weet ik niet”.',
  questions: _questionsB,
);

const Quiz postQuizB = Quiz(
  id: 'post',
  title: 'Wat weten jullie nu?',
  intro:
      'Dezelfde vragen als aan het begin. Zo zien jullie wat je onderweg '
      'hebt ontdekt. Ook nu geen cijfer.',
  questions: _questionsB,
);

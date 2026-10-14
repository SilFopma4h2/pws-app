// AANPASBARE PWS-INHOUD
// Aanwijzingen die leerlingen na een missie krijgen. Een missie verwijst via
// `clueId` naar een aanwijzing in deze lijst.

import '../models/clue_model.dart';

const Map<String, ClueModel> clues = {
  'clue_distance': ClueModel(
    id: 'clue_distance',
    type: ClueType.mapFragment,
    title: 'Te ver van de brug',
    value: '8–12 KM',
    description:
        'De landingsterreinen lagen 8 tot 12 kilometer van de brug. De troepen '
        'moesten een lange weg afleggen voordat ze hun doel bereikten.',
  ),
  'clue_remembrance': ClueModel(
    id: 'clue_remembrance',
    type: ClueType.name,
    title: 'Herinnering',
    value: 'DAVID LORD',
    description:
        'Piloot David Lord bleef supplies afwerpen terwijl zijn toestel in '
        'brand stond. Hij is begraven op de Airborne War Cemetery.',
  ),
  'clue_perimeter': ClueModel(
    id: 'clue_perimeter',
    type: ClueType.symbol,
    title: 'Hoefijzer aan de Rijn',
    value: '∩',
    description:
        'De Britse perimeter in Oosterbeek had de vorm van een hoefijzer. De '
        'open kant lag aan de Rijn – de enige weg naar hulp.',
  ),
  'clue_traces': ClueModel(
    id: 'clue_traces',
    type: ClueType.historicalFact,
    title: 'Sporen in het landschap',
    value: 'MORTIER',
    description:
        'Uitgegraven stellingen beschermden soldaten. Sommige sporen zijn na '
        '80 jaar nog steeds in het landschap te zien.',
  ),
  'clue_white_house': ClueModel(
    id: 'clue_white_house',
    type: ClueType.document,
    title: 'Rapport Witte Huis',
    value: 'TE WEINIG',
    description:
        'Te weinig mannen, munitie, voedsel en water. De Britten konden het '
        'grote gebied niet blijven verdedigen.',
  ),
  'clue_river': ClueModel(
    id: 'clue_river',
    type: ClueType.mapFragment,
    title: 'De Rijn als barrière',
    value: 'RIJN',
    description:
        'Zonder brug of pont was de brede Rijn bijna niet over te steken. '
        'Versterkingen uit Driel bereikten Oosterbeek nauwelijks.',
  ),
  'clue_perspectives': ClueModel(
    id: 'clue_perspectives',
    type: ClueType.timelineFragment,
    title: 'Vele perspectieven',
    value: '4 STEMMEN',
    description:
        'Britten, Duitsers, Polen en Nederlandse burgers beleefden dezelfde '
        'dagen heel verschillend.',
  ),
};

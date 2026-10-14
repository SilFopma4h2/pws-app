// AANPASBARE PWS-INHOUD
// Route A en Route B. Pas `locationIds` aan om locaties te verplaatsen of
// de volgorde te veranderen. De eerste id is het startpunt, de laatste id is
// de plek van de eindmissie. Gebruik de id's uit lib/data/locations.dart.

import '../models/route_model.dart';
import 'final_mission.dart';
import 'location_texts.dart';
import 'missions.dart';
import 'quizzes.dart';

const List<RouteModel> routes = [
  RouteModel(
    id: 'route_a',
    title: 'Route A',
    subtitle: 'De perimeter van Oosterbeek',
    description:
        'Volg de Britse verdediging door Oosterbeek: van het hoofdkwartier '
        'via het Witte Huis en de Oude Kerk naar de brug in Arnhem. '
        'Voor de basisschool.',
    locationIds: [
      'hartenstein',
      'mortierput',
      'dreyeroord',
      'cemetery',
      'oude_kerk',
      'john_frostbrug',
    ],
    estimatedDistance: 'ca. 14 km',
    estimatedDuration: 'ca. 3 uur',
    difficulty: 'Basisschool (groep 7-8)',
    texts: locationTextsA,
    missions: missionsA,
    finalMission: finalMissionA,
    preQuiz: preQuizA,
    postQuiz: postQuizA,
  ),
  RouteModel(
    id: 'route_b',
    title: 'Route B',
    subtitle: 'Over de Rijn naar de brug',
    description:
        'Ontdek waarom de Rijn zo’n grote rol speelde: van Hartenstein via '
        'Driel aan de overkant naar de brug en de verhalen van Arnhem. '
        'Voor de middelbare school.',
    locationIds: [
      'hartenstein',
      'oude_kerk',
      'drielse_veer',
      'airborne_bridge',
      'john_frostbrug',
    ],
    estimatedDistance: 'ca. 18 km',
    estimatedDuration: 'ca. 3,5 uur',
    difficulty: 'Middelbare school (havo/vwo)',
    texts: locationTextsB,
    missions: missionsB,
    finalMission: finalMissionB,
    preQuiz: preQuizB,
    postQuiz: postQuizB,
  ),
];

RouteModel? routeById(String? id) {
  for (final r in routes) {
    if (r.id == id) return r;
  }
  return null;
}

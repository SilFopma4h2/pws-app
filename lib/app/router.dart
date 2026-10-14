import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/providers.dart';
import '../screens/developer/developer_screen.dart';
import '../screens/final_mission/completion_screen.dart';
import '../screens/final_mission/final_mission_screen.dart';
import '../screens/home/home_shell.dart';
import '../screens/home/route_overview_screen.dart';
import '../screens/info/info_screen.dart';
import '../screens/location/location_screen.dart';
import '../screens/map/map_screen.dart';
import '../screens/mission/mission_screen.dart';
import '../screens/mission_book/mission_book_screen.dart';
import '../screens/quiz/quiz_screen.dart';
import '../screens/route_selection/route_selection_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/start/intro_screen.dart';
import '../screens/start/mode_screen.dart';
import '../screens/start/safety_screen.dart';
import '../screens/start/start_screen.dart';

const _needsRoute = [
  '/route',
  '/map',
  '/book',
  '/location',
  '/mission',
  '/final',
  '/quiz',
];

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final hasRoute = ref.read(progressProvider).routeId != null;
      final path = state.matchedLocation;
      if (!hasRoute && _needsRoute.any(path.startsWith)) return '/routes';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const StartScreen()),
      GoRoute(path: '/safety', builder: (_, _) => const SafetyScreen()),
      GoRoute(path: '/intro', builder: (_, _) => const IntroScreen()),
      GoRoute(path: '/mode', builder: (_, _) => const ModeScreen()),
      GoRoute(
        path: '/quiz/:id',
        builder: (_, s) => QuizScreen(quizId: s.pathParameters['id']!),
      ),
      GoRoute(path: '/routes', builder: (_, _) => const RouteSelectionScreen()),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/route',
                builder: (_, _) => const RouteOverviewScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/map', builder: (_, _) => const MapScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/book',
                builder: (_, _) => const MissionBookScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/info', builder: (_, _) => const InfoScreen()),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/location/:id',
        builder: (_, s) => LocationScreen(locationId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/mission/:id',
        builder: (_, s) => MissionScreen(locationId: s.pathParameters['id']!),
      ),
      GoRoute(path: '/final', builder: (_, _) => const FinalMissionScreen()),
      GoRoute(path: '/complete', builder: (_, _) => const CompletionScreen()),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
      GoRoute(path: '/developer', builder: (_, _) => const DeveloperScreen()),
    ],
  );
});

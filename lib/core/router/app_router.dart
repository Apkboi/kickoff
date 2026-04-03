import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/competitions/presentation/controllers/competition_bloc.dart';
import '../../features/competitions/presentation/controllers/competition_detail_bloc.dart';
import '../../features/competitions/presentation/controllers/competition_detail_event.dart';
import '../../features/competitions/presentation/controllers/manage_league_bloc.dart';
import '../../features/competitions/presentation/controllers/manage_league_event.dart';
import '../../features/competitions/presentation/screens/competition_detail_screen.dart';
import '../../features/competitions/presentation/screens/competition_screen.dart';
import '../../features/competitions/presentation/controllers/match_detail_bloc.dart';
import '../../features/competitions/presentation/controllers/match_detail_event.dart';
import '../../features/competitions/presentation/controllers/match_prediction_bloc.dart';
import '../../features/competitions/presentation/screens/manage_league_screen.dart';
import '../../features/competitions/presentation/screens/match_detail_screen.dart';
import '../../features/competitions/presentation/screens/league_fixtures_screen.dart';
import '../../features/create_league/presentation/screens/create_league_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../shared/widgets/kickoff_main_shell.dart';
import '../../features/explore/presentation/controllers/explore_bloc.dart';
import '../../features/explore/presentation/controllers/explore_event.dart';
import '../../features/explore/presentation/screens/explore_screen.dart';
import '../../features/profile/presentation/controllers/profile_bloc.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../constants/app_routes.dart';
import '../di/injection.dart';
import '../../features/auth/presentation/controllers/auth_bloc.dart';
import 'go_router_refresh.dart';
import 'router_guards.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.signIn,
    refreshListenable: GoRouterRefreshStream(getIt<AuthBloc>().stream),
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
          return KickoffMainShell(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return NoTransitionPage<void>(
                    key: state.pageKey,
                    child: const HomeScreen(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.explore,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return NoTransitionPage<void>(
                    key: state.pageKey,
                    child: BlocProvider(
                      create: (BuildContext _) {
                        final ExploreBloc bloc = getIt();
                        bloc.add(const ExploreStarted());
                        return bloc;
                      },
                      child: const ExploreScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.competitions,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  final CompetitionBloc competitionBloc = getIt();
                  return NoTransitionPage<void>(
                    key: state.pageKey,
                    child: BlocProvider.value(
                      value: competitionBloc,
                      child: const CompetitionScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.profile,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return NoTransitionPage<void>(
                    key: state.pageKey,
                    child: BlocProvider(
                      create: (BuildContext _) => getIt<ProfileBloc>(),
                      child: const ProfileScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '${AppRoutes.users}/:userId',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final String userId = state.pathParameters['userId']!;
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: BlocProvider(
              create: (BuildContext _) => getIt<ProfileBloc>(),
              child: ProfileScreen(profileUserId: userId),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.createLeague,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const CreateLeagueScreen(),
          );
        },
      ),
      GoRoute(
        path: '${AppRoutes.competitions}/:competitionId',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final String id = state.pathParameters['competitionId']!;
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: BlocProvider(
              create: (BuildContext _) {
                final CompetitionDetailBloc bloc = getIt();
                bloc.add(CompetitionDetailRequested(id));
                return bloc;
              },
              child: CompetitionDetailScreen(competitionId: id),
            ),
          );
        },
      ),
      GoRoute(
        path: '${AppRoutes.competitions}/:competitionId/manage',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final String id = state.pathParameters['competitionId']!;
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: BlocProvider(
              create: (BuildContext _) {
                final ManageLeagueBloc bloc = getIt();
                bloc.add(ManageLeagueStarted(id));
                return bloc;
              },
              child: ManageLeagueScreen(competitionId: id),
            ),
          );
        },
      ),
      GoRoute(
        path: '${AppRoutes.competitions}/:competitionId/manage/fixtures',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final String id = state.pathParameters['competitionId']!;
          final selected = state.uri.queryParameters['selected'] ?? '';
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: ManageLeagueFixturesScreen(
              competitionId: id,
              selectedMatchId: selected,
            ),
          );
        },
      ),
      GoRoute(
        path: '${AppRoutes.competitions}/:competitionId/fixtures',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final String id = state.pathParameters['competitionId']!;
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: LeagueFixturesScreen(competitionId: id),
          );
        },
      ),
      GoRoute(
        path: '${AppRoutes.competitions}/:competitionId/matches/:matchId',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final String competitionId = state.pathParameters['competitionId']!;
          final String matchId = state.pathParameters['matchId']!;
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (BuildContext _) {
                    final MatchDetailBloc bloc = getIt();
                    bloc.add(
                      MatchDetailWatchStarted(
                        competitionId: competitionId,
                        matchId: matchId,
                      ),
                    );
                    return bloc;
                  },
                ),
                BlocProvider<MatchPredictionBloc>(
                  create: (BuildContext _) => getIt<MatchPredictionBloc>(),
                ),
              ],
              child: MatchDetailScreen(
                competitionId: competitionId,
                matchId: matchId,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (BuildContext context, GoRouterState state) {
          return const SignInScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (BuildContext context, GoRouterState state) {
          return const SignUpScreen();
        },
      ),
    ],
    redirect: RouterGuards.authGuard,
  );
}

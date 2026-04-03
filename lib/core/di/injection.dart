import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/user_profile_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/observe_auth_state_usecase.dart';
import '../../features/auth/domain/usecases/send_password_reset_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_with_email_usecase.dart';
import '../../features/auth/presentation/controllers/auth_bloc.dart';
import '../../features/competitions/data/datasources/competition_remote_datasource.dart';
import '../../features/competitions/data/datasources/manage_league_remote_datasource.dart';
import '../../features/competitions/data/datasources/league_fixtures_pagination_remote_datasource.dart';
import '../../features/competitions/data/datasources/league_fixtures_live_remote_datasource.dart';
import '../../features/competitions/data/datasources/match_detail_stream_datasource.dart';
import '../../features/competitions/data/datasources/match_prediction_remote_datasource.dart';
import '../../features/competitions/data/repositories/competition_repository_impl.dart';
import '../../features/competitions/data/repositories/league_fixtures_repository_impl.dart';
import '../../features/competitions/data/repositories/manage_league_repository_impl.dart';
import '../../features/competitions/data/repositories/match_detail_repository_impl.dart';
import '../../features/competitions/data/repositories/match_prediction_repository_impl.dart';
import '../../features/competitions/domain/repositories/competition_repository.dart';
import '../../features/competitions/domain/repositories/league_fixtures_repository.dart';
import '../../features/competitions/domain/repositories/manage_league_repository.dart';
import '../../features/competitions/domain/repositories/match_detail_repository.dart';
import '../../features/competitions/domain/repositories/match_prediction_repository.dart';
import '../../features/competitions/domain/usecases/get_competition_by_id_usecase.dart';
import '../../features/competitions/domain/usecases/get_competitions_usecase.dart';
import '../../features/competitions/domain/usecases/watch_competition_standings_usecase.dart';
import '../../features/competitions/domain/usecases/get_manage_league_admin_match_snapshot_usecase.dart';
import '../../features/competitions/domain/usecases/get_manage_league_dashboard_usecase.dart';
import '../../features/competitions/domain/usecases/get_manage_league_match_events_usecase.dart';
import '../../features/competitions/domain/usecases/start_manage_league_match_usecase.dart';
import '../../features/competitions/domain/usecases/update_manage_league_match_scores_usecase.dart';
import '../../features/competitions/domain/usecases/add_manage_league_match_event_usecase.dart';
import '../../features/competitions/domain/usecases/end_manage_league_match_usecase.dart';
import '../../features/competitions/domain/usecases/update_manage_league_match_schedule_usecase.dart';
import '../../features/competitions/domain/usecases/end_league_competition_usecase.dart';
import '../../features/competitions/domain/usecases/get_league_fixtures_page_starting_at_match_id_usecase.dart';
import '../../features/competitions/domain/usecases/get_league_fixtures_page_usecase.dart';
import '../../features/competitions/domain/usecases/watch_league_fixtures_usecase.dart';
import '../../features/competitions/domain/usecases/watch_match_detail_usecase.dart';
import '../../features/competitions/domain/usecases/watch_match_prediction_usecase.dart';
import '../../features/competitions/domain/usecases/submit_match_prediction_usecase.dart';
import '../../features/competitions/domain/usecases/watch_league_prediction_leaderboard_usecase.dart';
import '../../features/competitions/presentation/controllers/competition_bloc.dart';
import '../../features/competitions/presentation/controllers/competition_detail_bloc.dart';
import '../../features/competitions/presentation/controllers/manage_league_bloc.dart';
import '../../features/competitions/presentation/controllers/match_detail_bloc.dart';
import '../../features/competitions/presentation/controllers/match_prediction_bloc.dart';
import '../../features/home/data/datasources/home_remote_datasource.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/watch_live_matches_usecase.dart';
import '../../features/home/domain/usecases/watch_trending_leagues_usecase.dart';
import '../../features/home/domain/usecases/watch_upcoming_matches_usecase.dart';
import '../../features/home/presentation/controllers/live_matches_bloc.dart';
import '../../features/home/presentation/controllers/trending_leagues_bloc.dart';
import '../../features/home/presentation/controllers/upcoming_matches_bloc.dart';
import '../../features/create_league/data/datasources/league_publish_remote_datasource.dart';
import '../../features/create_league/data/datasources/league_storage_remote_datasource.dart';
import '../../features/create_league/data/datasources/user_search_remote_datasource.dart';
import '../../features/create_league/data/repositories/league_publish_repository_impl.dart';
import '../../features/create_league/data/repositories/league_storage_repository_impl.dart';
import '../../features/create_league/data/repositories/user_search_repository_impl.dart';
import '../../features/create_league/domain/repositories/league_publish_repository.dart';
import '../../features/create_league/domain/repositories/league_storage_repository.dart';
import '../../features/create_league/domain/repositories/user_search_repository.dart';
import '../../features/create_league/domain/usecases/publish_league_usecase.dart';
import '../../features/create_league/domain/usecases/search_users_for_league_usecase.dart';
import '../../features/create_league/domain/usecases/upload_league_draft_image_usecase.dart';
import '../../features/create_league/presentation/controllers/create_league_bloc.dart';
import '../../features/explore/data/datasources/explore_remote_datasource.dart';
import '../../features/explore/data/repositories/explore_repository_impl.dart';
import '../../features/explore/domain/repositories/explore_repository.dart';
import '../../features/explore/domain/usecases/get_explore_feed_usecase.dart';
import '../../features/explore/presentation/controllers/explore_bloc.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_user_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_display_name_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_photo_usecase.dart';
import '../../features/profile/presentation/controllers/profile_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
    ..registerLazySingleton<UserProfileRemoteDataSource>(
      () => UserProfileRemoteDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt()))
    ..registerLazySingleton<ObserveAuthStateUseCase>(
      () => ObserveAuthStateUseCase(getIt()),
    )
    ..registerLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(getIt()),
    )
    ..registerLazySingleton<SignInWithEmailUseCase>(
      () => SignInWithEmailUseCase(getIt()),
    )
    ..registerLazySingleton<SignUpWithEmailUseCase>(
      () => SignUpWithEmailUseCase(getIt()),
    )
    ..registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(getIt()))
    ..registerLazySingleton<SendPasswordResetUseCase>(
      () => SendPasswordResetUseCase(getIt()),
    )
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        observeAuthStateUseCase: getIt(),
        signInWithEmailUseCase: getIt(),
        signUpWithEmailUseCase: getIt(),
        signOutUseCase: getIt(),
        sendPasswordResetUseCase: getIt(),
      ),
    )
    ..registerLazySingleton<CompetitionRemoteDataSource>(
      () => CompetitionRemoteDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<CompetitionRepository>(
      () => CompetitionRepositoryImpl(getIt()),
    )
    ..registerLazySingleton<GetCompetitionsUseCase>(
      () => GetCompetitionsUseCase(getIt()),
    )
    ..registerLazySingleton<GetCompetitionByIdUseCase>(
      () => GetCompetitionByIdUseCase(getIt()),
    )
    ..registerLazySingleton<WatchCompetitionStandingsUseCase>(
      () => WatchCompetitionStandingsUseCase(getIt()),
    )
    ..registerLazySingleton<CompetitionBloc>(() => CompetitionBloc(getIt<CompetitionRepository>()))
    ..registerFactory<CompetitionDetailBloc>(() => CompetitionDetailBloc(getIt(), getIt()))
    ..registerLazySingleton<ManageLeagueRemoteDataSource>(
      () => ManageLeagueRemoteDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<ManageLeagueRepository>(() => ManageLeagueRepositoryImpl(getIt()))
    ..registerLazySingleton<LeagueFixturesPaginationRemoteDataSource>(
      () => LeagueFixturesPaginationRemoteDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<LeagueFixturesLiveRemoteDataSource>(
      () => LeagueFixturesLiveRemoteDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<LeagueFixturesRepository>(
      () => LeagueFixturesRepositoryImpl(getIt(), getIt()),
    )
    ..registerLazySingleton<GetLeagueFixturesPageUseCase>(
      () => GetLeagueFixturesPageUseCase(getIt()),
    )
    ..registerLazySingleton<GetLeagueFixturesPageStartingAtMatchIdUseCase>(
      () => GetLeagueFixturesPageStartingAtMatchIdUseCase(getIt()),
    )
    ..registerLazySingleton<WatchLeagueFixturesUseCase>(
      () => WatchLeagueFixturesUseCase(getIt()),
    )
    ..registerLazySingleton<GetManageLeagueDashboardUseCase>(
      () => GetManageLeagueDashboardUseCase(getIt()),
    )
    ..registerLazySingleton<GetManageLeagueAdminMatchSnapshotUseCase>(
      () => GetManageLeagueAdminMatchSnapshotUseCase(getIt()),
    )
    ..registerLazySingleton<GetManageLeagueMatchEventsUseCase>(
      () => GetManageLeagueMatchEventsUseCase(getIt()),
    )
    ..registerLazySingleton<StartManageLeagueMatchUseCase>(
      () => StartManageLeagueMatchUseCase(getIt()),
    )
    ..registerLazySingleton<UpdateManageLeagueMatchScoresUseCase>(
      () => UpdateManageLeagueMatchScoresUseCase(getIt()),
    )
    ..registerLazySingleton<AddManageLeagueMatchEventUseCase>(
      () => AddManageLeagueMatchEventUseCase(getIt()),
    )
    ..registerLazySingleton<EndManageLeagueMatchUseCase>(
      () => EndManageLeagueMatchUseCase(getIt()),
    )
    ..registerLazySingleton<UpdateManageLeagueMatchScheduleUseCase>(
      () => UpdateManageLeagueMatchScheduleUseCase(getIt()),
    )
    ..registerLazySingleton<EndLeagueCompetitionUseCase>(
      () => EndLeagueCompetitionUseCase(getIt()),
    )
    ..registerFactory<ManageLeagueBloc>(
      () => ManageLeagueBloc(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<MatchDetailStreamDataSource>(
      () => MatchDetailStreamDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<MatchDetailRepository>(() => MatchDetailRepositoryImpl(getIt()))
    ..registerLazySingleton<WatchMatchDetailUseCase>(() => WatchMatchDetailUseCase(getIt()))
    ..registerFactory<MatchDetailBloc>(() => MatchDetailBloc(getIt()))
    ..registerLazySingleton<MatchPredictionRemoteDataSource>(
      () => MatchPredictionRemoteDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<MatchPredictionRepository>(
      () => MatchPredictionRepositoryImpl(getIt()),
    )
    ..registerLazySingleton<WatchMatchPredictionUseCase>(
      () => WatchMatchPredictionUseCase(getIt()),
    )
    ..registerLazySingleton<SubmitMatchPredictionUseCase>(
      () => SubmitMatchPredictionUseCase(getIt()),
    )
    ..registerLazySingleton<WatchLeaguePredictionLeaderboardUseCase>(
      () => WatchLeaguePredictionLeaderboardUseCase(getIt()),
    )
    ..registerFactory<MatchPredictionBloc>(
      () => MatchPredictionBloc(getIt(), getIt()),
    )
    ..registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(getIt()))
    ..registerLazySingleton<WatchLiveMatchesUseCase>(
      () => WatchLiveMatchesUseCase(getIt()),
    )
    ..registerLazySingleton<WatchUpcomingMatchesUseCase>(
      () => WatchUpcomingMatchesUseCase(getIt()),
    )
    ..registerLazySingleton<WatchTrendingLeaguesUseCase>(
      () => WatchTrendingLeaguesUseCase(getIt()),
    )
    ..registerLazySingleton<LiveMatchesBloc>(() => LiveMatchesBloc(getIt()))
    ..registerLazySingleton<UpcomingMatchesBloc>(() => UpcomingMatchesBloc(getIt()))
    ..registerLazySingleton<TrendingLeaguesBloc>(() => TrendingLeaguesBloc(getIt()))
    ..registerLazySingleton<LeagueStorageRemoteDataSource>(
      LeagueStorageRemoteDataSourceImpl.new,
    )
    ..registerLazySingleton<LeagueStorageRepository>(
      () => LeagueStorageRepositoryImpl(getIt()),
    )
    ..registerLazySingleton<UploadLeagueDraftImageUseCase>(
      () => UploadLeagueDraftImageUseCase(getIt()),
    )
    ..registerLazySingleton<UserSearchRemoteDataSource>(
      () => UserSearchRemoteDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<LeaguePublishRemoteDataSource>(
      () => LeaguePublishRemoteDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<UserSearchRepository>(
      () => UserSearchRepositoryImpl(getIt()),
    )
    ..registerLazySingleton<LeaguePublishRepository>(
      () => LeaguePublishRepositoryImpl(getIt()),
    )
    ..registerLazySingleton<SearchUsersForLeagueUseCase>(
      () => SearchUsersForLeagueUseCase(getIt()),
    )
    ..registerLazySingleton<PublishLeagueUseCase>(
      () => PublishLeagueUseCase(getIt()),
    )
    ..registerFactory<CreateLeagueBloc>(
      () => CreateLeagueBloc(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ),
    )
    ..registerLazySingleton<ExploreRemoteDataSource>(
      () => ExploreRemoteDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<ExploreRepository>(() => ExploreRepositoryImpl(getIt()))
    ..registerLazySingleton<GetExploreFeedUseCase>(() => GetExploreFeedUseCase(getIt()))
    ..registerFactory<ExploreBloc>(() => ExploreBloc(getIt<ExploreRepository>()))
    ..registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(getIt()))
    ..registerLazySingleton<GetUserProfileUseCase>(() => GetUserProfileUseCase(getIt()))
    ..registerLazySingleton<UpdateProfilePhotoUseCase>(
      () => UpdateProfilePhotoUseCase(getIt()),
    )
    ..registerLazySingleton<UpdateProfileDisplayNameUseCase>(
      () => UpdateProfileDisplayNameUseCase(getIt()),
    )
    ..registerFactory<ProfileBloc>(
      () => ProfileBloc(
        getCurrentUser: getIt(),
        getUserProfile: getIt(),
        updateProfilePhoto: getIt(),
        updateDisplayName: getIt(),
      ),
    );
}

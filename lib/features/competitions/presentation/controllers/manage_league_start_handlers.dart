import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/usecases/get_current_user_usecase.dart';
import '../../domain/entities/league_fixture_summary_entity.dart';
import '../../domain/entities/manage_match_event_entity.dart';
import '../../domain/league_detail_admin.dart';
import '../../domain/usecases/get_competition_by_id_usecase.dart';
import '../../domain/usecases/get_league_fixtures_page_starting_at_match_id_usecase.dart';
import '../../domain/usecases/get_manage_league_admin_match_snapshot_usecase.dart';
import '../../domain/usecases/get_manage_league_dashboard_usecase.dart';
import '../../domain/usecases/get_manage_league_match_events_usecase.dart';
import '../../domain/usecases/start_manage_league_match_usecase.dart';
import '../controllers/manage_league_event.dart';
import '../controllers/manage_league_state.dart';
import 'manage_league_state_emitters.dart';
class ManageLeagueStartHandlers {
  ManageLeagueStartHandlers({
    required GetCompetitionByIdUseCase getCompetitionById,
    required GetCurrentUserUseCase getCurrentUser,
    required GetManageLeagueDashboardUseCase getDashboard,
    required GetManageLeagueAdminMatchSnapshotUseCase getAdminMatchSnapshot,
    required GetLeagueFixturesPageStartingAtMatchIdUseCase getFixturesPageStartingAtMatchId,
    required StartManageLeagueMatchUseCase startMatch,
    required GetManageLeagueMatchEventsUseCase getMatchEvents,
  }) : _getCompetitionById = getCompetitionById,
        _getCurrentUser = getCurrentUser,
        _getDashboard = getDashboard,
        _getAdminMatchSnapshot = getAdminMatchSnapshot,
        _getFixturesPageStartingAtMatchId = getFixturesPageStartingAtMatchId,
        _startMatch = startMatch,
        _getMatchEvents = getMatchEvents;

  final GetCompetitionByIdUseCase _getCompetitionById;
  final GetCurrentUserUseCase _getCurrentUser;
  final GetManageLeagueDashboardUseCase _getDashboard;
  final GetManageLeagueAdminMatchSnapshotUseCase _getAdminMatchSnapshot;
  final GetLeagueFixturesPageStartingAtMatchIdUseCase _getFixturesPageStartingAtMatchId;
  final StartManageLeagueMatchUseCase _startMatch;
  final GetManageLeagueMatchEventsUseCase _getMatchEvents;

  Future<void> onStarted(ManageLeagueStarted event, Emitter<ManageLeagueState> emit) async {
    emit(const ManageLeagueLoading());
    final userFuture = _getCurrentUser(const GetCurrentUserParams());
    final compFuture = _getCompetitionById(GetCompetitionByIdParams(id: event.competitionId));
    final userResult = await userFuture;
    final user = userResult.fold((_) => null, (u) => u);
    final auth = user?.isAuthenticated ?? false;
    final uid = user?.id;
    final compResult = await compFuture;
    final detail = compResult.fold((_) => null, (value) => value);
    if (detail == null) {
      final message = compResult.fold((failure) => failure.message, (_) => 'Unable to load league');
      emit(ManageLeagueError(message));
      return;
    }
    if (!detail.isViewerAdmin(userId: uid, authenticated: auth)) {
      emit(const ManageLeagueAccessDenied());
      return;
    }
    final dashResult = await _getDashboard(GetManageLeagueDashboardParams(competitionId: event.competitionId));
    final dashboard = dashResult.fold((_) => null, (value) => value);
    if (dashboard == null) {
      final message = dashResult.fold((failure) => failure.message, (_) => 'Unable to load league');
      emit(ManageLeagueError(message));
      return;
    }
    await emitLoadedWithDeferredEvents(
      emit: emit,
      competitionId: event.competitionId,
      fixtures: dashboard.fixtures,
      selectedMatchId: dashboard.selectedMatchId,
      startedMatchIds: const {},
      snapshot: dashboard.snapshot,
      isLiveUpdateMode: true,
      loadEvents: _loadEvents,
    );
  }
  Future<void> onMatchSelected({
    required ManageLeagueMatchSelected event,
    required String competitionId,
    required ManageLeagueState currentState,
    required Emitter<ManageLeagueState> emit,
  }) async {
    if (currentState is! ManageLeagueLoaded) return;
    final s = currentState;
    var fixtures = List<LeagueFixtureSummaryEntity>.from(s.fixtures);
    if (!fixtures.any((f) => f.matchId == event.matchId)) {
      final fixturesResult = await _getFixturesPageStartingAtMatchId(
        GetLeagueFixturesPageStartingAtMatchIdParams(
          competitionId: competitionId,
          matchId: event.matchId,
          limit: 12,
        ),
      );
      final merged = fixturesResult.fold<List<LeagueFixtureSummaryEntity>?>((failure) {
        emit(ManageLeagueError(failure.message));
        return null;
      }, (page) {
        final map = {for (final f in s.fixtures) f.matchId: f};
        for (final f in page.fixtures) {
          map[f.matchId] = f;
        }
        final list = map.values.toList()
          ..sort((a, b) {
            final ka = a.kickoffAt;
            final kb = b.kickoffAt;
            if (ka != null && kb != null) return ka.compareTo(kb);
            return a.matchId.compareTo(b.matchId);
          });
        return list;
      });
      if (merged == null) return;
      fixtures = merged;
    }

    final result = await _getAdminMatchSnapshot(
      GetManageLeagueAdminMatchSnapshotParams(
        competitionId: competitionId,
        leagueName: s.snapshot.leagueName,
        matchId: event.matchId,
        fixtures: fixtures,
        startedMatchIds: s.startedMatchIds,
      ),
    );
    await result.fold(
      (failure) async => emit(ManageLeagueError(failure.message)),
      (snapshot) async {
        await emitLoadedWithDeferredEvents(
          emit: emit,
          competitionId: competitionId,
          fixtures: fixtures,
          selectedMatchId: event.matchId,
          startedMatchIds: s.startedMatchIds,
          snapshot: snapshot,
          isLiveUpdateMode: s.isLiveUpdateMode,
          loadEvents: _loadEvents,
        );
      },
    );
  }
  Future<void> onMatchStarted({
    required ManageLeagueMatchStarted event,
    required String competitionId,
    required ManageLeagueState currentState,
    required Emitter<ManageLeagueState> emit,
  }) async {
    if (currentState is! ManageLeagueLoaded) return;
    final s = currentState;
    LeagueFixtureSummaryEntity? target;
    for (final f in s.fixtures) {
      if (f.matchId == event.matchId) {
        target = f;
        break;
      }
    }
    if (target == null || target.phase != LeagueFixturePhase.scheduled) return;
    final startResult = await _startMatch(
      StartManageLeagueMatchParams(
        competitionId: competitionId,
        matchId: event.matchId,
        streamLinks: event.streamLinks,
      ),
    );
    var startedOk = false;
    startResult.fold(
      (failure) => emit(ManageLeagueError(failure.message)),
      (_) => startedOk = true,
    );
    if (!startedOk) return;
    final nextStarted = {...s.startedMatchIds, event.matchId};
    final nextFixtures = s.fixtures.map((f) {
      if (f.matchId != event.matchId) return f;
      final round = _extractRound(f.statusLine);
      return f.copyWith(
        phase: LeagueFixturePhase.live,
        statusLine: round == null ? 'Live' : 'Live • Round $round',
      );
    }).toList();
    final result = await _getAdminMatchSnapshot(
      GetManageLeagueAdminMatchSnapshotParams(
        competitionId: competitionId,
        leagueName: s.snapshot.leagueName,
        matchId: event.matchId,
        fixtures: nextFixtures,
        startedMatchIds: nextStarted,
      ),
    );
    await result.fold(
      (failure) async => emit(ManageLeagueError(failure.message)),
      (snapshot) async {
        await emitLoadedWithDeferredEvents(
          emit: emit,
          competitionId: competitionId,
          fixtures: nextFixtures,
          selectedMatchId: event.matchId,
          startedMatchIds: nextStarted,
          snapshot: snapshot,
          isLiveUpdateMode: s.isLiveUpdateMode,
          loadEvents: _loadEvents,
        );
      },
    );
  }

  int? _extractRound(String statusLine) {
    final m = RegExp(r'Round\s+(\d+)', caseSensitive: false).firstMatch(statusLine);
    if (m == null) return null;
    return int.tryParse(m.group(1) ?? '');
  }

  Future<List<ManageMatchEventEntity>> _loadEvents({
    required String competitionId,
    required String matchId,
  }) async {
    final result = await _getMatchEvents(
      GetManageLeagueMatchEventsParams(competitionId: competitionId, matchId: matchId, limit: 25),
    );
    return result.fold((_) => const [], (events) => events);
  }
}


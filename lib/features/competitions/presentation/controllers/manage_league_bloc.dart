import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/get_competition_by_id_usecase.dart';
import '../../domain/usecases/get_league_fixtures_page_starting_at_match_id_usecase.dart';
import '../../domain/usecases/start_manage_league_match_usecase.dart';
import '../../domain/usecases/update_manage_league_match_scores_usecase.dart';
import '../../domain/usecases/add_manage_league_match_event_usecase.dart';
import '../../domain/usecases/end_manage_league_match_usecase.dart';
import '../../domain/usecases/update_manage_league_match_schedule_usecase.dart';
import '../../domain/usecases/end_league_competition_usecase.dart'
    show EndLeagueCompetitionParams, EndLeagueCompetitionUseCase;
import '../../domain/usecases/get_manage_league_admin_match_snapshot_usecase.dart';
import '../../domain/usecases/get_manage_league_dashboard_usecase.dart';
import '../../domain/usecases/get_manage_league_match_events_usecase.dart';
import 'manage_league_event_update_handlers.dart';
import 'manage_league_score_update_handlers.dart';
import 'manage_league_start_handlers.dart';
import 'manage_league_event.dart';
import 'manage_league_state.dart';

class ManageLeagueBloc extends Bloc<ManageLeagueEvent, ManageLeagueState> {
  ManageLeagueBloc(
    this._getCompetitionById,
    this._getCurrentUser,
    this._getDashboard,
    this._getAdminMatchSnapshot,
    this._getFixturesPageStartingAtMatchId,
    this._startMatch,
    this._updateMatchScores,
    this._addMatchEvent,
    this._endMatch,
    this._updateMatchSchedule,
    this._getMatchEvents,
    this._endLeagueCompetition,
  ) : super(const ManageLeagueInitial()) {
    _startHandlers = ManageLeagueStartHandlers(
      getCompetitionById: _getCompetitionById,
      getCurrentUser: _getCurrentUser,
      getDashboard: _getDashboard,
      getAdminMatchSnapshot: _getAdminMatchSnapshot,
      getFixturesPageStartingAtMatchId: _getFixturesPageStartingAtMatchId,
      startMatch: _startMatch,
      getMatchEvents: _getMatchEvents,
    );
    _scoreHandlers = ManageLeagueScoreUpdateHandlers(
      updateMatchScores: _updateMatchScores,
      addMatchEvent: _addMatchEvent,
    );
    _eventHandlers = ManageLeagueEventUpdateHandlers(
      addMatchEvent: _addMatchEvent,
      endMatch: _endMatch,
      updateMatchSchedule: _updateMatchSchedule,
    );

    on<ManageLeagueStarted>(_onStarted);
    on<ManageLeagueMatchSelected>(_onMatchSelected);
    on<ManageLeagueMatchStarted>(_onMatchStarted);
    on<ManageLeagueMatchEnded>(_onMatchEnded);
    on<ManageLeagueHomeScoreDelta>(_onHomeDelta);
    on<ManageLeagueAwayScoreDelta>(_onAwayDelta);
    on<ManageLeagueLiveModeToggled>(_onLiveMode);
    on<ManageLeagueQuickEventAdded>(_onQuickEvent);
    on<ManageLeagueEventDeleted>(_onDeleteEvent);
    on<ManageLeagueScheduleUpdated>(_onScheduleUpdated);
    on<ManageLeagueCompetitionEnded>(_onLeagueEnded);
  }

  final GetCompetitionByIdUseCase _getCompetitionById;
  final GetCurrentUserUseCase _getCurrentUser;
  final GetManageLeagueDashboardUseCase _getDashboard;
  final GetManageLeagueAdminMatchSnapshotUseCase _getAdminMatchSnapshot;
  final GetLeagueFixturesPageStartingAtMatchIdUseCase _getFixturesPageStartingAtMatchId;
  final StartManageLeagueMatchUseCase _startMatch;
  final UpdateManageLeagueMatchScoresUseCase _updateMatchScores;
  final AddManageLeagueMatchEventUseCase _addMatchEvent;
  final EndManageLeagueMatchUseCase _endMatch;
  final UpdateManageLeagueMatchScheduleUseCase _updateMatchSchedule;
  final GetManageLeagueMatchEventsUseCase _getMatchEvents;
  final EndLeagueCompetitionUseCase _endLeagueCompetition;

  late final ManageLeagueStartHandlers _startHandlers;
  late final ManageLeagueScoreUpdateHandlers _scoreHandlers;
  late final ManageLeagueEventUpdateHandlers _eventHandlers;

  String _competitionId = '';

  Future<void> _onStarted(ManageLeagueStarted event, Emitter<ManageLeagueState> emit) async {
    _competitionId = event.competitionId;
    await _startHandlers.onStarted(event, emit);
  }

  Future<void> _onMatchSelected(ManageLeagueMatchSelected event, Emitter<ManageLeagueState> emit) async {
    await _startHandlers.onMatchSelected(
      event: event,
      competitionId: _competitionId,
      currentState: state,
      emit: emit,
    );
  }

  Future<void> _onMatchStarted(ManageLeagueMatchStarted event, Emitter<ManageLeagueState> emit) async {
    await _startHandlers.onMatchStarted(
      event: event,
      competitionId: _competitionId,
      currentState: state,
      emit: emit,
    );
  }

  Future<void> _onHomeDelta(ManageLeagueHomeScoreDelta event, Emitter<ManageLeagueState> emit) async {
    await _scoreHandlers.onHomeDelta(
      event: event,
      competitionId: _competitionId,
      currentState: state,
      emit: emit,
    );
  }

  Future<void> _onAwayDelta(ManageLeagueAwayScoreDelta event, Emitter<ManageLeagueState> emit) async {
    await _scoreHandlers.onAwayDelta(
      event: event,
      competitionId: _competitionId,
      currentState: state,
      emit: emit,
    );
  }

  void _onLiveMode(ManageLeagueLiveModeToggled event, Emitter<ManageLeagueState> emit) {
    _scoreHandlers.onLiveMode(
      event: event,
      currentState: state,
      emit: emit,
    );
  }

  Future<void> _onQuickEvent(ManageLeagueQuickEventAdded event, Emitter<ManageLeagueState> emit) async {
    await _eventHandlers.onQuickEvent(
      event: event,
      competitionId: _competitionId,
      currentState: state,
      emit: emit,
    );
  }

  Future<void> _onMatchEnded(ManageLeagueMatchEnded event, Emitter<ManageLeagueState> emit) async {
    await _eventHandlers.onMatchEnded(
      event: event,
      competitionId: _competitionId,
      currentState: state,
      emit: emit,
    );
  }

  void _onDeleteEvent(ManageLeagueEventDeleted event, Emitter<ManageLeagueState> emit) {
    _eventHandlers.onDeleteEvent(
      event: event,
      currentState: state,
      emit: emit,
    );
  }

  Future<void> _onScheduleUpdated(ManageLeagueScheduleUpdated event, Emitter<ManageLeagueState> emit) async {
    await _eventHandlers.onScheduleUpdated(
      event: event,
      competitionId: _competitionId,
      currentState: state,
      emit: emit,
    );
  }

  Future<void> _onLeagueEnded(ManageLeagueCompetitionEnded event, Emitter<ManageLeagueState> emit) async {
    if (state is! ManageLeagueLoaded) return;
    final s = state as ManageLeagueLoaded;
    final result = await _endLeagueCompetition(
      EndLeagueCompetitionParams(
        competitionId: _competitionId,
        winnerDisplayName: event.winnerDisplayName,
      ),
    );
    result.fold(
      (failure) => emit(ManageLeagueError(failure.message)),
      (_) => emit(s),
    );
  }
}

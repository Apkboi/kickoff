import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/league_fixture_summary_entity.dart';
import '../../domain/entities/manage_match_event_entity.dart';
import '../../domain/usecases/add_manage_league_match_event_usecase.dart';
import '../../domain/usecases/update_manage_league_match_scores_usecase.dart';
import 'manage_league_event.dart';
import 'manage_league_state.dart';

class ManageLeagueScoreUpdateHandlers {
  ManageLeagueScoreUpdateHandlers({
    required UpdateManageLeagueMatchScoresUseCase updateMatchScores,
    required AddManageLeagueMatchEventUseCase addMatchEvent,
  })  : _updateMatchScores = updateMatchScores,
        _addMatchEvent = addMatchEvent;

  final UpdateManageLeagueMatchScoresUseCase _updateMatchScores;
  final AddManageLeagueMatchEventUseCase _addMatchEvent;

  Future<void> onHomeDelta({
    required ManageLeagueHomeScoreDelta event,
    required String competitionId,
    required ManageLeagueState currentState,
    required Emitter<ManageLeagueState> emit,
  }) async {
    if (currentState is! ManageLeagueLoaded || !currentState.snapshot.scoringEnabled) return;
    final s = currentState;
    final next = (s.snapshot.homeScore + event.delta).clamp(0, 99);

    final result = await _updateMatchScores(
      UpdateManageLeagueMatchScoresParams(
        competitionId: competitionId,
        matchId: s.selectedMatchId,
        homeScore: next,
        awayScore: s.snapshot.awayScore,
      ),
    );

    final failed = result.fold((failure) => failure, (_) => null);
    if (failed != null) {
      emit(ManageLeagueError(failed.message));
      return;
    }

    final updated = _loadedWithScores(
      source: s,
      homeScore: next,
      awayScore: s.snapshot.awayScore,
    );
    if (event.delta > 0) {
      final scorer = (event.scorerName == null || event.scorerName!.trim().isEmpty)
          ? updated.snapshot.homeTeamName
          : event.scorerName!.trim();
      final withGoal = await _appendGoalEvent(
        loaded: updated,
        competitionId: competitionId,
        scorerName: scorer,
        teamLabel: updated.snapshot.homeTeamName,
      );
      emit(withGoal);
      return;
    }
    emit(updated);
  }

  Future<void> onAwayDelta({
    required ManageLeagueAwayScoreDelta event,
    required String competitionId,
    required ManageLeagueState currentState,
    required Emitter<ManageLeagueState> emit,
  }) async {
    if (currentState is! ManageLeagueLoaded || !currentState.snapshot.scoringEnabled) return;
    final s = currentState;
    final next = (s.snapshot.awayScore + event.delta).clamp(0, 99);

    final result = await _updateMatchScores(
      UpdateManageLeagueMatchScoresParams(
        competitionId: competitionId,
        matchId: s.selectedMatchId,
        homeScore: s.snapshot.homeScore,
        awayScore: next,
      ),
    );

    final failed = result.fold((failure) => failure, (_) => null);
    if (failed != null) {
      emit(ManageLeagueError(failed.message));
      return;
    }

    final updated = _loadedWithScores(
      source: s,
      homeScore: s.snapshot.homeScore,
      awayScore: next,
    );
    if (event.delta > 0) {
      final scorer = (event.scorerName == null || event.scorerName!.trim().isEmpty)
          ? updated.snapshot.awayTeamName
          : event.scorerName!.trim();
      final withGoal = await _appendGoalEvent(
        loaded: updated,
        competitionId: competitionId,
        scorerName: scorer,
        teamLabel: updated.snapshot.awayTeamName,
      );
      emit(withGoal);
      return;
    }
    emit(updated);
  }

  void onLiveMode({
    required ManageLeagueLiveModeToggled event,
    required ManageLeagueState currentState,
    required Emitter<ManageLeagueState> emit,
  }) {
    if (currentState is! ManageLeagueLoaded) return;
    emit(
      ManageLeagueLoaded(
        fixtures: currentState.fixtures,
        selectedMatchId: currentState.selectedMatchId,
        startedMatchIds: currentState.startedMatchIds,
        snapshot: currentState.snapshot,
        isLiveUpdateMode: event.isLiveUpdate,
        isEventsLoading: currentState.isEventsLoading,
      ),
    );
  }

  List<LeagueFixtureSummaryEntity> _updateFixtureScores({
    required List<LeagueFixtureSummaryEntity> fixtures,
    required String matchId,
    required int homeScore,
    required int awayScore,
  }) {
    return fixtures.map((f) => f.matchId != matchId ? f : f.copyWith(homeScore: homeScore, awayScore: awayScore)).toList();
  }

  ManageLeagueLoaded _loadedWithScores({
    required ManageLeagueLoaded source,
    required int homeScore,
    required int awayScore,
  }) {
    return ManageLeagueLoaded(
      fixtures: _updateFixtureScores(
        fixtures: source.fixtures,
        matchId: source.selectedMatchId,
        homeScore: homeScore,
        awayScore: awayScore,
      ),
      selectedMatchId: source.selectedMatchId,
      startedMatchIds: source.startedMatchIds,
      snapshot: source.snapshot.copyWith(homeScore: homeScore, awayScore: awayScore),
      isLiveUpdateMode: source.isLiveUpdateMode,
      isEventsLoading: source.isEventsLoading,
    );
  }

  Future<ManageLeagueLoaded> _appendGoalEvent({
    required ManageLeagueLoaded loaded,
    required String competitionId,
    required String scorerName,
    required String teamLabel,
  }) async {
    const minuteLabel = "64'";
    final result = await _addMatchEvent(
      AddManageLeagueMatchEventParams(
        competitionId: competitionId,
        matchId: loaded.selectedMatchId,
        kind: ManageMatchEventKind.goal,
        playerName: scorerName,
        minuteLabel: minuteLabel,
        title: scorerName,
        subtitle: 'GOAL • $teamLabel',
      ),
    );

    return result.fold(
      (_) => loaded,
      (eventId) {
        final event = ManageMatchEventEntity(
          id: eventId,
          minuteLabel: minuteLabel,
          title: scorerName,
          subtitle: 'GOAL • $teamLabel',
          kind: ManageMatchEventKind.goal,
        );
        return ManageLeagueLoaded(
          fixtures: loaded.fixtures,
          selectedMatchId: loaded.selectedMatchId,
          startedMatchIds: loaded.startedMatchIds,
          snapshot: loaded.snapshot.copyWith(events: [event, ...loaded.snapshot.events]),
          isLiveUpdateMode: loaded.isLiveUpdateMode,
          isEventsLoading: loaded.isEventsLoading,
        );
      },
    );
  }
}


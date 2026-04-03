import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/utils/league_fixture_firestore_mapper.dart';
import '../../domain/entities/league_fixture_summary_entity.dart';
import '../../domain/entities/manage_match_event_entity.dart';
import '../../domain/usecases/add_manage_league_match_event_usecase.dart';
import '../../domain/usecases/end_manage_league_match_usecase.dart';
import '../../domain/usecases/update_manage_league_match_schedule_usecase.dart';
import 'manage_league_event.dart';
import 'manage_league_state.dart';

class ManageLeagueEventUpdateHandlers {
  ManageLeagueEventUpdateHandlers({
    required AddManageLeagueMatchEventUseCase addMatchEvent,
    required EndManageLeagueMatchUseCase endMatch,
    required UpdateManageLeagueMatchScheduleUseCase updateMatchSchedule,
  })  : _addMatchEvent = addMatchEvent,
        _endMatch = endMatch,
        _updateMatchSchedule = updateMatchSchedule;

  final AddManageLeagueMatchEventUseCase _addMatchEvent;
  final EndManageLeagueMatchUseCase _endMatch;
  final UpdateManageLeagueMatchScheduleUseCase _updateMatchSchedule;

  Future<void> onQuickEvent({
    required ManageLeagueQuickEventAdded event,
    required String competitionId,
    required ManageLeagueState currentState,
    required Emitter<ManageLeagueState> emit,
  }) async {
    if (currentState is! ManageLeagueLoaded || !currentState.snapshot.scoringEnabled) return;
    final s = currentState;

    late final String title;
    late final String subtitle;
    final fallbackPlayer = event.kind == ManageMatchEventKind.redCard
        ? s.snapshot.homeTeamName
        : s.snapshot.awayTeamName;
    final playerName = (event.playerName == null || event.playerName!.trim().isEmpty)
        ? fallbackPlayer
        : event.playerName!.trim();
    switch (event.kind) {
      case ManageMatchEventKind.yellowCard:
        title = playerName;
        subtitle = 'YELLOW CARD';
      case ManageMatchEventKind.redCard:
        title = playerName;
        subtitle = 'RED CARD';
      case ManageMatchEventKind.goal:
        title = 'Player';
        subtitle = 'GOAL';
      case ManageMatchEventKind.substitution:
        title = 'Substitution';
        subtitle = 'SUB • PENDING';
    }

    const minuteLabel = "64'";
    final eventResult = await _addMatchEvent(
      AddManageLeagueMatchEventParams(
        competitionId: competitionId,
        matchId: s.selectedMatchId,
        kind: event.kind,
        playerName: playerName,
        minuteLabel: minuteLabel,
        title: title,
        subtitle: subtitle,
      ),
    );

    eventResult.fold(
      (failure) => emit(ManageLeagueError(failure.message)),
      (eventId) {
        final ev = ManageMatchEventEntity(id: eventId, minuteLabel: minuteLabel, title: title, subtitle: subtitle, kind: event.kind);
        emit(
          ManageLeagueLoaded(
            fixtures: s.fixtures,
            selectedMatchId: s.selectedMatchId,
            startedMatchIds: s.startedMatchIds,
            snapshot: s.snapshot.copyWith(events: [ev, ...s.snapshot.events]),
            isLiveUpdateMode: s.isLiveUpdateMode,
            isEventsLoading: s.isEventsLoading,
          ),
        );
      },
    );
  }

  Future<void> onMatchEnded({
    required ManageLeagueMatchEnded event,
    required String competitionId,
    required ManageLeagueState currentState,
    required Emitter<ManageLeagueState> emit,
  }) async {
    if (currentState is! ManageLeagueLoaded) return;
    final s = currentState;

    final result = await _endMatch(
      EndManageLeagueMatchParams(
        competitionId: competitionId,
        matchId: event.matchId,
        homeScore: s.snapshot.homeScore,
        awayScore: s.snapshot.awayScore,
      ),
    );

    result.fold(
      (failure) => emit(ManageLeagueError(failure.message)),
      (_) {
        final endedFixtures = s.fixtures.map((f) {
          if (f.matchId != event.matchId) return f;
          final round = _extractRound(f.statusLine);
          final statusLine = round == null
              ? 'Full time • ${s.snapshot.homeScore}-${s.snapshot.awayScore}'
              : 'Full time • ${s.snapshot.homeScore}-${s.snapshot.awayScore} • Round $round';
          return f.copyWith(
            phase: LeagueFixturePhase.finished,
            statusLine: statusLine,
            homeScore: s.snapshot.homeScore,
            awayScore: s.snapshot.awayScore,
          );
        }).toList();

        emit(
          ManageLeagueLoaded(
            fixtures: endedFixtures,
            selectedMatchId: event.matchId,
            startedMatchIds: s.startedMatchIds,
            snapshot: s.snapshot.copyWith(isLive: false, scoringEnabled: false, matchClock: 'FT', matchdayClockLabel: 'FT'),
            isLiveUpdateMode: s.isLiveUpdateMode,
            isEventsLoading: s.isEventsLoading,
          ),
        );
      },
    );
  }

  void onDeleteEvent({
    required ManageLeagueEventDeleted event,
    required ManageLeagueState currentState,
    required Emitter<ManageLeagueState> emit,
  }) {
    if (currentState is! ManageLeagueLoaded || !currentState.snapshot.scoringEnabled) return;
    emit(
      ManageLeagueLoaded(
        fixtures: currentState.fixtures,
        selectedMatchId: currentState.selectedMatchId,
        startedMatchIds: currentState.startedMatchIds,
        snapshot: currentState.snapshot.copyWith(
          events: currentState.snapshot.events.where((e) => e.id != event.eventId).toList(),
        ),
        isLiveUpdateMode: currentState.isLiveUpdateMode,
        isEventsLoading: currentState.isEventsLoading,
      ),
    );
  }

  Future<void> onScheduleUpdated({
    required ManageLeagueScheduleUpdated event,
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
    final result = await _updateMatchSchedule(
      UpdateManageLeagueMatchScheduleParams(
        competitionId: competitionId,
        matchId: event.matchId,
        kickoffAt: event.kickoffAt,
      ),
    );
    result.fold(
      (failure) => emit(ManageLeagueError(failure.message)),
      (_) {
        final nextFixtures = s.fixtures.map((f) {
          if (f.matchId != event.matchId) return f;
          return f.copyWith(
            kickoffAt: event.kickoffAt,
            statusLine: leagueFixtureStatusLine(
              phase: f.phase,
              round: f.matchWeek,
              matchWeek: f.matchWeek,
              kickoffAt: event.kickoffAt,
              matchIndex: 0,
              homeScore: f.homeScore,
              awayScore: f.awayScore,
            ),
          );
        }).toList();
        emit(
          ManageLeagueLoaded(
            fixtures: nextFixtures,
            selectedMatchId: s.selectedMatchId,
            startedMatchIds: s.startedMatchIds,
            snapshot: s.snapshot,
            isLiveUpdateMode: s.isLiveUpdateMode,
            isEventsLoading: s.isEventsLoading,
          ),
        );
      },
    );
  }

  int? _extractRound(String statusLine) {
    final m = RegExp(r'Round\s+(\d+)', caseSensitive: false).firstMatch(statusLine);
    if (m == null) return null;
    return int.tryParse(m.group(1) ?? '');
  }
}


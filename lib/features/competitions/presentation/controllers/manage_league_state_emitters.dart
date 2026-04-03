import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/league_fixture_summary_entity.dart';
import '../../domain/entities/manage_league_snapshot_entity.dart';
import '../../domain/entities/manage_match_event_entity.dart';
import 'manage_league_state.dart';

Future<void> emitLoadedWithDeferredEvents({
  required Emitter<ManageLeagueState> emit,
  required String competitionId,
  required List<LeagueFixtureSummaryEntity> fixtures,
  required String selectedMatchId,
  required Set<String> startedMatchIds,
  required ManageLeagueSnapshotEntity snapshot,
  required bool isLiveUpdateMode,
  required Future<List<ManageMatchEventEntity>> Function({
    required String competitionId,
    required String matchId,
  }) loadEvents,
}) async {
  emit(
    ManageLeagueLoaded(
      fixtures: fixtures,
      selectedMatchId: selectedMatchId,
      startedMatchIds: startedMatchIds,
      snapshot: snapshot.copyWith(events: const []),
      isLiveUpdateMode: isLiveUpdateMode,
      isEventsLoading: true,
    ),
  );

  final events = await loadEvents(
    competitionId: competitionId,
    matchId: selectedMatchId,
  );
  if (emit.isDone) return;

  emit(
    ManageLeagueLoaded(
      fixtures: fixtures,
      selectedMatchId: selectedMatchId,
      startedMatchIds: startedMatchIds,
      snapshot: snapshot.copyWith(events: events),
      isLiveUpdateMode: isLiveUpdateMode,
      isEventsLoading: false,
    ),
  );
}


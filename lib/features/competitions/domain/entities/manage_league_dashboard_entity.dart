import 'package:equatable/equatable.dart';

import 'league_fixture_summary_entity.dart';
import 'manage_league_snapshot_entity.dart';

class ManageLeagueDashboardEntity extends Equatable {
  const ManageLeagueDashboardEntity({
    required this.fixtures,
    required this.selectedMatchId,
    required this.snapshot,
  });

  final List<LeagueFixtureSummaryEntity> fixtures;
  final String selectedMatchId;
  final ManageLeagueSnapshotEntity snapshot;

  @override
  List<Object?> get props => [fixtures, selectedMatchId, snapshot];
}

import 'package:equatable/equatable.dart';

import 'league_fixture_summary_entity.dart';
import 'league_fixtures_cursor_entity.dart';

class LeagueFixturesPageEntity extends Equatable {
  const LeagueFixturesPageEntity({
    required this.fixtures,
    required this.nextCursor,
  });

  final List<LeagueFixtureSummaryEntity> fixtures;
  final LeagueFixturesCursorEntity? nextCursor;

  @override
  List<Object?> get props => [fixtures, nextCursor];
}


import 'package:equatable/equatable.dart';

import '../../domain/entities/league_fixture_summary_entity.dart';
import '../../domain/entities/league_fixtures_cursor_entity.dart';

abstract class LeagueFixturesPaginationState extends Equatable {
  const LeagueFixturesPaginationState();

  @override
  List<Object?> get props => [];
}

class LeagueFixturesPaginationInitial extends LeagueFixturesPaginationState {
  const LeagueFixturesPaginationInitial();
}

class LeagueFixturesPaginationLoading extends LeagueFixturesPaginationState {
  const LeagueFixturesPaginationLoading();
}

class LeagueFixturesPaginationLoaded extends LeagueFixturesPaginationState {
  const LeagueFixturesPaginationLoaded({
    required this.fixtures,
    required this.nextCursor,
    required this.isLoadingMore,
  });

  final List<LeagueFixtureSummaryEntity> fixtures;
  final LeagueFixturesCursorEntity? nextCursor;
  final bool isLoadingMore;

  @override
  List<Object?> get props => [fixtures, nextCursor, isLoadingMore];
}

class LeagueFixturesPaginationError extends LeagueFixturesPaginationState {
  const LeagueFixturesPaginationError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}


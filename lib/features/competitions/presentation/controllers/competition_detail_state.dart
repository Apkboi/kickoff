import 'package:equatable/equatable.dart';

import '../../domain/entities/league_detail_entity.dart';
import '../../domain/entities/standing_row_entity.dart';

abstract class CompetitionDetailState extends Equatable {
  const CompetitionDetailState();

  @override
  List<Object?> get props => [];
}

class CompetitionDetailInitial extends CompetitionDetailState {
  const CompetitionDetailInitial();
}

class CompetitionDetailLoading extends CompetitionDetailState {
  const CompetitionDetailLoading();
}

class CompetitionDetailLoaded extends CompetitionDetailState {
  const CompetitionDetailLoaded({
    required this.detail,
    required this.standings,
  });

  final LeagueDetailEntity detail;
  final List<StandingRowEntity> standings;

  @override
  List<Object?> get props => [detail, standings];
}

class CompetitionDetailError extends CompetitionDetailState {
  const CompetitionDetailError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

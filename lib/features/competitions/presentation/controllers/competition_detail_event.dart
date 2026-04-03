import 'package:equatable/equatable.dart';

import '../../domain/entities/standing_row_entity.dart';

abstract class CompetitionDetailEvent extends Equatable {
  const CompetitionDetailEvent();

  @override
  List<Object?> get props => [];
}

class CompetitionDetailRequested extends CompetitionDetailEvent {
  const CompetitionDetailRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class CompetitionDetailStandingsUpdated extends CompetitionDetailEvent {
  const CompetitionDetailStandingsUpdated(this.rows);

  final List<StandingRowEntity> rows;

  @override
  List<Object?> get props => [rows];
}

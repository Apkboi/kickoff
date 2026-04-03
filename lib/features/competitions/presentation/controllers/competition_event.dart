import 'package:equatable/equatable.dart';

import '../../domain/entities/competition_entity.dart';

abstract class CompetitionEvent extends Equatable {
  const CompetitionEvent();

  @override
  List<Object?> get props => [];
}

class CompetitionsRequested extends CompetitionEvent {
  const CompetitionsRequested();
}

class CompetitionListUpdated extends CompetitionEvent {
  const CompetitionListUpdated(this.competitions);

  final List<CompetitionEntity> competitions;

  @override
  List<Object?> get props => [competitions];
}

class CompetitionWatchFailed extends CompetitionEvent {
  const CompetitionWatchFailed();
}

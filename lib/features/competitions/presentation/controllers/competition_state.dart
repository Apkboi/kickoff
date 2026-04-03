import 'package:equatable/equatable.dart';

import '../../domain/entities/competition_entity.dart';

abstract class CompetitionState extends Equatable {
  const CompetitionState();

  @override
  List<Object?> get props => [];
}

class CompetitionInitial extends CompetitionState {
  const CompetitionInitial();
}

class CompetitionLoading extends CompetitionState {
  const CompetitionLoading();
}

class CompetitionLoaded extends CompetitionState {
  const CompetitionLoaded(this.competitions);

  final List<CompetitionEntity> competitions;

  @override
  List<Object?> get props => [competitions];
}

class CompetitionError extends CompetitionState {
  const CompetitionError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

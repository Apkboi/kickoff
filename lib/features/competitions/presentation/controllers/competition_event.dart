import 'package:equatable/equatable.dart';

abstract class CompetitionEvent extends Equatable {
  const CompetitionEvent();

  @override
  List<Object?> get props => [];
}

class CompetitionsRequested extends CompetitionEvent {
  const CompetitionsRequested();
}

import 'package:equatable/equatable.dart';

import '../../domain/entities/match_prediction_view_entity.dart';

abstract class MatchPredictionState extends Equatable {
  const MatchPredictionState();

  @override
  List<Object?> get props => [];
}

class MatchPredictionInitial extends MatchPredictionState {
  const MatchPredictionInitial();
}

class MatchPredictionLoading extends MatchPredictionState {
  const MatchPredictionLoading();
}

class MatchPredictionReady extends MatchPredictionState {
  const MatchPredictionReady(this.data, {this.actionError});

  final MatchPredictionViewEntity data;
  final String? actionError;

  @override
  List<Object?> get props => [data, actionError];
}

class MatchPredictionError extends MatchPredictionState {
  const MatchPredictionError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';

import '../../domain/entities/live_match_detail_entity.dart';

abstract class MatchDetailState extends Equatable {
  const MatchDetailState();

  @override
  List<Object?> get props => [];
}

class MatchDetailInitial extends MatchDetailState {
  const MatchDetailInitial();
}

class MatchDetailLoading extends MatchDetailState {
  const MatchDetailLoading();
}

class MatchDetailLoaded extends MatchDetailState {
  const MatchDetailLoaded(this.detail);

  final LiveMatchDetailEntity detail;

  @override
  List<Object?> get props => [detail];
}

class MatchDetailError extends MatchDetailState {
  const MatchDetailError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

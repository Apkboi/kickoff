import 'package:equatable/equatable.dart';

import '../../domain/entities/match_prediction_view_entity.dart';

abstract class MatchPredictionEvent extends Equatable {
  const MatchPredictionEvent();

  @override
  List<Object?> get props => [];
}

class MatchPredictionStarted extends MatchPredictionEvent {
  const MatchPredictionStarted({
    required this.leagueId,
    required this.matchId,
    required this.userId,
  });

  final String leagueId;
  final String matchId;
  final String? userId;

  @override
  List<Object?> get props => [leagueId, matchId, userId];
}

class MatchPredictionSubmitted extends MatchPredictionEvent {
  const MatchPredictionSubmitted({
    required this.homePredicted,
    required this.awayPredicted,
  });

  final int homePredicted;
  final int awayPredicted;

  @override
  List<Object?> get props => [homePredicted, awayPredicted];
}

/// Fired from the Firestore panel stream; must not call [Emitter] from the stream callback.
class MatchPredictionStreamData extends MatchPredictionEvent {
  const MatchPredictionStreamData(this.data);

  final MatchPredictionViewEntity data;

  @override
  List<Object?> get props => [data];
}

class MatchPredictionStreamFailed extends MatchPredictionEvent {
  const MatchPredictionStreamFailed();

  @override
  List<Object?> get props => [];
}

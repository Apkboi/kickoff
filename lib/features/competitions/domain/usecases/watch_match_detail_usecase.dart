import 'package:equatable/equatable.dart';

import '../entities/live_match_detail_entity.dart';
import '../repositories/match_detail_repository.dart';

class WatchMatchDetailParams extends Equatable {
  const WatchMatchDetailParams({
    required this.competitionId,
    required this.matchId,
  });

  final String competitionId;
  final String matchId;

  @override
  List<Object?> get props => [competitionId, matchId];
}

class WatchMatchDetailUseCase {
  const WatchMatchDetailUseCase(this._repository);

  final MatchDetailRepository _repository;

  Stream<LiveMatchDetailEntity> call(WatchMatchDetailParams params) {
    return _repository.watchMatch(
      competitionId: params.competitionId,
      matchId: params.matchId,
    );
  }
}

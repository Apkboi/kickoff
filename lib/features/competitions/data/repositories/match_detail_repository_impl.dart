import '../../domain/entities/live_match_detail_entity.dart';
import '../../domain/repositories/match_detail_repository.dart';
import '../datasources/match_detail_stream_datasource.dart';

class MatchDetailRepositoryImpl implements MatchDetailRepository {
  const MatchDetailRepositoryImpl(this._source);

  final MatchDetailStreamDataSource _source;

  @override
  Stream<LiveMatchDetailEntity> watchMatch({
    required String competitionId,
    required String matchId,
  }) {
    return _source.watchMatch(competitionId: competitionId, matchId: matchId);
  }
}

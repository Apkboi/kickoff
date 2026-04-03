import '../entities/live_match_detail_entity.dart';

abstract class MatchDetailRepository {
  Stream<LiveMatchDetailEntity> watchMatch({
    required String competitionId,
    required String matchId,
  });
}

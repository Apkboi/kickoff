import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/league_firestore_fields.dart';
import '../../../../core/constants/prediction_firestore_fields.dart';
import '../../../../core/constants/user_firestore_fields.dart';
import '../../domain/entities/match_prediction_view_entity.dart';

/// Closes 3 minutes before kickoff.
abstract final class MatchPredictionMapper {
  static const predictionCloseLead = Duration(minutes: 3);
  static const pointsPerCorrect = 3;

  static List<PredictionLeaderboardEntryEntity> leaderboardFromDocs(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final board = <PredictionLeaderboardEntryEntity>[];
    for (var i = 0; i < docs.length; i++) {
      final d = docs[i];
      final data = d.data();
      board.add(
        PredictionLeaderboardEntryEntity(
          rank: i + 1,
          userId: d.id,
          displayName: (data[UserFirestoreFields.displayName] as String?)?.trim().isNotEmpty == true
              ? data[UserFirestoreFields.displayName] as String
              : 'Player',
          totalPoints: (data[PredictionFirestoreFields.totalPoints] as num?)?.toInt() ?? 0,
          photoUrl: (data[UserFirestoreFields.photoUrl] as String?)?.trim().isNotEmpty == true
              ? data[UserFirestoreFields.photoUrl] as String
              : null,
        ),
      );
    }
    return board;
  }

  static MatchPredictionViewEntity build({
    required String leagueId,
    required String matchId,
    required String? userId,
    required Map<String, dynamic> fixtureData,
    required Map<String, dynamic>? predictionData,
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> leaderboardDocs,
  }) {
    final status = fixtureData[LeagueFirestoreFields.status] as String? ?? 'scheduled';
    final kickoffAt = (fixtureData[LeagueFirestoreFields.kickoffAt] as Timestamp?)?.toDate();
    final homeScore = (fixtureData[LeagueFirestoreFields.homeScore] as num?)?.toInt() ?? 0;
    final awayScore = (fixtureData[LeagueFirestoreFields.awayScore] as num?)?.toInt() ?? 0;

    final isFinished = status == 'finished' || status == 'ft';
    final isLive = status == 'live';
    DateTime? closesAt;
    var open = false;
    if (kickoffAt != null && !isLive && !isFinished) {
      closesAt = kickoffAt.subtract(predictionCloseLead);
      open = DateTime.now().isBefore(closesAt);
    }

    UserPredictionEntity? pred;
    if (predictionData != null) {
      pred = UserPredictionEntity(
        homePredicted: (predictionData[PredictionFirestoreFields.homePredicted] as num?)?.toInt() ?? 0,
        awayPredicted: (predictionData[PredictionFirestoreFields.awayPredicted] as num?)?.toInt() ?? 0,
        pointsAwarded: (predictionData[PredictionFirestoreFields.pointsAwarded] as num?)?.toInt() ?? 0,
      );
    }

    final board = leaderboardFromDocs(leaderboardDocs);

    return MatchPredictionViewEntity(
      leagueId: leagueId,
      matchId: matchId,
      matchStatusRaw: status,
      kickoffAt: kickoffAt,
      isPredictionWindowOpen: open,
      predictionClosesAt: closesAt,
      finalHomeScore: homeScore,
      finalAwayScore: awayScore,
      userPrediction: pred,
      leaderboard: board,
      isSignedIn: userId != null,
      userId: userId,
    );
  }
}

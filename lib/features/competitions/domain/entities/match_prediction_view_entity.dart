import 'package:equatable/equatable.dart';

class UserPredictionEntity extends Equatable {
  const UserPredictionEntity({
    required this.homePredicted,
    required this.awayPredicted,
    required this.pointsAwarded,
  });

  final int homePredicted;
  final int awayPredicted;
  final int pointsAwarded;

  @override
  List<Object?> get props => [homePredicted, awayPredicted, pointsAwarded];
}

class PredictionLeaderboardEntryEntity extends Equatable {
  const PredictionLeaderboardEntryEntity({
    required this.rank,
    required this.userId,
    required this.displayName,
    required this.totalPoints,
    this.photoUrl,
  });

  final int rank;
  final String userId;
  final String displayName;
  final int totalPoints;
  final String? photoUrl;

  @override
  List<Object?> get props => [rank, userId, displayName, totalPoints, photoUrl];
}

/// Combined state for match prediction panel + leaderboard.
class MatchPredictionViewEntity extends Equatable {
  const MatchPredictionViewEntity({
    required this.leagueId,
    required this.matchId,
    required this.matchStatusRaw,
    required this.kickoffAt,
    required this.isPredictionWindowOpen,
    required this.predictionClosesAt,
    required this.finalHomeScore,
    required this.finalAwayScore,
    required this.userPrediction,
    required this.leaderboard,
    required this.isSignedIn,
    this.userId,
  });

  final String leagueId;
  final String matchId;
  final String matchStatusRaw;
  final DateTime? kickoffAt;
  final bool isPredictionWindowOpen;
  final DateTime? predictionClosesAt;
  final int finalHomeScore;
  final int finalAwayScore;
  final UserPredictionEntity? userPrediction;
  final List<PredictionLeaderboardEntryEntity> leaderboard;
  final bool isSignedIn;
  final String? userId;

  MatchPredictionViewEntity copyWith({
    UserPredictionEntity? userPrediction,
  }) {
    return MatchPredictionViewEntity(
      leagueId: leagueId,
      matchId: matchId,
      matchStatusRaw: matchStatusRaw,
      kickoffAt: kickoffAt,
      isPredictionWindowOpen: isPredictionWindowOpen,
      predictionClosesAt: predictionClosesAt,
      finalHomeScore: finalHomeScore,
      finalAwayScore: finalAwayScore,
      userPrediction: userPrediction ?? this.userPrediction,
      leaderboard: leaderboard,
      isSignedIn: isSignedIn,
      userId: userId,
    );
  }

  @override
  List<Object?> get props => [
        leagueId,
        matchId,
        matchStatusRaw,
        kickoffAt,
        isPredictionWindowOpen,
        predictionClosesAt,
        finalHomeScore,
        finalAwayScore,
        userPrediction,
        leaderboard,
        isSignedIn,
        userId,
      ];
}

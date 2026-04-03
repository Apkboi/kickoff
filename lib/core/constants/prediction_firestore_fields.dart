/// Fields under `fixtures/{id}/predictions/{userId}` and `predictionScores/{userId}`.
abstract final class PredictionFirestoreFields {
  static const homePredicted = 'homePredicted';
  static const awayPredicted = 'awayPredicted';
  static const pointsAwarded = 'pointsAwarded';
  static const createdAt = 'createdAt';

  /// Cumulative points for this league (`leagues/{id}/predictionScores/{userId}`).
  static const totalPoints = 'totalPoints';
}

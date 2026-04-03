abstract final class FirestoreCollections {
  static const String users = 'users';

  /// Public leagues shown on Explore.
  static const String leagues = 'leagues';

  /// League subcollections.
  static const String fixtures = 'fixtures';
  static const String members = 'members';
  static const String standings = 'standings';
  static const String events = 'events';

  /// Per-fixture score predictions (`fixtures/{id}/predictions/{userId}`).
  static const String predictions = 'predictions';

  /// League prediction leaderboard (`leagues/{id}/predictionScores/{userId}`).
  static const String predictionScores = 'predictionScores';
}

/// Firebase Storage object paths (not Firestore).
abstract final class FirebaseStoragePaths {
  /// Draft league images before a league document exists.
  static String leagueDraft(String userId, String kindLabel, int millis) {
    return 'users/$userId/league_drafts/${kindLabel}_$millis.jpg';
  }

  static String profileAvatar(String userId) => 'users/$userId/avatar.jpg';
}

import 'entities/league_detail_entity.dart';

extension LeagueDetailAdminX on LeagueDetailEntity {
  /// Whether [userId] may manage this league (Firestore UIDs in [adminUserIds], or `*` in mock).
  bool isViewerAdmin({required String? userId, required bool authenticated}) {
    if (!authenticated || userId == null || userId.isEmpty) return false;
    if (adminUserIds.contains('*')) return true;
    final creator = creatorUserId;
    if (creator != null && creator.isNotEmpty && creator == userId) return true;
    return adminUserIds.contains(userId);
  }
}

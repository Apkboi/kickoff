import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/league_firestore_fields.dart';
import '../../domain/entities/home_live_match_entity.dart';
import '../../domain/entities/home_trending_league_entity.dart';

/// Shared mappers for Firestore fixture / league docs (used by realtime streams).
///
/// **Indexes** (Firebase console): collection group `fixtures` — `status`; `kickoffAt`.
abstract final class HomeFeedFirestoreLoader {
  static List<HomeLiveMatchEntity> mapLiveFixtureDocs(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    Map<String, String> leagueNames, {
    Map<String, String?> leagueBanners = const {},
  }) {
    final now = DateTime.now();
    final list = <HomeLiveMatchEntity>[];
    for (final doc in docs) {
      final leagueId = doc.reference.parent.parent?.id;
      if (leagueId == null) continue;
      final data = doc.data();
      final home = (data[LeagueFirestoreFields.homeName] as String?) ?? 'Home';
      final away = (data[LeagueFirestoreFields.awayName] as String?) ?? 'Away';
      final homeScore = (data[LeagueFirestoreFields.homeScore] as num?)?.toInt() ?? 0;
      final awayScore = (data[LeagueFirestoreFields.awayScore] as num?)?.toInt() ?? 0;
      final startedAt = (data[LeagueFirestoreFields.startedAt] as Timestamp?)?.toDate();
      final minute = startedAt != null
          ? now.difference(startedAt).inMinutes.clamp(0, 120)
          : 1;
      final progress = (minute / 90.0).clamp(0.0, 1.0);
      final banner = leagueBanners[leagueId];
      list.add(
        HomeLiveMatchEntity(
          leagueId: leagueId,
          leagueName: leagueNames[leagueId] ?? 'League',
          leagueBannerUrl: banner != null && banner.isNotEmpty ? banner : null,
          matchId: doc.id,
          homeName: home,
          awayName: away,
          homeScore: homeScore,
          awayScore: awayScore,
          elapsedMinute: minute,
          progress: progress,
        ),
      );
    }
    return list;
  }

  static List<HomeTrendingLeagueEntity> mapTrendingFromPublishedDocs(
    List<DocumentSnapshot<Map<String, dynamic>>> published,
  ) {
    return published.take(8).map((d) {
      final data = d.data() ?? {};
      final sport = (data[LeagueFirestoreFields.sport] as String? ?? 'Football').toUpperCase();
      final participantCount = (data[LeagueFirestoreFields.participantCount] as num?)?.toInt() ?? 0;
      final maxP = (data[LeagueFirestoreFields.maxParticipants] as num?)?.toInt() ?? 32;
      final name = data[LeagueFirestoreFields.name] as String? ?? 'League';
      return HomeTrendingLeagueEntity(
        id: d.id,
        name: name,
        sportLabel: sport.length > 14 ? sport.substring(0, 14) : sport,
        participantCount: participantCount,
        maxParticipants: maxP,
      );
    }).toList();
  }
}

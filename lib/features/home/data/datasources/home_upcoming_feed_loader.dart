import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/constants/league_firestore_fields.dart';
import '../../domain/entities/home_upcoming_fixture_entity.dart';
import 'home_feed_merge_names.dart';

abstract final class HomeUpcomingFeedLoader {
  static List<HomeUpcomingFixtureEntity> mapUpcomingFixtureDocs(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    Map<String, String> leagueNames, {
    Map<String, String?> leagueBanners = const {},
  }) {
    final list = <HomeUpcomingFixtureEntity>[];
    for (final doc in docs) {
      final leagueId = doc.reference.parent.parent?.id;
      if (leagueId == null) continue;
      final data = doc.data();
      final status = data[LeagueFirestoreFields.status] as String?;
      if (status == 'finished' || status == 'ft') continue;
      final kickoff = (data[LeagueFirestoreFields.kickoffAt] as Timestamp?)?.toDate();
      if (kickoff == null) continue;
      final home = (data[LeagueFirestoreFields.homeName] as String?) ?? 'Home';
      final away = (data[LeagueFirestoreFields.awayName] as String?) ?? 'Away';
      final banner = leagueBanners[leagueId];
      list.add(
        HomeUpcomingFixtureEntity(
          leagueId: leagueId,
          leagueName: leagueNames[leagueId] ?? 'League',
          leagueBannerUrl: banner != null && banner.isNotEmpty ? banner : null,
          matchId: doc.id,
          homeName: home,
          awayName: away,
          kickoffAt: kickoff,
        ),
      );
      if (list.length >= 12) break;
    }
    return list;
  }

  static Future<List<HomeUpcomingFixtureEntity>> load(
    FirebaseFirestore firestore,
    List<DocumentSnapshot<Map<String, dynamic>>> published,
    Map<String, String> leagueNames,
  ) async {
    final now = DateTime.now();
    try {
      final snap = await firestore
          .collectionGroup(FirestoreCollections.fixtures)
          .where(
            LeagueFirestoreFields.kickoffAt,
            isGreaterThan: Timestamp.fromDate(now),
          )
          .orderBy(LeagueFirestoreFields.kickoffAt)
          .limit(40)
          .get();
      await mergeMissingLeagueNames(
        firestore,
        leagueNames,
        snap.docs.map((d) => d.reference.parent.parent!.id),
      );
      return mapUpcomingFixtureDocs(snap.docs, leagueNames);
    } catch (_) {
      return _fallback(firestore, published, leagueNames, now);
    }
  }

  static Future<List<HomeUpcomingFixtureEntity>> _fallback(
    FirebaseFirestore firestore,
    List<DocumentSnapshot<Map<String, dynamic>>> published,
    Map<String, String> leagueNames,
    DateTime now,
  ) async {
    final all = <HomeUpcomingFixtureEntity>[];
    for (final leagueDoc in published.take(15)) {
      try {
        final snap = await leagueDoc.reference
            .collection(FirestoreCollections.fixtures)
            .orderBy(LeagueFirestoreFields.kickoffAt)
            .limit(20)
            .get();
        for (final doc in snap.docs) {
          final data = doc.data();
          final kickoff = (data[LeagueFirestoreFields.kickoffAt] as Timestamp?)?.toDate();
          if (kickoff == null || !kickoff.isAfter(now)) continue;
          final status = data[LeagueFirestoreFields.status] as String?;
          if (status == 'finished' || status == 'ft') continue;
          final home = (data[LeagueFirestoreFields.homeName] as String?) ?? 'Home';
          final away = (data[LeagueFirestoreFields.awayName] as String?) ?? 'Away';
          all.add(
            HomeUpcomingFixtureEntity(
              leagueId: leagueDoc.id,
              leagueName: leagueNames[leagueDoc.id] ?? 'League',
              matchId: doc.id,
              homeName: home,
              awayName: away,
              kickoffAt: kickoff,
            ),
          );
        }
      } catch (_) {}
    }
    all.sort((a, b) => a.kickoffAt.compareTo(b.kickoffAt));
    return all.take(12).toList();
  }
}

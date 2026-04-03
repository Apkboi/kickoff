import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/constants/league_firestore_fields.dart';
import '../../domain/entities/home_live_match_entity.dart';
import '../../domain/entities/home_upcoming_fixture_entity.dart';
import 'home_feed_firestore_loader.dart';
import 'home_upcoming_feed_loader.dart';

/// Realtime feeds using per-league `fixtures` subcollections only (no collection group indexes).
abstract final class HomeFeedPerLeagueRealtime {
  static Stream<List<HomeLiveMatchEntity>> watchLiveMatches(FirebaseFirestore firestore) {
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? leagueSub;
    final fixtureSubs = <String, StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>{};
    final latestSnaps = <String, QuerySnapshot<Map<String, dynamic>>>{};
    final leagueNames = <String, String>{};
    final leagueBannerUrls = <String, String?>{};

    late final StreamController<List<HomeLiveMatchEntity>> controller;

    void emit() {
      final allDocs = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
      for (final snap in latestSnaps.values) {
        allDocs.addAll(snap.docs);
      }
      controller.add(
        HomeFeedFirestoreLoader.mapLiveFixtureDocs(
          allDocs,
          leagueNames,
          leagueBanners: leagueBannerUrls,
        ),
      );
    }

    controller = StreamController<List<HomeLiveMatchEntity>>(
      onCancel: () async {
        await leagueSub?.cancel();
        for (final s in fixtureSubs.values) {
          await s.cancel();
        }
        fixtureSubs.clear();
        latestSnaps.clear();
        leagueNames.clear();
        leagueBannerUrls.clear();
      },
    );

    leagueSub = firestore
        .collection(FirestoreCollections.leagues)
        .limit(100)
        .snapshots()
        .listen((leagueSnap) {
      final published = leagueSnap.docs
          .where((d) => d.data()[LeagueFirestoreFields.published] == true)
          .toList();
      final ids = published.map((d) => d.id).toSet();
      for (final key in fixtureSubs.keys.toList()) {
        if (!ids.contains(key)) {
          fixtureSubs.remove(key)?.cancel();
          latestSnaps.remove(key);
          leagueNames.remove(key);
          leagueBannerUrls.remove(key);
        }
      }
      for (final d in published) {
        leagueNames[d.id] = d.data()[LeagueFirestoreFields.name] as String? ?? 'League';
        final rawBanner = (d.data()[LeagueFirestoreFields.bannerUrl] as String?)?.trim();
        leagueBannerUrls[d.id] = rawBanner != null && rawBanner.isNotEmpty ? rawBanner : null;
        if (fixtureSubs.containsKey(d.id)) continue;
        fixtureSubs[d.id] = d.reference
            .collection(FirestoreCollections.fixtures)
            .where(LeagueFirestoreFields.status, isEqualTo: 'live')
            .limit(10)
            .snapshots()
            .listen((snap) {
          latestSnaps[d.id] = snap;
          emit();
        });
      }
      emit();
    });

    return controller.stream;
  }

  static Stream<List<HomeUpcomingFixtureEntity>> watchUpcomingMatches(FirebaseFirestore firestore) {
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? leagueSub;
    final fixtureSubs = <String, StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>{};
    final latestSnaps = <String, QuerySnapshot<Map<String, dynamic>>>{};
    final leagueNames = <String, String>{};
    final leagueBannerUrls = <String, String?>{};

    late final StreamController<List<HomeUpcomingFixtureEntity>> controller;

    void emit() {
      final now = DateTime.now();
      final allDocs = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
      for (final snap in latestSnaps.values) {
        allDocs.addAll(
          snap.docs.where((doc) {
            final ko = (doc.data()[LeagueFirestoreFields.kickoffAt] as Timestamp?)?.toDate();
            if (ko == null || !ko.isAfter(now)) return false;
            final st = doc.data()[LeagueFirestoreFields.status] as String?;
            return st != 'finished' && st != 'ft';
          }),
        );
      }
      allDocs.sort((a, b) {
        final ka = (a.data()[LeagueFirestoreFields.kickoffAt] as Timestamp?)?.toDate();
        final kb = (b.data()[LeagueFirestoreFields.kickoffAt] as Timestamp?)?.toDate();
        if (ka == null || kb == null) return 0;
        return ka.compareTo(kb);
      });
      final top = allDocs.take(12).toList();
      controller.add(
        HomeUpcomingFeedLoader.mapUpcomingFixtureDocs(
          top,
          leagueNames,
          leagueBanners: leagueBannerUrls,
        ),
      );
    }

    controller = StreamController<List<HomeUpcomingFixtureEntity>>(
      onCancel: () async {
        await leagueSub?.cancel();
        for (final s in fixtureSubs.values) {
          await s.cancel();
        }
        fixtureSubs.clear();
        latestSnaps.clear();
        leagueNames.clear();
        leagueBannerUrls.clear();
      },
    );

    leagueSub = firestore
        .collection(FirestoreCollections.leagues)
        .limit(100)
        .snapshots()
        .listen((leagueSnap) {
      final published = leagueSnap.docs
          .where((d) => d.data()[LeagueFirestoreFields.published] == true)
          .toList();
      final ids = published.map((d) => d.id).toSet();
      for (final key in fixtureSubs.keys.toList()) {
        if (!ids.contains(key)) {
          fixtureSubs.remove(key)?.cancel();
          latestSnaps.remove(key);
          leagueNames.remove(key);
          leagueBannerUrls.remove(key);
        }
      }
      for (final d in published) {
        leagueNames[d.id] = d.data()[LeagueFirestoreFields.name] as String? ?? 'League';
        final rawBanner = (d.data()[LeagueFirestoreFields.bannerUrl] as String?)?.trim();
        leagueBannerUrls[d.id] = rawBanner != null && rawBanner.isNotEmpty ? rawBanner : null;
        if (fixtureSubs.containsKey(d.id)) continue;
        fixtureSubs[d.id] = d.reference
            .collection(FirestoreCollections.fixtures)
            .orderBy(LeagueFirestoreFields.kickoffAt)
            .limit(40)
            .snapshots()
            .listen((snap) {
          latestSnaps[d.id] = snap;
          emit();
        });
      }
      emit();
    });

    return controller.stream;
  }
}

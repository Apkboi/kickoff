import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/constants/league_firestore_fields.dart';
import '../../domain/entities/manage_league_dashboard_entity.dart';
import '../../domain/entities/league_fixture_summary_entity.dart';
import '../utils/league_fixture_firestore_mapper.dart';
import '../utils/manage_league_snapshot_builder.dart';

Future<ManageLeagueDashboardEntity> getManageLeagueDashboardFromFirestore({
  required FirebaseFirestore firestore,
  required String competitionId,
}) async {
  final leagueRef = firestore.collection(FirestoreCollections.leagues).doc(competitionId);
  final leagueSnap = await leagueRef.get();
  final leagueName = (leagueSnap.data() ?? {})[LeagueFirestoreFields.name] as String? ?? 'League';

  const fixturesScanLimit = 48;
  final scanSnap = await leagueRef
      .collection('fixtures')
      .orderBy(LeagueFirestoreFields.matchIndex)
      .limit(fixturesScanLimit)
      .get();
  final scanDocs = scanSnap.docs;
  if (scanDocs.isEmpty) {
    return ManageLeagueDashboardEntity(
      fixtures: const [],
      selectedMatchId: '',
      snapshot: emptyManageLeagueSnapshot(competitionId: competitionId, leagueName: leagueName),
    );
  }

  final fixtures = scanDocs.map(leagueFixtureSummaryFromFirestoreDoc).toList();
  fixtures.sort((a, b) {
    final ad = a.kickoffAt;
    final bd = b.kickoffAt;
    if (ad != null && bd != null) return ad.compareTo(bd);
    if (ad == null && bd == null) return a.matchId.compareTo(b.matchId);
    if (ad == null) return 1;
    return -1;
  });

  final selected = fixtures.firstWhere(
    (f) => f.phase == LeagueFixturePhase.live,
    orElse: () => fixtures.first,
  );
  final selectedFromList = fixtures.firstWhere(
    (f) => f.matchId == selected.matchId,
    orElse: () => fixtures.first,
  );
  final snapshot = buildManageLeagueSnapshotFromFixture(
    competitionId: competitionId,
    leagueName: leagueName,
    fixture: selectedFromList,
    startedMatchIds: const {},
  );
  return ManageLeagueDashboardEntity(
    fixtures: fixtures,
    selectedMatchId: selectedFromList.matchId,
    snapshot: snapshot,
  );
}

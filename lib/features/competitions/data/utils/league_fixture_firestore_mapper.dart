import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/league_firestore_fields.dart';
import '../../domain/entities/league_fixture_summary_entity.dart';

LeagueFixturePhase leagueFixturePhaseFromStatus(String? status) {
  switch (status) {
    case 'live':
      return LeagueFixturePhase.live;
    case 'finished':
    case 'ft':
      return LeagueFixturePhase.finished;
    default:
      return LeagueFixturePhase.scheduled;
  }
}

String leagueFixtureStatusLine({
  required LeagueFixturePhase phase,
  required int round,
  required int matchWeek,
  required DateTime? kickoffAt,
  required int matchIndex,
  required int homeScore,
  required int awayScore,
}) {
  final week = 'Week $matchWeek';
  // Kickoff / clock strings omitted — not keeping accurate match times on clients yet.
  switch (phase) {
    case LeagueFixturePhase.live:
      return 'Live • $week';
    case LeagueFixturePhase.finished:
      return 'Full time • $homeScore-$awayScore • $week';
    case LeagueFixturePhase.scheduled:
      return 'Scheduled • $week';
  }
}

LeagueFixtureSummaryEntity leagueFixtureSummaryFromFirestoreDoc(
  DocumentSnapshot<Map<String, dynamic>> doc,
) {
  final data = doc.data() ?? {};
  final home = (data[LeagueFirestoreFields.homeName] as String?) ?? 'Home';
  final away = (data[LeagueFirestoreFields.awayName] as String?) ?? 'Away';
  final round = (data[LeagueFirestoreFields.round] as num?)?.toInt() ?? 1;
  final matchWeek = (data[LeagueFirestoreFields.matchWeek] as num?)?.toInt() ?? round;
  final matchIndex = (data[LeagueFirestoreFields.matchIndex] as num?)?.toInt() ?? 0;
  final status = data[LeagueFirestoreFields.status] as String?;
  final phase = leagueFixturePhaseFromStatus(status);
  final kickoffAt = (data[LeagueFirestoreFields.kickoffAt] as Timestamp?)?.toDate();
  final homeScore = (data[LeagueFirestoreFields.homeScore] as num?)?.toInt() ?? 0;
  final awayScore = (data[LeagueFirestoreFields.awayScore] as num?)?.toInt() ?? 0;
  final headline = '$home vs $away'.toUpperCase();
  final statusLine = leagueFixtureStatusLine(
    phase: phase,
    round: round,
    matchWeek: matchWeek,
    kickoffAt: kickoffAt,
    matchIndex: matchIndex,
    homeScore: homeScore,
    awayScore: awayScore,
  );
  final homeId = data[LeagueFirestoreFields.homeId] as String?;
  final awayId = data[LeagueFirestoreFields.awayId] as String?;

  return LeagueFixtureSummaryEntity(
    matchId: doc.id,
    headline: headline,
    statusLine: statusLine,
    phase: phase,
    matchWeek: matchWeek,
    kickoffAt: kickoffAt,
    homeScore: homeScore,
    awayScore: awayScore,
    homeId: homeId,
    awayId: awayId,
  );
}

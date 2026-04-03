import 'dart:math';

import '../../domain/entities/league_fixture_summary_entity.dart';
import '../../domain/entities/manage_league_snapshot_entity.dart';

bool manageLeagueScoringEnabled(
  LeagueFixtureSummaryEntity fixture,
  Set<String> startedMatchIds,
) {
  if (fixture.phase == LeagueFixturePhase.live) return true;
  if (fixture.phase == LeagueFixturePhase.scheduled && startedMatchIds.contains(fixture.matchId)) {
    return true;
  }
  return false;
}

ManageLeagueSnapshotEntity emptyManageLeagueSnapshot({
  required String competitionId,
  required String leagueName,
}) {
  return ManageLeagueSnapshotEntity(
    competitionId: competitionId,
    leagueName: leagueName,
    matchTitle: 'No fixtures',
    matchdayClockLabel: '',
    isLive: false,
    homeTeamName: '',
    homeTeamShort: '',
    awayTeamName: '',
    awayTeamShort: '',
    homeScore: 0,
    awayScore: 0,
    matchClock: '—',
    events: const [],
    scoringEnabled: false,
    homePhotoUrl: null,
    awayPhotoUrl: null,
  );
}

ManageLeagueSnapshotEntity buildManageLeagueSnapshotFromFixture({
  required String competitionId,
  required String leagueName,
  required LeagueFixtureSummaryEntity fixture,
  required Set<String> startedMatchIds,
}) {
  final scoringEnabled = manageLeagueScoringEnabled(fixture, startedMatchIds);
  final (home, away) = _splitHeadline(fixture.headline);
  final matchTitle = '${_titleCase(home)} vs ${_titleCase(away)}';
  final roundLabel = _roundFromStatusLine(fixture.statusLine);
  final isFinished = fixture.phase == LeagueFixturePhase.finished;
  final isLive = fixture.phase == LeagueFixturePhase.live ||
      (fixture.phase == LeagueFixturePhase.scheduled && startedMatchIds.contains(fixture.matchId));

  return ManageLeagueSnapshotEntity(
    competitionId: competitionId,
    leagueName: leagueName,
    matchTitle: matchTitle,
    matchdayClockLabel: isFinished
        ? '$roundLabel • Full time'
        : scoringEnabled
            ? '$roundLabel • Live'
            : '$roundLabel • Scheduled',
    isLive: isLive,
    homeTeamName: _titleCase(home),
    homeTeamShort: _shortName(home),
    awayTeamName: _titleCase(away),
    awayTeamShort: _shortName(away),
    homeScore: fixture.homeScore,
    awayScore: fixture.awayScore,
    matchClock: '—',
    scoringEnabled: scoringEnabled,
    events: const [],
    homePhotoUrl: null,
    awayPhotoUrl: null,
  );
}

(String, String) _splitHeadline(String headline) {
  final parts = headline.split(RegExp(r'\s+vs\s+', caseSensitive: false));
  if (parts.length >= 2) {
    return (parts[0].trim(), parts[1].trim());
  }
  return ('Home', 'Away');
}

String _titleCase(String raw) {
  final t = raw.trim();
  if (t.isEmpty) return raw;
  return t.split(RegExp(r'\s+')).map((w) {
    if (w.isEmpty) return w;
    return w[0].toUpperCase() + w.substring(1).toLowerCase();
  }).join(' ');
}

String _shortName(String raw) {
  final t = raw.trim();
  if (t.isEmpty) return '—';
  final cap = t.toUpperCase();
  return cap.length <= 4 ? cap : cap.substring(0, min(4, cap.length));
}

String _roundFromStatusLine(String statusLine) {
  final m = RegExp(r'Round\s+(\d+)', caseSensitive: false).firstMatch(statusLine);
  if (m != null) return 'Matchday ${m.group(1)}';
  return 'Matchday';
}

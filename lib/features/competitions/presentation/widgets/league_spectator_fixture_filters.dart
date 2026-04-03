import '../../domain/entities/league_fixture_summary_entity.dart';

enum LeagueSpectatorResultFilter {
  all,
  upcomingAndLive,
  finished,
}

extension LeagueSpectatorResultFilterX on LeagueSpectatorResultFilter {
  String get label => switch (this) {
        LeagueSpectatorResultFilter.all => 'All matches',
        LeagueSpectatorResultFilter.upcomingAndLive => 'Upcoming & live',
        LeagueSpectatorResultFilter.finished => 'Results',
      };
}

/// Local calendar date at midnight (no time component) from fixture kickoff.
DateTime? kickoffCalendarDateLocal(LeagueFixtureSummaryEntity f) {
  final k = f.kickoffAt;
  if (k == null) return null;
  final l = k.toLocal();
  return DateTime(l.year, l.month, l.day);
}

List<DateTime> distinctSortedKickoffDates(List<LeagueFixtureSummaryEntity> all) {
  final set = <DateTime>{};
  for (final f in all) {
    final d = kickoffCalendarDateLocal(f);
    if (d != null) set.add(d);
  }
  final list = set.toList()..sort();
  return list;
}

List<LeagueFixtureSummaryEntity> applyLeagueSpectatorFilters({
  required List<LeagueFixtureSummaryEntity> all,
  required DateTime? dateFilter,
  required LeagueSpectatorResultFilter resultFilter,
}) {
  var list = List<LeagueFixtureSummaryEntity>.from(all);
  if (dateFilter != null) {
    list = list.where((f) {
      final d = kickoffCalendarDateLocal(f);
      return d == dateFilter;
    }).toList();
  }
  switch (resultFilter) {
    case LeagueSpectatorResultFilter.all:
      break;
    case LeagueSpectatorResultFilter.upcomingAndLive:
      list = list.where((f) => f.phase != LeagueFixturePhase.finished).toList();
      break;
    case LeagueSpectatorResultFilter.finished:
      list = list.where((f) => f.phase == LeagueFixturePhase.finished).toList();
      break;
  }
  list.sort((a, b) {
    final ka = a.kickoffAt;
    final kb = b.kickoffAt;
    if (ka == null && kb == null) return a.matchId.compareTo(b.matchId);
    if (ka == null) return 1;
    if (kb == null) return -1;
    return ka.compareTo(kb);
  });
  return list;
}

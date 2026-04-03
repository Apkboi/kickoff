import '../entities/explore_filters.dart';
import '../entities/explore_league_card_entity.dart';
import '../entities/explore_sort.dart';

List<ExploreLeagueCardEntity> applyExploreFilters({
  required List<ExploreLeagueCardEntity> source,
  required ExploreFilters filters,
  required String searchQuery,
  required ExploreSort sort,
}) {
  var list = source.where((e) {
    final m = e.filterMeta;
    if (filters.sports.isNotEmpty && !filters.sports.contains(m.sport)) {
      return false;
    }
    final anyFormat = filters.standardLeague || filters.tournament || filters.knockout;
    if (anyFormat) {
      final matches = (filters.standardLeague && m.standardLeague) ||
          (filters.tournament && m.tournament) ||
          (filters.knockout && m.knockout);
      if (!matches) return false;
    }
    if (filters.registrationOpen && !m.registrationOpen) return false;
    if (filters.liveNow && !m.liveNow) return false;
    if (filters.startingSoon && !m.startingSoon) return false;
    if (m.entryFeeUsd < filters.entryFeeRange.min || m.entryFeeUsd > filters.entryFeeRange.max) {
      return false;
    }
    if (filters.locationQuery.trim().isNotEmpty) {
      final q = filters.locationQuery.toLowerCase();
      if (!e.location.toLowerCase().contains(q)) return false;
    }
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      if (!e.title.toLowerCase().contains(q) && !e.location.toLowerCase().contains(q)) {
        return false;
      }
    }
    return true;
  }).toList();

  switch (sort) {
    case ExploreSort.popularity:
      break;
    case ExploreSort.newest:
      list = List.of(list.reversed);
  }
  return list;
}

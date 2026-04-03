import 'package:equatable/equatable.dart';

import '../../domain/entities/explore_feed_entity.dart';
import '../../domain/entities/explore_filters.dart';
import '../../domain/entities/explore_league_card_entity.dart';
import '../../domain/entities/explore_sort.dart';
import '../../domain/utils/apply_explore_filters.dart';

abstract class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object?> get props => [];
}

class ExploreInitial extends ExploreState {
  const ExploreInitial();
}

class ExploreLoading extends ExploreState {
  const ExploreLoading();
}

class ExploreLoaded extends ExploreState {
  const ExploreLoaded({
    required this.feed,
    required this.filters,
    required this.searchQuery,
    required this.sort,
  });

  final ExploreFeedEntity feed;
  final ExploreFilters filters;
  final String searchQuery;
  final ExploreSort sort;

  List<ExploreLeagueCardEntity> get filteredGrid {
    return applyExploreFilters(
      source: feed.gridLeagues,
      filters: filters,
      searchQuery: searchQuery,
      sort: sort,
    );
  }

  ExploreLoaded copyWith({
    ExploreFeedEntity? feed,
    ExploreFilters? filters,
    String? searchQuery,
    ExploreSort? sort,
  }) {
    return ExploreLoaded(
      feed: feed ?? this.feed,
      filters: filters ?? this.filters,
      searchQuery: searchQuery ?? this.searchQuery,
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props => [feed, filters, searchQuery, sort];
}

class ExploreError extends ExploreState {
  const ExploreError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

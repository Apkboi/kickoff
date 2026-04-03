import 'package:equatable/equatable.dart';

import '../../domain/entities/explore_filters.dart';
import '../../domain/entities/explore_sort.dart';

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();

  @override
  List<Object?> get props => [];
}

class ExploreStarted extends ExploreEvent {
  const ExploreStarted();
}

class ExploreSearchChanged extends ExploreEvent {
  const ExploreSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class ExploreFiltersChanged extends ExploreEvent {
  const ExploreFiltersChanged(this.filters);

  final ExploreFilters filters;

  @override
  List<Object?> get props => [filters];
}

class ExploreSortChanged extends ExploreEvent {
  const ExploreSortChanged(this.sort);

  final ExploreSort sort;

  @override
  List<Object?> get props => [sort];
}

class ExploreFiltersReset extends ExploreEvent {
  const ExploreFiltersReset();
}

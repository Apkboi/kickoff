import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/explore_feed_entity.dart';
import '../../domain/entities/explore_filters.dart';
import '../../domain/entities/explore_sort.dart';
import '../../domain/repositories/explore_repository.dart';
import 'explore_event.dart';
import 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc(this._repository) : super(const ExploreInitial()) {
    on<ExploreStarted>(_onStarted);
    on<ExploreFeedSnapshot>(_onFeedSnapshot);
    on<ExploreFeedStreamFailed>(_onFeedStreamFailed);
    on<ExploreSearchChanged>(_onSearchChanged);
    on<ExploreFiltersChanged>(_onFiltersChanged);
    on<ExploreSortChanged>(_onSortChanged);
    on<ExploreFiltersReset>(_onFiltersReset);
  }

  final ExploreRepository _repository;

  StreamSubscription<ExploreFeedEntity>? _feedSub;

  Future<void> _onStarted(ExploreStarted event, Emitter<ExploreState> emit) async {
    emit(const ExploreLoading());
    await _feedSub?.cancel();
    _feedSub = _repository.watchFeed().listen(
      (feed) => add(ExploreFeedSnapshot(feed)),
      onError: (_) => add(const ExploreFeedStreamFailed()),
    );
  }

  void _onFeedStreamFailed(ExploreFeedStreamFailed event, Emitter<ExploreState> emit) {
    emit(const ExploreError('Unable to load explore'));
  }

  void _onFeedSnapshot(ExploreFeedSnapshot event, Emitter<ExploreState> emit) {
    final s = state;
    if (s is ExploreLoaded) {
      emit(s.copyWith(feed: event.feed));
    } else {
      emit(
        ExploreLoaded(
          feed: event.feed,
          filters: ExploreFilters.initial,
          searchQuery: '',
          sort: ExploreSort.popularity,
        ),
      );
    }
  }

  void _onSearchChanged(ExploreSearchChanged event, Emitter<ExploreState> emit) {
    final s = state;
    if (s is! ExploreLoaded) return;
    emit(s.copyWith(searchQuery: event.query));
  }

  void _onFiltersChanged(ExploreFiltersChanged event, Emitter<ExploreState> emit) {
    final s = state;
    if (s is! ExploreLoaded) return;
    emit(s.copyWith(filters: event.filters));
  }

  void _onSortChanged(ExploreSortChanged event, Emitter<ExploreState> emit) {
    final s = state;
    if (s is! ExploreLoaded) return;
    emit(s.copyWith(sort: event.sort));
  }

  void _onFiltersReset(ExploreFiltersReset event, Emitter<ExploreState> emit) {
    final s = state;
    if (s is! ExploreLoaded) return;
    emit(s.copyWith(filters: ExploreFilters.initial));
  }

  @override
  Future<void> close() {
    _feedSub?.cancel();
    return super.close();
  }
}

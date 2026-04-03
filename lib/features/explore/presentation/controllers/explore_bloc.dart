import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/explore_filters.dart';
import '../../domain/entities/explore_sort.dart';
import '../../domain/usecases/get_explore_feed_usecase.dart';
import 'explore_event.dart';
import 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc(this._getFeed) : super(const ExploreInitial()) {
    on<ExploreStarted>(_onStarted);
    on<ExploreSearchChanged>(_onSearchChanged);
    on<ExploreFiltersChanged>(_onFiltersChanged);
    on<ExploreSortChanged>(_onSortChanged);
    on<ExploreFiltersReset>(_onFiltersReset);
  }

  final GetExploreFeedUseCase _getFeed;

  Future<void> _onStarted(ExploreStarted event, Emitter<ExploreState> emit) async {
    emit(const ExploreLoading());
    final result = await _getFeed(const GetExploreFeedParams());
    result.fold(
      (failure) => emit(ExploreError(failure.message)),
      (feed) => emit(
        ExploreLoaded(
          feed: feed,
          filters: ExploreFilters.initial,
          searchQuery: '',
          sort: ExploreSort.popularity,
        ),
      ),
    );
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
}

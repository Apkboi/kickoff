import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/league_fixtures_page_entity.dart';
import '../../domain/usecases/get_league_fixtures_page_usecase.dart';
import 'league_fixtures_pagination_event.dart';
import 'league_fixtures_pagination_state.dart';

class LeagueFixturesPaginationBloc extends Bloc<LeagueFixturesPaginationEvent, LeagueFixturesPaginationState> {
  LeagueFixturesPaginationBloc(this._getFixturesPage) : super(const LeagueFixturesPaginationInitial()) {
    on<LeagueFixturesPaginationStarted>(_onStarted);
    on<LeagueFixturesPaginationNextRequested>(_onNextRequested);
  }

  final GetLeagueFixturesPageUseCase _getFixturesPage;

  String _competitionId = '';
  int _pageSize = 10;

  Future<void> _onStarted(
    LeagueFixturesPaginationStarted event,
    Emitter<LeagueFixturesPaginationState> emit,
  ) async {
    _competitionId = event.competitionId;
    _pageSize = event.pageSize;
    emit(const LeagueFixturesPaginationLoading());

    final result = await _getFixturesPage(
      GetLeagueFixturesPageParams(
        competitionId: _competitionId,
        limit: _pageSize,
        cursor: null,
      ),
    );

    result.fold(
      (failure) => emit(LeagueFixturesPaginationError(failure.message)),
      (page) => emit(
        LeagueFixturesPaginationLoaded(
          fixtures: page.fixtures,
          nextCursor: page.nextCursor,
          isLoadingMore: false,
        ),
      ),
    );
  }

  Future<void> _onNextRequested(
    LeagueFixturesPaginationNextRequested event,
    Emitter<LeagueFixturesPaginationState> emit,
  ) async {
    final s = state;
    if (s is! LeagueFixturesPaginationLoaded) return;
    if (s.isLoadingMore) return;
    final nextCursor = s.nextCursor;
    if (nextCursor == null) return;

    emit(LeagueFixturesPaginationLoaded(
      fixtures: s.fixtures,
      nextCursor: s.nextCursor,
      isLoadingMore: true,
    ));

    final result = await _getFixturesPage(
      GetLeagueFixturesPageParams(
        competitionId: _competitionId,
        limit: _pageSize,
        cursor: nextCursor,
      ),
    );

    result.fold(
      (failure) => emit(LeagueFixturesPaginationError(failure.message)),
      (LeagueFixturesPageEntity page) => emit(
        LeagueFixturesPaginationLoaded(
          fixtures: [...s.fixtures, ...page.fixtures],
          nextCursor: page.nextCursor,
          isLoadingMore: false,
        ),
      ),
    );
  }
}


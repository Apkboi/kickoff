import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/league_detail_entity.dart';
import '../../domain/entities/standing_row_entity.dart';
import '../../domain/usecases/get_competition_by_id_usecase.dart';
import '../../domain/usecases/watch_competition_standings_usecase.dart';
import 'competition_detail_event.dart';
import 'competition_detail_state.dart';

class CompetitionDetailBloc extends Bloc<CompetitionDetailEvent, CompetitionDetailState> {
  CompetitionDetailBloc(this._getById, this._watchStandings) : super(const CompetitionDetailInitial()) {
    on<CompetitionDetailRequested>(_onRequested);
    on<CompetitionDetailStandingsUpdated>(_onStandingsUpdated);
  }

  final GetCompetitionByIdUseCase _getById;
  final WatchCompetitionStandingsUseCase _watchStandings;
  StreamSubscription<List<StandingRowEntity>>? _standingsSub;
  LeagueDetailEntity? _detailCache;

  Future<void> _onRequested(
    CompetitionDetailRequested event,
    Emitter<CompetitionDetailState> emit,
  ) async {
    emit(const CompetitionDetailLoading());
    final result = await _getById(GetCompetitionByIdParams(id: event.id));
    result.fold(
      (failure) => emit(CompetitionDetailError(failure.message)),
      (detail) {
        _detailCache = detail;
        emit(CompetitionDetailLoaded(detail: detail, standings: detail.standings));
        _standingsSub?.cancel();
        _standingsSub = _watchStandings(event.id).listen(
          (rows) => add(CompetitionDetailStandingsUpdated(rows)),
        );
      },
    );
  }

  void _onStandingsUpdated(
    CompetitionDetailStandingsUpdated event,
    Emitter<CompetitionDetailState> emit,
  ) {
    final detail = _detailCache;
    if (detail == null) return;
    emit(CompetitionDetailLoaded(detail: detail, standings: event.rows));
  }

  @override
  Future<void> close() async {
    await _standingsSub?.cancel();
    return super.close();
  }
}

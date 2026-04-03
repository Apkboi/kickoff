import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/competition_entity.dart';
import '../../domain/repositories/competition_repository.dart';
import 'competition_event.dart';
import 'competition_state.dart';

class CompetitionBloc extends Bloc<CompetitionEvent, CompetitionState> {
  CompetitionBloc(this._repository) : super(const CompetitionInitial()) {
    on<CompetitionsRequested>(_onCompetitionsRequested);
    on<CompetitionListUpdated>(_onListUpdated);
    on<CompetitionWatchFailed>(_onWatchFailed);
  }

  final CompetitionRepository _repository;

  StreamSubscription<List<CompetitionEntity>>? _watchSub;

  Future<void> _onCompetitionsRequested(
    CompetitionsRequested event,
    Emitter<CompetitionState> emit,
  ) async {
    emit(const CompetitionLoading());
    await _watchSub?.cancel();
    _watchSub = _repository.watchCompetitions().listen(
      (list) => add(CompetitionListUpdated(list)),
      onError: (_) => add(const CompetitionWatchFailed()),
    );
  }

  void _onWatchFailed(CompetitionWatchFailed event, Emitter<CompetitionState> emit) {
    emit(const CompetitionError('Unable to load tournaments'));
  }

  void _onListUpdated(
    CompetitionListUpdated event,
    Emitter<CompetitionState> emit,
  ) {
    emit(CompetitionLoaded(event.competitions));
  }

  @override
  Future<void> close() {
    _watchSub?.cancel();
    return super.close();
  }
}

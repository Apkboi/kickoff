import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_competitions_usecase.dart';
import 'competition_event.dart';
import 'competition_state.dart';

class CompetitionBloc extends Bloc<CompetitionEvent, CompetitionState> {
  CompetitionBloc(this._getCompetitionsUseCase) : super(const CompetitionInitial()) {
    on<CompetitionsRequested>(_onCompetitionsRequested);
  }

  final GetCompetitionsUseCase _getCompetitionsUseCase;

  Future<void> _onCompetitionsRequested(
    CompetitionsRequested event,
    Emitter<CompetitionState> emit,
  ) async {
    emit(const CompetitionLoading());
    final result = await _getCompetitionsUseCase(const GetCompetitionsParams());
    result.fold(
      (failure) => emit(CompetitionError(failure.message)),
      (competitions) => emit(CompetitionLoaded(competitions)),
    );
  }
}

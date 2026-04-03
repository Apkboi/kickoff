import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/watch_match_detail_usecase.dart';
import 'match_detail_event.dart';
import 'match_detail_state.dart';

class MatchDetailBloc extends Bloc<MatchDetailEvent, MatchDetailState> {
  MatchDetailBloc(this._watchMatch) : super(const MatchDetailInitial()) {
    on<MatchDetailWatchStarted>(_onWatchStarted);
  }

  final WatchMatchDetailUseCase _watchMatch;

  Future<void> _onWatchStarted(
    MatchDetailWatchStarted event,
    Emitter<MatchDetailState> emit,
  ) async {
    emit(const MatchDetailLoading());
    await emit.forEach(
      _watchMatch(
        WatchMatchDetailParams(
          competitionId: event.competitionId,
          matchId: event.matchId,
        ),
      ),
      onData: MatchDetailLoaded.new,
      onError: (_, __) => const MatchDetailError('Live feed interrupted'),
    );
  }
}

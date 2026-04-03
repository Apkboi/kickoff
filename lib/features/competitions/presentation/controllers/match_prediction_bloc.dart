import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/match_prediction_view_entity.dart';
import '../../domain/usecases/submit_match_prediction_usecase.dart';
import '../../domain/usecases/watch_match_prediction_usecase.dart';
import 'match_prediction_event.dart';
import 'match_prediction_state.dart';

class MatchPredictionBloc extends Bloc<MatchPredictionEvent, MatchPredictionState> {
  MatchPredictionBloc(
    this._watch,
    this._submit,
  ) : super(const MatchPredictionInitial()) {
    on<MatchPredictionStarted>(_onStarted);
    on<MatchPredictionStreamData>(_onStreamData);
    on<MatchPredictionStreamFailed>(_onStreamFailed);
    on<MatchPredictionSubmitted>(_onSubmit);
  }

  final WatchMatchPredictionUseCase _watch;
  final SubmitMatchPredictionUseCase _submit;

  String? _leagueId;
  String? _matchId;
  String? _userId;

  StreamSubscription<MatchPredictionViewEntity>? _panelSub;

  Future<void> _onStarted(
    MatchPredictionStarted event,
    Emitter<MatchPredictionState> emit,
  ) async {
    await _panelSub?.cancel();
    _panelSub = null;

    _leagueId = event.leagueId;
    _matchId = event.matchId;
    _userId = event.userId;
    emit(const MatchPredictionLoading());

    _panelSub = _watch(
      WatchMatchPredictionParams(
        leagueId: event.leagueId,
        matchId: event.matchId,
        userId: event.userId,
      ),
    ).listen(
      (d) => add(MatchPredictionStreamData(d)),
      onError: (_, __) => add(const MatchPredictionStreamFailed()),
    );
  }

  void _onStreamData(
    MatchPredictionStreamData event,
    Emitter<MatchPredictionState> emit,
  ) {
    emit(MatchPredictionReady(event.data));
  }

  void _onStreamFailed(
    MatchPredictionStreamFailed event,
    Emitter<MatchPredictionState> emit,
  ) {
    emit(const MatchPredictionError('Predictions unavailable'));
  }

  Future<void> _onSubmit(
    MatchPredictionSubmitted event,
    Emitter<MatchPredictionState> emit,
  ) async {
    final cur = state;
    if (cur is! MatchPredictionReady) return;
    final uid = _userId;
    final lid = _leagueId;
    final mid = _matchId;
    if (uid == null || lid == null || mid == null) return;

    final result = await _submit(
      SubmitMatchPredictionParams(
        leagueId: lid,
        matchId: mid,
        userId: uid,
        homePredicted: event.homePredicted,
        awayPredicted: event.awayPredicted,
      ),
    );
    result.fold(
      (f) => emit(MatchPredictionReady(cur.data, actionError: f.message)),
      (_) {
        final optimistic = cur.data.copyWith(
          userPrediction: UserPredictionEntity(
            homePredicted: event.homePredicted,
            awayPredicted: event.awayPredicted,
            pointsAwarded: cur.data.userPrediction?.pointsAwarded ?? 0,
          ),
        );
        emit(MatchPredictionReady(optimistic));
      },
    );
  }

  @override
  Future<void> close() {
    _panelSub?.cancel();
    return super.close();
  }
}

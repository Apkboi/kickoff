import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/no_params.dart';
import '../../domain/entities/home_live_match_entity.dart';
import '../../domain/usecases/watch_live_matches_usecase.dart';

sealed class LiveMatchesEvent extends Equatable {
  const LiveMatchesEvent();

  @override
  List<Object?> get props => [];
}

class LiveMatchesStarted extends LiveMatchesEvent {
  const LiveMatchesStarted();
}

sealed class LiveMatchesState extends Equatable {
  const LiveMatchesState();

  @override
  List<Object?> get props => [];
}

class LiveMatchesInitial extends LiveMatchesState {
  const LiveMatchesInitial();
}

class LiveMatchesLoadError extends LiveMatchesState {
  const LiveMatchesLoadError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class LiveMatchesReady extends LiveMatchesState {
  const LiveMatchesReady(this.matches);

  final List<HomeLiveMatchEntity> matches;

  @override
  List<Object?> get props => [matches];
}

class LiveMatchesBloc extends Bloc<LiveMatchesEvent, LiveMatchesState> {
  LiveMatchesBloc(this._watch) : super(const LiveMatchesInitial()) {
    on<LiveMatchesStarted>(_onStarted);
  }

  final WatchLiveMatchesUseCase _watch;

  Future<void> _onStarted(
    LiveMatchesStarted event,
    Emitter<LiveMatchesState> emit,
  ) async {
    await emit.forEach<List<HomeLiveMatchEntity>>(
      _watch(const NoParams()),
      onData: (matches) => LiveMatchesReady(matches),
      onError: (e, _) => LiveMatchesLoadError(e.toString()),
    );
  }
}

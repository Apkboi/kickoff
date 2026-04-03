import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/no_params.dart';
import '../../domain/entities/home_trending_league_entity.dart';
import '../../domain/usecases/watch_trending_leagues_usecase.dart';

sealed class TrendingLeaguesEvent extends Equatable {
  const TrendingLeaguesEvent();

  @override
  List<Object?> get props => [];
}

class TrendingLeaguesStarted extends TrendingLeaguesEvent {
  const TrendingLeaguesStarted();
}

sealed class TrendingLeaguesState extends Equatable {
  const TrendingLeaguesState();

  @override
  List<Object?> get props => [];
}

class TrendingLeaguesInitial extends TrendingLeaguesState {
  const TrendingLeaguesInitial();
}

class TrendingLeaguesLoadError extends TrendingLeaguesState {
  const TrendingLeaguesLoadError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class TrendingLeaguesReady extends TrendingLeaguesState {
  const TrendingLeaguesReady(this.leagues);

  final List<HomeTrendingLeagueEntity> leagues;

  @override
  List<Object?> get props => [leagues];
}

class TrendingLeaguesBloc extends Bloc<TrendingLeaguesEvent, TrendingLeaguesState> {
  TrendingLeaguesBloc(this._watch) : super(const TrendingLeaguesInitial()) {
    on<TrendingLeaguesStarted>(_onStarted);
  }

  final WatchTrendingLeaguesUseCase _watch;

  Future<void> _onStarted(
    TrendingLeaguesStarted event,
    Emitter<TrendingLeaguesState> emit,
  ) async {
    await emit.forEach<List<HomeTrendingLeagueEntity>>(
      _watch(const NoParams()),
      onData: (leagues) => TrendingLeaguesReady(leagues),
      onError: (e, _) => TrendingLeaguesLoadError(e.toString()),
    );
  }
}

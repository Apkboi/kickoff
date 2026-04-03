import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/no_params.dart';
import '../../domain/entities/home_upcoming_fixture_entity.dart';
import '../../domain/usecases/watch_upcoming_matches_usecase.dart';

sealed class UpcomingMatchesEvent extends Equatable {
  const UpcomingMatchesEvent();

  @override
  List<Object?> get props => [];
}

class UpcomingMatchesStarted extends UpcomingMatchesEvent {
  const UpcomingMatchesStarted();
}

sealed class UpcomingMatchesState extends Equatable {
  const UpcomingMatchesState();

  @override
  List<Object?> get props => [];
}

class UpcomingMatchesInitial extends UpcomingMatchesState {
  const UpcomingMatchesInitial();
}

class UpcomingMatchesLoadError extends UpcomingMatchesState {
  const UpcomingMatchesLoadError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class UpcomingMatchesReady extends UpcomingMatchesState {
  const UpcomingMatchesReady(this.matches);

  final List<HomeUpcomingFixtureEntity> matches;

  @override
  List<Object?> get props => [matches];
}

class UpcomingMatchesBloc extends Bloc<UpcomingMatchesEvent, UpcomingMatchesState> {
  UpcomingMatchesBloc(this._watch) : super(const UpcomingMatchesInitial()) {
    on<UpcomingMatchesStarted>(_onStarted);
  }

  final WatchUpcomingMatchesUseCase _watch;

  Future<void> _onStarted(
    UpcomingMatchesStarted event,
    Emitter<UpcomingMatchesState> emit,
  ) async {
    await emit.forEach<List<HomeUpcomingFixtureEntity>>(
      _watch(const NoParams()),
      onData: (matches) => UpcomingMatchesReady(matches),
      onError: (e, _) => UpcomingMatchesLoadError(e.toString()),
    );
  }
}

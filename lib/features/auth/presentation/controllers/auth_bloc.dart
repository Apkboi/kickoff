import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/no_params.dart';
import '../../domain/usecases/observe_auth_state_usecase.dart';
import '../../domain/usecases/send_password_reset_usecase.dart';
import '../../domain/usecases/sign_in_with_email_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_with_email_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required ObserveAuthStateUseCase observeAuthStateUseCase,
    required SignInWithEmailUseCase signInWithEmailUseCase,
    required SignUpWithEmailUseCase signUpWithEmailUseCase,
    required SignOutUseCase signOutUseCase,
    required SendPasswordResetUseCase sendPasswordResetUseCase,
  })  : _observeAuthStateUseCase = observeAuthStateUseCase,
        _signInWithEmailUseCase = signInWithEmailUseCase,
        _signUpWithEmailUseCase = signUpWithEmailUseCase,
        _signOutUseCase = signOutUseCase,
        _sendPasswordResetUseCase = sendPasswordResetUseCase,
        super(const AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthUserChanged>(_onAuthUserChanged);
    on<SignInWithEmailRequested>(_onSignInWithEmailRequested);
    on<SignUpWithEmailRequested>(_onSignUpWithEmailRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
  }

  final ObserveAuthStateUseCase _observeAuthStateUseCase;
  final SignInWithEmailUseCase _signInWithEmailUseCase;
  final SignUpWithEmailUseCase _signUpWithEmailUseCase;
  final SignOutUseCase _signOutUseCase;
  final SendPasswordResetUseCase _sendPasswordResetUseCase;

  StreamSubscription<dynamic>? _authSub;

  Future<void> _onAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    await _authSub?.cancel();
    _authSub = _observeAuthStateUseCase(const NoParams()).listen(
      (user) => add(AuthUserChanged(user)),
    );
  }

  void _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthLoaded(event.user));
  }

  Future<void> _onSignInWithEmailRequested(
    SignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signInWithEmailUseCase(
      SignInWithEmailParams(
        email: event.email,
        password: event.password,
      ),
    );
    await result.fold(
      (failure) async => emit(AuthFailure(failure.message)),
      (_) async {},
    );
  }

  Future<void> _onSignUpWithEmailRequested(
    SignUpWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signUpWithEmailUseCase(
      SignUpWithEmailParams(
        email: event.email,
        password: event.password,
        displayName: event.displayName,
      ),
    );
    await result.fold(
      (failure) async => emit(AuthFailure(failure.message)),
      (_) async {},
    );
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signOutUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) {},
    );
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _sendPasswordResetUseCase(
      SendPasswordResetParams(email: event.email),
    );
    await result.fold(
      (failure) async => emit(AuthFailure(failure.message)),
      (_) async => emit(const AuthPasswordResetEmailSent()),
    );
  }

  @override
  Future<void> close() {
    unawaited(_authSub?.cancel());
    return super.close();
  }
}

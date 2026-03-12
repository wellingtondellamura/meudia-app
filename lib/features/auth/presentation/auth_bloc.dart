import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import '../domain/auth_entities.dart';
import '../domain/login_use_case.dart';
import '../domain/logout_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._loginUseCase, this._logoutUseCase)
      : super(const AuthState.initial()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginSubmitted>(_onLoginSubmitted);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthSessionExpired>(_onSessionExpired);
  }

  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final result = await _logoutUseCase.currentSession();
    result.fold(
      (_) => emit(state.copyWith(status: AuthStatus.unauthenticated)),
      (session) => emit(
        state.copyWith(
          status: session == null
              ? AuthStatus.unauthenticated
              : AuthStatus.authenticated,
          session: session,
        ),
      ),
    );
  }

  Future<void> _onLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearMessage: true));
    final result = await _loginUseCase(
      LoginParams(
        email: event.email,
        password: event.password,
        deviceName: event.deviceName,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          failure: failure,
        ),
      ),
      (session) => emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          session: session,
          clearMessage: true,
        ),
      ),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logoutUseCase();
    emit(const AuthState.initial().copyWith(status: AuthStatus.unauthenticated));
  }

  Future<void> _onSessionExpired(
    AuthSessionExpired event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      const AuthState.initial().copyWith(
        status: AuthStatus.unauthenticated,
        failure: UnauthorizedFailure('Sua sessão expirou. Faça login novamente.'),
      ),
    );
  }
}

part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState({
    required this.status,
    this.session,
    this.failure,
  });

  const AuthState.initial() : this(status: AuthStatus.initial);

  final AuthStatus status;
  final AuthEntity? session;
  final Failure? failure;

  AuthState copyWith({
    AuthStatus? status,
    AuthEntity? session,
    Failure? failure,
    bool clearMessage = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: session ?? this.session,
      failure: clearMessage ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, session, failure];
}

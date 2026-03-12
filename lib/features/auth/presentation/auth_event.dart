part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class AuthSessionExpired extends AuthEvent {
  const AuthSessionExpired();
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthLoginSubmitted extends AuthEvent {
  const AuthLoginSubmitted({
    required this.email,
    required this.password,
    required this.deviceName,
  });

  final String email;
  final String password;
  final String deviceName;

  @override
  List<Object?> get props => [email, password, deviceName];
}

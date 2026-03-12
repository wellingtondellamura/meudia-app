import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
  });

  final int id;
  final String name;
  final String email;

  @override
  List<Object?> get props => [id, name, email];
}

class AuthEntity extends Equatable {
  const AuthEntity({
    required this.token,
    required this.user,
  });

  final String token;
  final UserEntity user;

  @override
  List<Object?> get props => [token, user];
}

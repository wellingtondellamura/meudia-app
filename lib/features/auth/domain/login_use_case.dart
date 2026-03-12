import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import 'auth_entities.dart';
import 'auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, AuthEntity>> call(LoginParams params) {
    return _repository.login(
      email: params.email,
      password: params.password,
      deviceName: params.deviceName,
    );
  }
}

class LoginParams extends Equatable {
  const LoginParams({
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

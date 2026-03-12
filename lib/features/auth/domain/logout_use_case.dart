import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import 'auth_entities.dart';
import 'auth_repository.dart';

class LogoutUseCase {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, Unit>> call() => _repository.logout();

  Future<Either<Failure, AuthEntity?>> currentSession() {
    return _repository.getCurrentSession();
  }
}

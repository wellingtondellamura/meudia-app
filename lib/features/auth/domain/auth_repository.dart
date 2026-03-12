import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import 'auth_entities.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
    required String deviceName,
  });

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, AuthEntity?>> getCurrentSession();
}

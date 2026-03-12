import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/session_storage.dart';
import '../domain/auth_entities.dart';
import '../domain/auth_repository.dart';
import 'auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote, this._sessionStorage);

  final AuthRemoteDataSource _remote;
  final SessionStorage _sessionStorage;

  @override
  Future<Either<Failure, AuthEntity?>> getCurrentSession() async {
    try {
      final session = await _sessionStorage.readSession();
      return right(session);
    } catch (exception) {
      return left(mapExceptionToFailure(exception));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
    required String deviceName,
  }) async {
    try {
      final session = await _remote.login(
        email: email,
        password: password,
        deviceName: deviceName,
      );
      await _sessionStorage.saveSession(session);
      return right(session);
    } catch (exception) {
      return left(mapExceptionToFailure(exception));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _remote.logout();
    } catch (_) {}
    await _sessionStorage.clear();
    return right(unit);
  }
}

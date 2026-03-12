import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/network/api_client.dart';
import '../domain/profile_entity.dart';
import '../domain/profile_repository.dart';
import 'profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remote);

  final ProfileRemoteDataSource _remote;

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      return right(await _remote.getProfile());
    } catch (exception) {
      return left(mapExceptionToFailure(exception));
    }
  }
}

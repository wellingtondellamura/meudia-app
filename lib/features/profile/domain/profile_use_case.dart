import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import 'profile_entity.dart';
import 'profile_repository.dart';

class GetProfileUseCase {
  const GetProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, ProfileEntity>> call() => _repository.getProfile();
}

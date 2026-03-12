import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import 'profile_entity.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();
}

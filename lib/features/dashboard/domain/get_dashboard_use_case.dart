import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import 'dashboard_entities.dart';
import 'dashboard_repository.dart';

class GetDashboardUseCase {
  const GetDashboardUseCase(this._repository);

  final DashboardRepository _repository;

  Future<Either<Failure, DashboardEntity>> call() => _repository.getDashboard();
}

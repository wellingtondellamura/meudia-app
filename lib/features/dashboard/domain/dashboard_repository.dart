import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import 'dashboard_entities.dart';

abstract interface class DashboardRepository {
  Future<Either<Failure, DashboardEntity>> getDashboard();
}

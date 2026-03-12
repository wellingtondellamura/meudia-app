import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/network/api_client.dart';
import '../domain/dashboard_entities.dart';
import '../domain/dashboard_repository.dart';
import 'dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl(this._remote);

  final DashboardRemoteDataSource _remote;

  @override
  Future<Either<Failure, DashboardEntity>> getDashboard() async {
    try {
      final dashboard = await _remote.getDashboard();
      return right(dashboard);
    } catch (exception) {
      return left(mapExceptionToFailure(exception));
    }
  }
}

import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/network/api_client.dart';
import '../domain/glycemia_entities.dart';
import '../domain/glycemia_repository.dart';
import 'glycemia_remote_data_source.dart';

class GlycemiaRepositoryImpl implements GlycemiaRepository {
  const GlycemiaRepositoryImpl(this._remote);

  final GlycemiaRemoteDataSource _remote;

  @override
  Future<Either<Failure, GlycemiaChartEntity>> getChart({
    required String period,
  }) async {
    try {
      return right(await _remote.getChart(period: period));
    } catch (exception) {
      return left(mapExceptionToFailure(exception));
    }
  }

  @override
  Future<Either<Failure, List<GlycemiaEntity>>> getHistory({
    required String period,
  }) async {
    try {
      return right(await _remote.getHistory(period: period));
    } catch (exception) {
      return left(mapExceptionToFailure(exception));
    }
  }

  @override
  Future<Either<Failure, GlycemiaEntity>> register(GlycemiaInput input) async {
    try {
      return right(await _remote.register(input));
    } catch (exception) {
      return left(mapExceptionToFailure(exception));
    }
  }
}

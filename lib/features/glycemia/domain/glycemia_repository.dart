import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import 'glycemia_entities.dart';

abstract interface class GlycemiaRepository {
  Future<Either<Failure, List<GlycemiaEntity>>> getHistory({
    required String period,
  });

  Future<Either<Failure, GlycemiaChartEntity>> getChart({
    required String period,
  });

  Future<Either<Failure, GlycemiaEntity>> register(GlycemiaInput input);
}

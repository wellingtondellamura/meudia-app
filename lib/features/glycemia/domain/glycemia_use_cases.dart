import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import 'glycemia_entities.dart';
import 'glycemia_repository.dart';

class GetGlycemiaHistoryUseCase {
  const GetGlycemiaHistoryUseCase(this._repository);

  final GlycemiaRepository _repository;

  Future<Either<Failure, List<GlycemiaEntity>>> call(String period) {
    return _repository.getHistory(period: period);
  }
}

class GetGlycemiaChartUseCase {
  const GetGlycemiaChartUseCase(this._repository);

  final GlycemiaRepository _repository;

  Future<Either<Failure, GlycemiaChartEntity>> call(String period) {
    return _repository.getChart(period: period);
  }
}

class RegisterGlycemiaUseCase {
  const RegisterGlycemiaUseCase(this._repository);

  final GlycemiaRepository _repository;

  Future<Either<Failure, GlycemiaEntity>> call(GlycemiaInput input) {
    if (input.value < 20 || input.value > 600) {
      return Future.value(
        left(
          const ValidationFailure(
            'O valor inserido parece incorreto. A glicemia deve estar entre 20 e 600.',
          ),
        ),
      );
    }
    if (input.recordedAt.isAfter(DateTime.now())) {
      return Future.value(
        left(
          const ValidationFailure(
            'A data do registro não pode estar no futuro.',
          ),
        ),
      );
    }
    return _repository.register(input);
  }
}

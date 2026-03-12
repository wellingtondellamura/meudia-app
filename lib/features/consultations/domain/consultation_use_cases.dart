import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import 'consultation_entity.dart';
import 'consultation_repository.dart';

class GetConsultationsUseCase {
  const GetConsultationsUseCase(this._repository);

  final ConsultationRepository _repository;

  Future<Either<Failure, List<ConsultationEntity>>> call() {
    return _repository.getConsultations();
  }
}

class ConfirmConsultationUseCase {
  const ConfirmConsultationUseCase(this._repository);

  final ConsultationRepository _repository;

  Future<Either<Failure, Unit>> call(int id) => _repository.confirm(id);
}

class CancelConsultationUseCase {
  const CancelConsultationUseCase(this._repository);

  final ConsultationRepository _repository;

  Future<Either<Failure, Unit>> call(int id, {String? reason}) {
    return _repository.cancel(id, reason: reason);
  }
}

class RescheduleConsultationUseCase {
  const RescheduleConsultationUseCase(this._repository);

  final ConsultationRepository _repository;

  Future<Either<Failure, ConsultationEntity>> call(
    int id, {
    required int slotId,
  }) {
    return _repository.reschedule(id, slotId: slotId);
  }
}

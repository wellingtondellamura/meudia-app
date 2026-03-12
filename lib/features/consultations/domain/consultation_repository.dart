import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import 'consultation_entity.dart';

abstract interface class ConsultationRepository {
  Future<Either<Failure, List<ConsultationEntity>>> getConsultations();
  Future<Either<Failure, Unit>> confirm(int id);
  Future<Either<Failure, Unit>> cancel(int id, {String? reason});
  Future<Either<Failure, ConsultationEntity>> reschedule(
    int id, {
    required int slotId,
  });
}

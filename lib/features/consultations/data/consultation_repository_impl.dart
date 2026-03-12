import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/network/api_client.dart';
import '../domain/consultation_entity.dart';
import '../domain/consultation_repository.dart';
import 'consultation_remote_data_source.dart';

class ConsultationRepositoryImpl implements ConsultationRepository {
  const ConsultationRepositoryImpl(this._remote);

  final ConsultationRemoteDataSource _remote;

  @override
  Future<Either<Failure, Unit>> cancel(int id, {String? reason}) async {
    try {
      await _remote.cancel(id, reason: reason);
      return right(unit);
    } catch (exception) {
      return left(mapExceptionToFailure(exception));
    }
  }

  @override
  Future<Either<Failure, Unit>> confirm(int id) async {
    try {
      await _remote.confirm(id);
      return right(unit);
    } catch (exception) {
      return left(mapExceptionToFailure(exception));
    }
  }

  @override
  Future<Either<Failure, List<ConsultationEntity>>> getConsultations() async {
    try {
      return right(await _remote.getConsultations());
    } catch (exception) {
      return left(mapExceptionToFailure(exception));
    }
  }

  @override
  Future<Either<Failure, ConsultationEntity>> reschedule(
    int id, {
    required int slotId,
  }) async {
    try {
      return right(await _remote.reschedule(id, slotId: slotId));
    } catch (exception) {
      return left(mapExceptionToFailure(exception));
    }
  }
}

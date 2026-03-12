import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import '../domain/consultation_entity.dart';
import '../domain/consultation_use_cases.dart';

part 'consultation_event.dart';
part 'consultation_state.dart';

class ConsultationBloc extends Bloc<ConsultationEvent, ConsultationState> {
  ConsultationBloc(
    this._getConsultationsUseCase,
    this._confirmConsultationUseCase,
    this._cancelConsultationUseCase,
    this._rescheduleConsultationUseCase,
  ) : super(const ConsultationState.initial()) {
    on<ConsultationsRequested>(_onRequested);
    on<ConsultationConfirmed>(_onConfirmed);
    on<ConsultationCancelled>(_onCancelled);
    on<ConsultationRescheduled>(_onRescheduled);
  }

  final GetConsultationsUseCase _getConsultationsUseCase;
  final ConfirmConsultationUseCase _confirmConsultationUseCase;
  final CancelConsultationUseCase _cancelConsultationUseCase;
  final RescheduleConsultationUseCase _rescheduleConsultationUseCase;

  Future<void> _onRequested(
    ConsultationsRequested event,
    Emitter<ConsultationState> emit,
  ) async {
    emit(state.copyWith(status: ConsultationStatus.loading, clearFeedback: true));
    final result = await _getConsultationsUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(status: ConsultationStatus.failure, failure: failure),
      ),
      (items) => emit(
        state.copyWith(status: ConsultationStatus.success, consultations: items),
      ),
    );
  }

  Future<void> _onConfirmed(
    ConsultationConfirmed event,
    Emitter<ConsultationState> emit,
  ) async {
    final result = await _confirmConsultationUseCase(event.id);
    await result.fold(
      (failure) async => emit(state.copyWith(failure: failure)),
      (_) async {
        emit(state.copyWith(feedbackMessage: 'Consulta confirmada com sucesso.'));
        add(const ConsultationsRequested());
      },
    );
  }

  Future<void> _onCancelled(
    ConsultationCancelled event,
    Emitter<ConsultationState> emit,
  ) async {
    final result = await _cancelConsultationUseCase(event.id, reason: event.reason);
    await result.fold(
      (failure) async => emit(state.copyWith(failure: failure)),
      (_) async {
        emit(state.copyWith(feedbackMessage: 'Consulta cancelada com sucesso.'));
        add(const ConsultationsRequested());
      },
    );
  }

  Future<void> _onRescheduled(
    ConsultationRescheduled event,
    Emitter<ConsultationState> emit,
  ) async {
    final result = await _rescheduleConsultationUseCase(event.id, slotId: event.slotId);
    await result.fold(
      (failure) async => emit(state.copyWith(failure: failure)),
      (_) async {
        emit(state.copyWith(feedbackMessage: 'Consulta reagendada com sucesso.'));
        add(const ConsultationsRequested());
      },
    );
  }
}

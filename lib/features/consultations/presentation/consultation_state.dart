part of 'consultation_bloc.dart';

enum ConsultationStatus { initial, loading, success, failure }

class ConsultationState extends Equatable {
  const ConsultationState({
    required this.status,
    this.consultations = const [],
    this.failure,
    this.feedbackMessage,
  });

  const ConsultationState.initial() : this(status: ConsultationStatus.initial);

  final ConsultationStatus status;
  final List<ConsultationEntity> consultations;
  final Failure? failure;
  final String? feedbackMessage;

  ConsultationState copyWith({
    ConsultationStatus? status,
    List<ConsultationEntity>? consultations,
    Failure? failure,
    String? feedbackMessage,
    bool clearFeedback = false,
  }) {
    return ConsultationState(
      status: status ?? this.status,
      consultations: consultations ?? this.consultations,
      failure: clearFeedback ? null : failure ?? this.failure,
      feedbackMessage:
          clearFeedback ? null : feedbackMessage ?? this.feedbackMessage,
    );
  }

  @override
  List<Object?> get props => [status, consultations, failure, feedbackMessage];
}

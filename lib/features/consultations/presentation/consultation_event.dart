part of 'consultation_bloc.dart';

sealed class ConsultationEvent extends Equatable {
  const ConsultationEvent();

  @override
  List<Object?> get props => [];
}

class ConsultationsRequested extends ConsultationEvent {
  const ConsultationsRequested();
}

class ConsultationConfirmed extends ConsultationEvent {
  const ConsultationConfirmed(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class ConsultationCancelled extends ConsultationEvent {
  const ConsultationCancelled(this.id, {this.reason});

  final int id;
  final String? reason;

  @override
  List<Object?> get props => [id, reason];
}

class ConsultationRescheduled extends ConsultationEvent {
  const ConsultationRescheduled(this.id, this.slotId);

  final int id;
  final int slotId;

  @override
  List<Object?> get props => [id, slotId];
}

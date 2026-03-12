import 'package:equatable/equatable.dart';

class ConsultationEntity extends Equatable {
  const ConsultationEntity({
    required this.id,
    required this.data,
    required this.horaInicio,
    required this.horaFim,
    required this.status,
    required this.statusLabel,
    required this.professional,
    required this.unit,
    required this.confirmedAt,
  });

  final int id;
  final String data;
  final String horaInicio;
  final String horaFim;
  final String status;
  final String statusLabel;
  final String professional;
  final String unit;
  final String? confirmedAt;

  @override
  List<Object?> get props => [
        id,
        data,
        horaInicio,
        horaFim,
        status,
        statusLabel,
        professional,
        unit,
        confirmedAt,
      ];
}

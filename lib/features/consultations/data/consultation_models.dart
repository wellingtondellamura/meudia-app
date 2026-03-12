import '../domain/consultation_entity.dart';

class ConsultationModel extends ConsultationEntity {
  const ConsultationModel({
    required super.id,
    required super.data,
    required super.horaInicio,
    required super.horaFim,
    required super.status,
    required super.statusLabel,
    required super.professional,
    required super.unit,
    required super.confirmedAt,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) {
    return ConsultationModel(
      id: json['id'] as int,
      data: json['data'] as String,
      horaInicio: json['hora_inicio'] as String,
      horaFim: json['hora_fim'] as String,
      status: json['status'] as String,
      statusLabel: json['status_label'] as String,
      professional: json['profissional'] as String,
      unit: json['unidade'] as String,
      confirmedAt: json['confirmado_em'] as String?,
    );
  }
}

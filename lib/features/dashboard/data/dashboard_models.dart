import '../../consultations/data/consultation_models.dart';
import '../../glycemia/data/glycemia_models.dart';
import '../domain/dashboard_entities.dart';

class DiagnosisModel extends DiagnosisEntity {
  const DiagnosisModel({
    required super.title,
    required super.plans,
    required super.prescriptions,
  });

  factory DiagnosisModel.fromJson(Map<String, dynamic> json) {
    return DiagnosisModel(
      title: json['titulo'] as String,
      plans: (json['planos'] as List<dynamic>).cast<String>(),
      prescriptions: (json['prescricoes'] as List<dynamic>).cast<String>(),
    );
  }
}

class CarePlanModel extends CarePlanEntity {
  const CarePlanModel({
    required super.consultationId,
    required super.date,
    required super.diagnoses,
  });

  factory CarePlanModel.fromJson(Map<String, dynamic> json) {
    return CarePlanModel(
      consultationId: json['consulta_id'] as int,
      date: json['data'] as String,
      diagnoses: (json['diagnosticos'] as List<dynamic>)
          .map((item) => DiagnosisModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ClinicalAlertModel extends ClinicalAlertEntity {
  const ClinicalAlertModel({
    required super.type,
    required super.level,
    required super.message,
  });

  factory ClinicalAlertModel.fromJson(Map<String, dynamic> json) {
    return ClinicalAlertModel(
      type: json['tipo'] as String,
      level: json['nivel'] as String,
      message: json['mensagem'] as String,
    );
  }
}

class DashboardModel extends DashboardEntity {
  const DashboardModel({
    required super.nextConsultation,
    required super.carePlan,
    required super.latestGlycemia,
    required super.risk,
    required super.alerts,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      nextConsultation: json['proxima_consulta'] == null
          ? null
          : ConsultationModel.fromJson(
              json['proxima_consulta'] as Map<String, dynamic>,
            ),
      carePlan: json['plano_resumido'] == null
          ? null
          : CarePlanModel.fromJson(json['plano_resumido'] as Map<String, dynamic>),
      latestGlycemia: json['ultima_glicemia'] == null
          ? null
          : GlycemiaModel.fromJson(json['ultima_glicemia'] as Map<String, dynamic>),
      risk: json['risco'] as String?,
      alerts: (json['alertas'] as List<dynamic>)
          .map((item) => ClinicalAlertModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

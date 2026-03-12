import 'package:equatable/equatable.dart';

import '../../consultations/domain/consultation_entity.dart';
import '../../glycemia/domain/glycemia_entities.dart';

class CarePlanEntity extends Equatable {
  const CarePlanEntity({
    required this.consultationId,
    required this.date,
    required this.diagnoses,
  });

  final int consultationId;
  final String date;
  final List<DiagnosisEntity> diagnoses;

  @override
  List<Object?> get props => [consultationId, date, diagnoses];
}

class DiagnosisEntity extends Equatable {
  const DiagnosisEntity({
    required this.title,
    required this.plans,
    required this.prescriptions,
  });

  final String title;
  final List<String> plans;
  final List<String> prescriptions;

  @override
  List<Object?> get props => [title, plans, prescriptions];
}

class ClinicalAlertEntity extends Equatable {
  const ClinicalAlertEntity({
    required this.type,
    required this.level,
    required this.message,
  });

  final String type;
  final String level;
  final String message;

  @override
  List<Object?> get props => [type, level, message];
}

class DashboardEntity extends Equatable {
  const DashboardEntity({
    required this.nextConsultation,
    required this.carePlan,
    required this.latestGlycemia,
    required this.risk,
    required this.alerts,
  });

  final ConsultationEntity? nextConsultation;
  final CarePlanEntity? carePlan;
  final GlycemiaEntity? latestGlycemia;
  final String? risk;
  final List<ClinicalAlertEntity> alerts;

  @override
  List<Object?> get props => [
        nextConsultation,
        carePlan,
        latestGlycemia,
        risk,
        alerts,
      ];
}

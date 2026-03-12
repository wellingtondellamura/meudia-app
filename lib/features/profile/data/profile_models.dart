import '../domain/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.susCard,
    required super.linkedUnit,
    required super.age,
    required super.gender,
    required super.lastRisk,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int,
      name: json['nome'] as String,
      susCard: json['cartao_sus'] as String,
      linkedUnit: json['unidade_vinculada'] as String?,
      age: json['idade'] as int?,
      gender: json['sexo'] as String?,
      lastRisk: json['ultimo_risco_estratificado'] as String?,
    );
  }
}

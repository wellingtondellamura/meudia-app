import '../domain/glycemia_entities.dart';

class GlycemiaModel extends GlycemiaEntity {
  const GlycemiaModel({
    required super.id,
    required super.value,
    required super.moment,
    required super.recordedAt,
    required super.origin,
  });

  factory GlycemiaModel.fromJson(Map<String, dynamic> json) {
    return GlycemiaModel(
      id: json['id'] as int,
      value: json['valor'] as int,
      moment: json['momento'] as String,
      recordedAt: json['registrado_em'] as String,
      origin: json['origem'] as String,
    );
  }
}

class GlycemiaChartModel extends GlycemiaChartEntity {
  const GlycemiaChartModel({
    required super.labels,
    required super.values,
    required super.average,
    required super.min,
    required super.max,
  });

  factory GlycemiaChartModel.fromJson(Map<String, dynamic> json) {
    return GlycemiaChartModel(
      labels: (json['labels'] as List<dynamic>).cast<String>(),
      values: (json['valores'] as List<dynamic>).cast<int>(),
      average: json['media'] as int,
      min: json['min'] as int,
      max: json['max'] as int,
    );
  }
}

import 'package:equatable/equatable.dart';

class GlycemiaEntity extends Equatable {
  const GlycemiaEntity({
    required this.id,
    required this.value,
    required this.moment,
    required this.recordedAt,
    required this.origin,
  });

  final int id;
  final int value;
  final String moment;
  final String recordedAt;
  final String origin;

  String get momentLabel {
    switch (moment) {
      case 'jejum':
        return 'Jejum';
      case 'pos_prandial':
        return 'Após refeição';
      default:
        return 'Aleatório';
    }
  }

  @override
  List<Object?> get props => [id, value, moment, recordedAt, origin];
}

class GlycemiaChartEntity extends Equatable {
  const GlycemiaChartEntity({
    required this.labels,
    required this.values,
    required this.average,
    required this.min,
    required this.max,
  });

  final List<String> labels;
  final List<int> values;
  final int average;
  final int min;
  final int max;

  @override
  List<Object?> get props => [labels, values, average, min, max];
}

class GlycemiaInput extends Equatable {
  const GlycemiaInput({
    required this.value,
    required this.moment,
    required this.recordedAt,
  });

  final int value;
  final String moment;
  final DateTime recordedAt;

  @override
  List<Object?> get props => [value, moment, recordedAt];
}

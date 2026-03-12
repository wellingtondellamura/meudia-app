part of 'glycemia_bloc.dart';

enum GlycemiaStatus { initial, loading, success, failure }

class GlycemiaState extends Equatable {
  const GlycemiaState({
    required this.status,
    required this.selectedPeriod,
    this.history = const [],
    this.chart = const GlycemiaChartEntity(
      labels: [],
      values: [],
      average: 0,
      min: 0,
      max: 0,
    ),
    this.failure,
    this.feedbackMessage,
    this.isSubmitting = false,
  });

  const GlycemiaState.initial()
      : this(status: GlycemiaStatus.initial, selectedPeriod: '7d');

  final GlycemiaStatus status;
  final String selectedPeriod;
  final List<GlycemiaEntity> history;
  final GlycemiaChartEntity chart;
  final Failure? failure;
  final String? feedbackMessage;
  final bool isSubmitting;

  GlycemiaState copyWith({
    GlycemiaStatus? status,
    String? selectedPeriod,
    List<GlycemiaEntity>? history,
    GlycemiaChartEntity? chart,
    Failure? failure,
    String? feedbackMessage,
    bool? isSubmitting,
    bool clearFeedback = false,
  }) {
    return GlycemiaState(
      status: status ?? this.status,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      history: history ?? this.history,
      chart: chart ?? this.chart,
      failure: clearFeedback ? null : failure ?? this.failure,
      feedbackMessage:
          clearFeedback ? null : feedbackMessage ?? this.feedbackMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedPeriod,
        history,
        chart,
        failure,
        feedbackMessage,
        isSubmitting,
      ];
}

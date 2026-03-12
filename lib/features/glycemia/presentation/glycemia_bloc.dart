import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import '../domain/glycemia_entities.dart';
import '../domain/glycemia_use_cases.dart';

part 'glycemia_event.dart';
part 'glycemia_state.dart';

class GlycemiaBloc extends Bloc<GlycemiaEvent, GlycemiaState> {
  GlycemiaBloc(
    this._getHistoryUseCase,
    this._getChartUseCase,
    this._registerUseCase,
  ) : super(const GlycemiaState.initial()) {
    on<GlycemiaStarted>(_onStarted);
    on<GlycemiaPeriodChanged>(_onPeriodChanged);
    on<GlycemiaSubmitted>(_onSubmitted);
  }

  final GetGlycemiaHistoryUseCase _getHistoryUseCase;
  final GetGlycemiaChartUseCase _getChartUseCase;
  final RegisterGlycemiaUseCase _registerUseCase;

  Future<void> _load(Emitter<GlycemiaState> emit, String period) async {
    emit(state.copyWith(status: GlycemiaStatus.loading, clearFeedback: true));
    final historyResult = await _getHistoryUseCase(period);
    final chartResult = await _getChartUseCase(period);
    final failure = historyResult.fold<Failure?>((l) => l, (_) => null) ??
        chartResult.fold<Failure?>((l) => l, (_) => null);
    if (failure != null) {
      emit(state.copyWith(status: GlycemiaStatus.failure, failure: failure));
      return;
    }
    emit(
        state.copyWith(
          status: GlycemiaStatus.success,
          history: historyResult.getOrElse(() => <GlycemiaEntity>[]),
          chart: chartResult.getOrElse(
            () => const GlycemiaChartEntity(
              labels: [],
              values: [],
              average: 0,
              min: 0,
              max: 0,
            ),
          ),
          selectedPeriod: period,
        ),
      );
  }

  Future<void> _onStarted(
    GlycemiaStarted event,
    Emitter<GlycemiaState> emit,
  ) async {
    await _load(emit, state.selectedPeriod);
  }

  Future<void> _onPeriodChanged(
    GlycemiaPeriodChanged event,
    Emitter<GlycemiaState> emit,
  ) async {
    await _load(emit, event.period);
  }

  Future<void> _onSubmitted(
    GlycemiaSubmitted event,
    Emitter<GlycemiaState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearFeedback: true));
    final result = await _registerUseCase(event.input);
    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            isSubmitting: false,
            failure: failure,
            status: GlycemiaStatus.failure,
          ),
        );
      },
      (_) async {
        emit(
          state.copyWith(
            isSubmitting: false,
            feedbackMessage: 'Glicemia registrada com sucesso!',
          ),
        );
        await _load(emit, state.selectedPeriod);
      },
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meudia_app/features/glycemia/data/glycemia_models.dart';
import 'package:meudia_app/features/glycemia/domain/glycemia_entities.dart';
import 'package:meudia_app/features/glycemia/domain/glycemia_repository.dart';
import 'package:meudia_app/features/glycemia/domain/glycemia_use_cases.dart';
import 'package:meudia_app/features/glycemia/presentation/glycemia_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockGlycemiaRepository extends Mock implements GlycemiaRepository {}

void main() {
  late GlycemiaRepository repository;
  late GlycemiaBloc bloc;
  late List<GlycemiaEntity> history;
  late GlycemiaChartEntity chart;
  late GlycemiaEntity registered;

  setUpAll(() {
    registerFallbackValue(
      GlycemiaInput(
        value: 100,
        moment: 'jejum',
        recordedAt: DateTime(2026, 1, 1),
      ),
    );
    final historyJson = jsonDecode(
      File('test/fixtures/glycemia_history.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    history = (historyJson['data'] as List<dynamic>)
        .map((item) => GlycemiaModel.fromJson(item as Map<String, dynamic>))
        .toList();
    final chartJson = jsonDecode(
      File('test/fixtures/glycemia_chart.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    chart = GlycemiaChartModel.fromJson(chartJson['data'] as Map<String, dynamic>);
    registered = history.first;
  });

  setUp(() {
    repository = _MockGlycemiaRepository();
    bloc = GlycemiaBloc(
      GetGlycemiaHistoryUseCase(repository),
      GetGlycemiaChartUseCase(repository),
      RegisterGlycemiaUseCase(repository),
    );
  });

  blocTest<GlycemiaBloc, GlycemiaState>(
    'loads history and chart on start',
    setUp: () {
      when(() => repository.getHistory(period: '7d')).thenAnswer((_) async => right(history));
      when(() => repository.getChart(period: '7d')).thenAnswer((_) async => right(chart));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const GlycemiaStarted()),
    expect: () => [
      const GlycemiaState(status: GlycemiaStatus.loading, selectedPeriod: '7d'),
      GlycemiaState(
        status: GlycemiaStatus.success,
        selectedPeriod: '7d',
        history: history,
        chart: chart,
      ),
    ],
  );

  blocTest<GlycemiaBloc, GlycemiaState>(
    'registers a new glycemia and reloads current period',
    setUp: () {
      when(() => repository.register(any())).thenAnswer((_) async => right(registered));
      when(() => repository.getHistory(period: '7d')).thenAnswer((_) async => right(history));
      when(() => repository.getChart(period: '7d')).thenAnswer((_) async => right(chart));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(
      GlycemiaSubmitted(
        GlycemiaInput(
          value: 145,
          moment: 'jejum',
          recordedAt: DateTime(2026, 2, 23, 7, 15),
        ),
      ),
    ),
    expect: () => [
      const GlycemiaState(
        status: GlycemiaStatus.initial,
        selectedPeriod: '7d',
        isSubmitting: true,
      ),
      const GlycemiaState(
        status: GlycemiaStatus.initial,
        selectedPeriod: '7d',
        feedbackMessage: 'Glicemia registrada com sucesso!',
      ),
      const GlycemiaState(status: GlycemiaStatus.loading, selectedPeriod: '7d'),
      GlycemiaState(
        status: GlycemiaStatus.success,
        selectedPeriod: '7d',
        history: history,
        chart: chart,
      ),
    ],
  );
}

import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meudia_app/features/dashboard/data/dashboard_models.dart';
import 'package:meudia_app/features/dashboard/domain/dashboard_entities.dart';
import 'package:meudia_app/features/dashboard/domain/dashboard_repository.dart';
import 'package:meudia_app/features/dashboard/domain/get_dashboard_use_case.dart';
import 'package:mocktail/mocktail.dart';

class _MockDashboardRepository extends Mock implements DashboardRepository {}

void main() {
  late DashboardRepository repository;
  late GetDashboardUseCase useCase;
  late DashboardEntity fixtureEntity;

  setUpAll(() {
    final json = jsonDecode(
      File('test/fixtures/dashboard.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    fixtureEntity = DashboardModel.fromJson(json['data'] as Map<String, dynamic>);
  });

  setUp(() {
    repository = _MockDashboardRepository();
    useCase = GetDashboardUseCase(repository);
  });

  test('returns dashboard entity from repository', () async {
    when(
      () => repository.getDashboard(),
    ).thenAnswer((_) async => Right(fixtureEntity));

    final result = await useCase();

    expect(result.isRight(), isTrue);
    expect(
      result.getOrElse(
        () => throw StateError('Expected dashboard fixture from repository'),
      ),
      fixtureEntity,
    );
    verify(() => repository.getDashboard()).called(1);
  });
}

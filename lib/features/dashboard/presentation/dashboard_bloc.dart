import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import '../domain/dashboard_entities.dart';
import '../domain/get_dashboard_use_case.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this._getDashboardUseCase)
      : super(const DashboardState.initial()) {
    on<DashboardLoaded>(_onLoaded);
  }

  final GetDashboardUseCase _getDashboardUseCase;

  Future<void> _onLoaded(
    DashboardLoaded event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading, clearFailure: true));
    final result = await _getDashboardUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(status: DashboardStatus.failure, failure: failure),
      ),
      (dashboard) => emit(
        state.copyWith(status: DashboardStatus.success, dashboard: dashboard),
      ),
    );
  }
}

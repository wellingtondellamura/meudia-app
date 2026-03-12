part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  const DashboardState({
    required this.status,
    this.dashboard,
    this.failure,
  });

  const DashboardState.initial() : this(status: DashboardStatus.initial);

  final DashboardStatus status;
  final DashboardEntity? dashboard;
  final Failure? failure;

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardEntity? dashboard,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return DashboardState(
      status: status ?? this.status,
      dashboard: dashboard ?? this.dashboard,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, dashboard, failure];
}

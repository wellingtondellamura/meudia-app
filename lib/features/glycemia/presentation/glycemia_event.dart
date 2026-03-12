part of 'glycemia_bloc.dart';

sealed class GlycemiaEvent extends Equatable {
  const GlycemiaEvent();

  @override
  List<Object?> get props => [];
}

class GlycemiaStarted extends GlycemiaEvent {
  const GlycemiaStarted();
}

class GlycemiaPeriodChanged extends GlycemiaEvent {
  const GlycemiaPeriodChanged(this.period);

  final String period;

  @override
  List<Object?> get props => [period];
}

class GlycemiaSubmitted extends GlycemiaEvent {
  const GlycemiaSubmitted(this.input);

  final GlycemiaInput input;

  @override
  List<Object?> get props => [input];
}

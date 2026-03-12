import 'package:equatable/equatable.dart';

class Failure extends Equatable implements Exception {
  const Failure(this.message, {this.code});

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code, this.details = const {}});

  final Map<String, dynamic> details;

  @override
  List<Object?> get props => [...super.props, details];
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message, {super.code});
}

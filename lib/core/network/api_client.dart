import 'package:dio/dio.dart';

import '../error/exceptions.dart';
import '../error/failures.dart';

class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _guard(
      () => _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      ),
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _guard(
      () => _dio.post<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
      ),
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<void> postVoid(String path, {Object? data}) async {
    await _guard(() => _dio.post<void>(path, data: data));
  }

  Future<Response<T>> _guard<T>(Future<Response<T>> Function() request) async {
    try {
      return await request();
    } on DioException catch (error) {
      final payload = error.response?.data;
      if (payload is Map<String, dynamic>) {
        final errorBody = payload['error'];
        if (errorBody is Map<String, dynamic>) {
          throw ApiException(
            message: _readMessage(errorBody) ?? 'Erro de rede.',
            statusCode: error.response?.statusCode,
            code: errorBody['code'] as String?,
            details: (errorBody['details'] as Map?)?.cast<String, dynamic>(),
          );
        }
        throw ApiException(
          message: _readMessage(payload) ?? error.message ?? 'Erro de rede.',
          statusCode: error.response?.statusCode,
          code: payload['code'] as String?,
          details: (payload['details'] as Map?)?.cast<String, dynamic>(),
        );
      }
      if (payload is String && payload.isNotEmpty) {
        throw ApiException(
          message: payload,
          statusCode: error.response?.statusCode,
        );
      }
      throw ApiException(
        message: _mapDioMessage(error),
        statusCode: error.response?.statusCode,
      );
    }
  }
}

String _mapDioMessage(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'A conexão expirou. Tente novamente.';
    case DioExceptionType.connectionError:
      return 'Sem conexão com o servidor. Verifique sua internet.';
    case DioExceptionType.badCertificate:
      return 'Não foi possível validar a conexão com o servidor.';
    case DioExceptionType.cancel:
      return 'A operação foi cancelada.';
    case DioExceptionType.badResponse:
    case DioExceptionType.unknown:
      return error.message ?? 'Erro de rede.';
  }
}

String? _readMessage(Map<String, dynamic> payload) {
  final message = payload['message'];
  if (message is String && message.trim().isNotEmpty) {
    return message;
  }

  final errors = payload['errors'];
  if (errors is Map) {
    for (final value in errors.values) {
      if (value is List && value.isNotEmpty) {
        final first = value.first;
        if (first is String && first.trim().isNotEmpty) {
          return first;
        }
      }
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
    }
  }

  return null;
}

Failure mapExceptionToFailure(Object exception) {
  if (exception is ApiException) {
    if (exception.statusCode == 401) {
      return UnauthorizedFailure(exception.message, code: exception.code);
    }
    if (exception.statusCode == 422) {
      return ValidationFailure(
        exception.message,
        code: exception.code,
        details: exception.details ?? <String, dynamic>{},
      );
    }
    return NetworkFailure(exception.message, code: exception.code);
  }
  if (exception is FormatException) {
    return NetworkFailure(exception.message);
  }
  return const NetworkFailure('Não foi possível concluir a operação.');
}

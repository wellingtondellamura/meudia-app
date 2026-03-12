import 'package:dio/dio.dart';

import 'session_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required SessionStorage sessionStorage,
    required Future<bool> Function() onUnauthorized,
  })  : _sessionStorage = sessionStorage,
        _onUnauthorized = onUnauthorized;

  final SessionStorage _sessionStorage;
  final Future<bool> Function() _onUnauthorized;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _sessionStorage.readToken();
    if (token != null && !options.path.endsWith('/login')) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _onUnauthorized();
    }
    handler.next(err);
  }
}

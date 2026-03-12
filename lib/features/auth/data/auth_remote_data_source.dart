import '../../../core/network/api_client.dart';
import 'auth_models.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._client);

  final ApiClient _client;

  Future<AuthSessionModel> login({
    required String email,
    required String password,
    required String deviceName,
  }) async {
    final response = await _client.post(
      '/login',
      data: {
        'email': email,
        'password': password,
        'device_name': deviceName,
      },
    );
    final payload = response['data'];
    if (payload is Map<String, dynamic>) {
      return AuthSessionModel.fromJson(payload);
    }
    return AuthSessionModel.fromJson(response);
  }

  Future<void> logout() => _client.postVoid('/logout');
}

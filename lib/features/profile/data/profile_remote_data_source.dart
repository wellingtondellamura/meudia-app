import '../../../core/network/api_client.dart';
import 'profile_models.dart';

class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._client);

  final ApiClient _client;

  Future<ProfileModel> getProfile() async {
    final response = await _client.get('/me');
    return ProfileModel.fromJson(response['data'] as Map<String, dynamic>);
  }
}

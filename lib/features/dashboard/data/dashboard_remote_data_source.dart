import '../../../core/network/api_client.dart';
import 'dashboard_models.dart';

class DashboardRemoteDataSource {
  const DashboardRemoteDataSource(this._client);

  final ApiClient _client;

  Future<DashboardModel> getDashboard() async {
    final response = await _client.get('/dashboard');
    return DashboardModel.fromJson(response['data'] as Map<String, dynamic>);
  }
}

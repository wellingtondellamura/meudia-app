import '../../../core/network/api_client.dart';
import '../domain/glycemia_entities.dart';
import 'glycemia_models.dart';

class GlycemiaRemoteDataSource {
  const GlycemiaRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<GlycemiaModel>> getHistory({required String period}) async {
    final response = await _client.get(
      '/glicemias',
      queryParameters: {'periodo': period},
    );
    return (response['data'] as List<dynamic>)
        .map((item) => GlycemiaModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<GlycemiaChartModel> getChart({required String period}) async {
    final response = await _client.get(
      '/glicemias/grafico',
      queryParameters: {'periodo': period},
    );
    return GlycemiaChartModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<GlycemiaModel> register(GlycemiaInput input) async {
    final response = await _client.post(
      '/glicemias',
      data: {
        'valor': input.value,
        'momento': input.moment,
        'registrado_em': input.recordedAt.toIso8601String(),
      },
    );
    return GlycemiaModel.fromJson(response['data'] as Map<String, dynamic>);
  }
}

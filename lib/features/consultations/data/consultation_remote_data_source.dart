import '../../../core/network/api_client.dart';
import 'consultation_models.dart';

class ConsultationRemoteDataSource {
  const ConsultationRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<ConsultationModel>> getConsultations() async {
    final response = await _client.get('/consultas');
    return (response['data'] as List<dynamic>)
        .map((item) => ConsultationModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> confirm(int id) => _client.postVoid('/consultas/$id/confirmar');

  Future<void> cancel(int id, {String? reason}) {
    return _client.postVoid('/consultas/$id/cancelar', data: {'motivo': reason});
  }

  Future<ConsultationModel> reschedule(int id, {required int slotId}) async {
    final response = await _client.post(
      '/consultas/$id/reagendar',
      data: {'novo_slot_id': slotId},
    );
    return ConsultationModel.fromJson(response['data'] as Map<String, dynamic>);
  }
}

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/auth_models.dart';

class SessionStorage {
  SessionStorage(this._secureStorage, this._preferences);

  static const _sessionKey = 'meudia.auth.session';

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _preferences;

  Future<void> saveSession(AuthSessionModel session) async {
    await _secureStorage.write(
      key: _sessionKey,
      value: jsonEncode(session.toJson()),
    );
    await _preferences.setBool('meudia.has_session', true);
  }

  Future<AuthSessionModel?> readSession() async {
    final raw = await _secureStorage.read(key: _sessionKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return AuthSessionModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<String?> readToken() async => (await readSession())?.token;

  Future<void> clear() async {
    await _secureStorage.delete(key: _sessionKey);
    await _preferences.remove('meudia.has_session');
  }
}

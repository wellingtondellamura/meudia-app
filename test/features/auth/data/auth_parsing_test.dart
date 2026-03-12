import 'package:flutter_test/flutter_test.dart';
import 'package:meudia_app/core/network/api_client.dart';
import 'package:meudia_app/features/auth/data/auth_models.dart';

void main() {
  group('AuthSessionModel.fromJson', () {
    test('parses the current expected shape', () {
      final session = AuthSessionModel.fromJson({
        'token': 'abc',
        'user': {'id': 1, 'name': 'Maria', 'email': 'maria@example.com'},
      });

      expect(session.token, 'abc');
      expect(session.user.id, 1);
      expect(session.user.name, 'Maria');
      expect(session.user.email, 'maria@example.com');
    });

    test('parses alternative backend keys', () {
      final session = AuthSessionModel.fromJson({
        'access_token': 'abc',
        'usuario': {'id': '7', 'nome': 'Joao', 'login': 'joao@example.com'},
      });

      expect(session.token, 'abc');
      expect(session.user.id, 7);
      expect(session.user.name, 'Joao');
      expect(session.user.email, 'joao@example.com');
    });

    test('throws a clear format exception for invalid login responses', () {
      expect(
        () => AuthSessionModel.fromJson({'foo': 'bar'}),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            'Resposta de login invalida.',
          ),
        ),
      );
    });
  });

  group('mapExceptionToFailure', () {
    test('converts format exceptions into a readable failure', () {
      final failure = mapExceptionToFailure(
        const FormatException('Resposta de login invalida.'),
      );

      expect(failure.message, 'Resposta de login invalida.');
    });
  });
}

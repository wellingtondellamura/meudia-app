import '../domain/auth_entities.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final id = switch (rawId) {
      int value => value,
      num value => value.toInt(),
      String value => int.tryParse(value),
      _ => null,
    };
    final name =
        json['name'] as String? ??
        json['full_name'] as String? ??
        json['nome'] as String?;
    final email =
        json['email'] as String? ??
        json['login'] as String? ??
        json['username'] as String?;

    if (id == null || name == null || email == null) {
      throw const FormatException('Resposta de usuario invalida.');
    }

    return UserModel(
      id: id,
      name: name,
      email: email,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};
}

class AuthSessionModel extends AuthEntity {
  const AuthSessionModel({
    required super.token,
    required UserModel super.user,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    final token =
        json['token'] as String? ??
        json['access_token'] as String? ??
        json['plainTextToken'] as String?;
    final userJson =
        json['user'] as Map<String, dynamic>? ??
        json['usuario'] as Map<String, dynamic>? ??
        json['patient'] as Map<String, dynamic>?;

    if (token == null || userJson == null) {
      throw const FormatException('Resposta de login invalida.');
    }

    return AuthSessionModel(
      token: token,
      user: UserModel.fromJson(userJson),
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'user': (user as UserModel).toJson(),
      };
}

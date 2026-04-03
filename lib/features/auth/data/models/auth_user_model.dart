import '../../domain/entities/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  const AuthUserModel({
    required super.id,
    required super.email,
    required super.isAuthenticated,
    super.displayName,
    super.photoUrl,
  });

  factory AuthUserModel.fromJson(Map<String, Object?> json) {
    return AuthUserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      isAuthenticated: json['isAuthenticated'] as bool? ?? false,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'email': email,
      'isAuthenticated': isAuthenticated,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }
}

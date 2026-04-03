import 'package:equatable/equatable.dart';

class AuthUserEntity extends Equatable {
  const AuthUserEntity({
    required this.id,
    required this.email,
    required this.isAuthenticated,
    this.displayName,
    this.photoUrl,
  });

  final String id;
  final String email;
  final bool isAuthenticated;
  final String? displayName;
  final String? photoUrl;

  /// Shown in UI when a formal name is missing.
  String get displayLabel {
    final n = displayName?.trim();
    if (n != null && n.isNotEmpty) return n;
    if (email.isNotEmpty) {
      final at = email.indexOf('@');
      return at > 0 ? email.substring(0, at) : email;
    }
    return 'Player';
  }

  @override
  List<Object?> get props => [id, email, isAuthenticated, displayName, photoUrl];
}

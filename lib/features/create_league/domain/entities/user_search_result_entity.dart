import 'package:equatable/equatable.dart';

class UserSearchResultEntity extends Equatable {
  const UserSearchResultEntity({
    required this.id,
    required this.displayName,
    this.email,
  });

  final String id;
  final String displayName;
  final String? email;

  String get subtitle {
    if (email != null && email!.isNotEmpty) return email!;
    return 'KickOff player';
  }

  @override
  List<Object?> get props => [id, displayName, email];
}

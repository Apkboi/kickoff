import 'package:equatable/equatable.dart';

class LeagueAdminEntity extends Equatable {
  const LeagueAdminEntity({
    required this.name,
    required this.role,
    required this.tag,
  });

  final String name;
  final String role;
  final String tag;

  @override
  List<Object?> get props => [name, role, tag];
}

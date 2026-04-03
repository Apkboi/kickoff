import 'package:equatable/equatable.dart';

class LeagueParticipantDraft extends Equatable {
  const LeagueParticipantDraft({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.isTeam,
    this.isAdmin = false,
    this.playsInLeague = true,
  });

  final String id;
  final String name;
  final String subtitle;
  final bool isTeam;
  final bool isAdmin;

  /// When false, member is organizer/admin only (fixtures & standings exclude them).
  final bool playsInLeague;

  LeagueParticipantDraft copyWith({
    String? id,
    String? name,
    String? subtitle,
    bool? isTeam,
    bool? isAdmin,
    bool? playsInLeague,
  }) {
    return LeagueParticipantDraft(
      id: id ?? this.id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      isTeam: isTeam ?? this.isTeam,
      isAdmin: isAdmin ?? this.isAdmin,
      playsInLeague: playsInLeague ?? this.playsInLeague,
    );
  }

  @override
  List<Object?> get props => [id, name, subtitle, isTeam, isAdmin, playsInLeague];
}

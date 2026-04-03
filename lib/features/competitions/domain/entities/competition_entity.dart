import 'package:equatable/equatable.dart';

import 'league_card_status.dart';

class CompetitionEntity extends Equatable {
  const CompetitionEntity({
    required this.id,
    required this.name,
    required this.teamCount,
    required this.matchdayLabel,
    required this.status,
    this.maxParticipants = 32,
    this.xpPoolLabel,
    this.showMeBadge = false,
    this.logoUrl,
    this.bannerUrl,
  });

  final String id;
  final String name;
  final int teamCount;
  /// Capacity from Firestore `maxParticipants` (defaults to 32 when missing).
  final int maxParticipants;
  final String matchdayLabel;
  final LeagueCardStatus status;
  final String? xpPoolLabel;
  final bool showMeBadge;
  final String? logoUrl;
  final String? bannerUrl;

  @override
  List<Object?> get props => [
        id,
        name,
        teamCount,
        matchdayLabel,
        status,
        maxParticipants,
        xpPoolLabel,
        showMeBadge,
        logoUrl,
        bannerUrl,
      ];
}

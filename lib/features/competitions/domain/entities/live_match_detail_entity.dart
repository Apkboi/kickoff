import 'package:equatable/equatable.dart';

import 'manage_match_event_entity.dart';

class LiveMatchDetailEntity extends Equatable {
  const LiveMatchDetailEntity({
    required this.matchId,
    required this.matchTitle,
    required this.homeName,
    required this.awayName,
    required this.homeScore,
    required this.awayScore,
    required this.matchClock,
    required this.statusLabel,
    required this.isLive,
    required this.venueLine,
    required this.streamUrl,
    required this.recentEvents,
    this.kickoffAt,
    this.matchStatusRaw = '',
  });

  final String matchId;
  final String matchTitle;
  final String homeName;
  final String awayName;
  final int homeScore;
  final int awayScore;
  final String matchClock;
  final String statusLabel;
  final bool isLive;
  final String venueLine;
  final String? streamUrl;
  final List<ManageMatchEventEntity> recentEvents;

  /// Scheduled kickoff (UTC or local); null when not set.
  final DateTime? kickoffAt;

  /// Raw Firestore `status` value (e.g. `live`, `scheduled`, `ft`).
  final String matchStatusRaw;

  @override
  List<Object?> get props => [
        matchId,
        matchTitle,
        homeName,
        awayName,
        homeScore,
        awayScore,
        matchClock,
        statusLabel,
        isLive,
        venueLine,
        streamUrl,
        recentEvents,
        kickoffAt,
        matchStatusRaw,
      ];
}

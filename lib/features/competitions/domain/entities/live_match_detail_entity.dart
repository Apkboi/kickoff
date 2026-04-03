import 'package:equatable/equatable.dart';

import '../../../../core/models/stream_link.dart';
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
    this.streamLinks = const [],
    required this.recentEvents,
    this.kickoffAt,
    this.startedAt,
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
  final List<StreamLink> streamLinks;
  final List<ManageMatchEventEntity> recentEvents;

  /// Scheduled kickoff (UTC or local); null when not set.
  final DateTime? kickoffAt;

  /// When the match went live (may mirror [kickoffAt] after start).
  final DateTime? startedAt;

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
        streamLinks,
        recentEvents,
        kickoffAt,
        startedAt,
        matchStatusRaw,
      ];
}

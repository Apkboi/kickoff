import '../../domain/entities/competition_entity.dart';
import '../../domain/entities/league_card_status.dart';

class CompetitionModel extends CompetitionEntity {
  const CompetitionModel({
    required super.id,
    required super.name,
    required super.teamCount,
    required super.matchdayLabel,
    required super.status,
    super.maxParticipants = 32,
    super.xpPoolLabel,
    super.showMeBadge,
    super.logoUrl,
    super.bannerUrl,
  });

  factory CompetitionModel.fromJson(Map<String, Object?> json) {
    return CompetitionModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      teamCount: json['teamCount'] as int? ?? 0,
      matchdayLabel: json['matchdayLabel'] as String? ?? 'Matchday 1',
      status: _statusFromJson(json['status'] as String?),
      maxParticipants: json['maxParticipants'] as int? ?? 32,
      xpPoolLabel: json['xpPoolLabel'] as String?,
      showMeBadge: json['showMeBadge'] as bool? ?? false,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'teamCount': teamCount,
      'matchdayLabel': matchdayLabel,
      'status': status.name,
      'maxParticipants': maxParticipants,
      'xpPoolLabel': xpPoolLabel,
      'showMeBadge': showMeBadge,
    };
  }

  static LeagueCardStatus _statusFromJson(String? raw) {
    if (raw == null) return LeagueCardStatus.live;
    for (final v in LeagueCardStatus.values) {
      if (v.name == raw) return v;
    }
    return LeagueCardStatus.live;
  }
}

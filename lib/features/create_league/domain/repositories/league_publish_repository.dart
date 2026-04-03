import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/league_format.dart';
import '../entities/league_participant_draft.dart';

class PublishLeagueParams {
  const PublishLeagueParams({
    required this.leagueName,
    required this.sport,
    required this.format,
    required this.automateFixtures,
    required this.creatorId,
    required this.creatorDisplayName,
    required this.invitedParticipants,
    required this.invitedAdmins,
    required this.soloMatchCount,
    this.creatorJoinsAsParticipant = false,
    this.endDate,
    this.prizePool,
    this.logoUrl,
    this.bannerUrl,
    this.maxParticipants = 32,
  });

  final String leagueName;
  final String sport;
  final LeagueFormat format;
  final bool automateFixtures;
  final String creatorId;
  final String creatorDisplayName;
  final List<LeagueParticipantDraft> invitedParticipants;
  final List<LeagueParticipantDraft> invitedAdmins;
  final int soloMatchCount;

  /// When true, creator is included in fixtures/standings; when false, organizer only (still admin).
  final bool creatorJoinsAsParticipant;
  final DateTime? endDate;
  final double? prizePool;
  final String? logoUrl;
  final String? bannerUrl;
  final int maxParticipants;
}

abstract class LeaguePublishRepository {
  Future<Either<Failure, String>> publish(PublishLeagueParams params);
}

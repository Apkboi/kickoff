import '../entities/league_format.dart';

/// Validates [playingParticipantCount] for publish based on [format] and automation.
abstract final class LeagueCreatePlayingCountPolicy {
  static String? publishError({
    required LeagueFormat format,
    required int playingParticipantCount,
    required bool automateFixtures,
  }) {
    if (format == LeagueFormat.solo) {
      return playingParticipantCount == 2
          ? null
          : '1v1 format requires exactly 2 players. Adjust invites or “Join as participant”.';
    }
    if (!automateFixtures) {
      return null;
    }
    if (playingParticipantCount < 2) {
      return 'Automated fixtures need at least 2 players.';
    }
    if (format == LeagueFormat.knockout && playingParticipantCount % 2 != 0) {
      return 'Knockout format needs an even number of players for the first round.';
    }
    return null;
  }
}

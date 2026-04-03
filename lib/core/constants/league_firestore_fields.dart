/// Firestore field names for `leagues/{id}` and subcollections.
abstract final class LeagueFirestoreFields {
  static const name = 'name';
  static const sport = 'sport';
  static const format = 'format';
  static const automateFixtures = 'automateFixtures';
  static const creatorId = 'creatorId';
  static const logoUrl = 'logoUrl';
  static const bannerUrl = 'bannerUrl';
  static const prizePool = 'prizePool';
  static const endDate = 'endDate';
  static const location = 'location';
  static const maxParticipants = 'maxParticipants';
  static const participantCount = 'participantCount';
  static const published = 'published';
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
  static const entryFeeUsd = 'entryFeeUsd';

  /// `active` | `completed`
  static const leagueStatus = 'leagueStatus';
  static const winnerDisplayName = 'winnerDisplayName';
  static const completedAt = 'completedAt';

  static const userId = 'userId';
  static const displayName = 'displayName';
  static const isAdmin = 'isAdmin';
  static const isTeam = 'isTeam';
  static const playsInLeague = 'playsInLeague';
  static const joinedAt = 'joinedAt';

  static const round = 'round';
  static const matchWeek = 'matchWeek';
  static const kickoffAt = 'kickoffAt';
  static const homeId = 'homeId';
  static const awayId = 'awayId';
  static const homeName = 'homeName';
  static const awayName = 'awayName';
  static const status = 'status';
  static const matchIndex = 'matchIndex';
  static const homeScore = 'homeScore';
  static const awayScore = 'awayScore';
  static const startedAt = 'startedAt';
  static const endedAt = 'endedAt';
  static const streamUrl = 'streamUrl';

  static const participantId = 'participantId';
  static const played = 'played';
  static const won = 'won';
  static const drawn = 'drawn';
  static const lost = 'lost';
  static const goalsFor = 'goalsFor';
  static const goalsAgainst = 'goalsAgainst';
  static const points = 'points';

  // Match event fields stored under `leagues/{id}/fixtures/{matchId}/events/{eventId}`.
  static const eventKind = 'kind';
  static const eventPlayerName = 'playerName';
  static const eventMinuteLabel = 'minuteLabel';
  static const eventTitle = 'title';
  static const eventSubtitle = 'subtitle';
}

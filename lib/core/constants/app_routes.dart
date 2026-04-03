abstract final class AppRoutes {
  static const String home = '/';
  static const String competitions = '/competitions';

  /// Navigates to `/competitions/[id]` (league detail).
  static String competitionDetailPath(String competitionId) => '$competitions/$competitionId';

  /// League admin: live scoring & events at `/competitions/[id]/manage`.
  static String manageLeaguePath(String competitionId) => '$competitions/$competitionId/manage';

  /// Read-only live match view with realtime updates.
  static String matchDetailPath(String competitionId, String matchId) =>
      '$competitions/$competitionId/matches/$matchId';
  static String competitionFixturesPath(String competitionId) => '$competitions/$competitionId/fixtures';
  static String manageLeagueFixturesPath(String competitionId) => '$competitions/$competitionId/manage/fixtures';
  static const String createLeague = '/create-league';
  static const String explore = '/explore';
  static const String schedule = '/schedule';
  static const String profile = '/profile';
  static const String users = '/users';

  static String userProfilePath(String userId) => '$users/$userId';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
}

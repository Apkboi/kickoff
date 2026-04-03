import '../../domain/entities/league_format.dart';

abstract final class LeagueFormatUi {
  static String title(LeagueFormat f) {
    return switch (f) {
      LeagueFormat.knockout => 'Knockout',
      LeagueFormat.solo => 'Solo',
      LeagueFormat.standard => 'Standard',
    };
  }

  static String subtitle(LeagueFormat f) {
    return switch (f) {
      LeagueFormat.knockout => 'Single elimination brackets. High stakes.',
      LeagueFormat.solo => '1v1 Matches. Perfect for individuals.',
      LeagueFormat.standard => 'Round-robin points system. Seasonal.',
    };
  }

  static String previewLabel(LeagueFormat f) {
    return switch (f) {
      LeagueFormat.knockout => 'KNOCKOUT',
      LeagueFormat.solo => 'SOLO',
      LeagueFormat.standard => 'STANDARD',
    };
  }
}

import '../../../core/constants/league_firestore_fields.dart';
import '../../../core/utils/app_currency_format.dart';
import '../domain/entities/explore_league_card_entity.dart';
import '../domain/entities/explore_sport.dart';

abstract final class ExploreLeagueMapper {
  static ExploreSport sportFromString(String raw) {
    final s = raw.toLowerCase();
    if (s.contains('basket')) return ExploreSport.basketball;
    if (s.contains('tennis')) return ExploreSport.tennis;
    return ExploreSport.soccer;
  }

  static int accentForSport(ExploreSport s) {
    switch (s) {
      case ExploreSport.basketball:
        return 1;
      case ExploreSport.tennis:
        return 0;
      case ExploreSport.soccer:
        return 0;
    }
  }

  static ExploreLeagueCardEntity fromMap(String id, Map<String, dynamic> data) {
    final title = data['name'] as String? ?? 'League';
    final sportLabel = (data['sport'] as String? ?? 'Football').toUpperCase();
    final sport = sportFromString(data['sport'] as String? ?? '');
    final fmt = data['format'] as String? ?? 'standard';
    final knockout = fmt == 'knockout';
    final standardLeague = fmt == 'standard' || fmt == 'solo';
    final participantCount = (data['participantCount'] as num?)?.toInt() ?? 0;
    final maxP = (data['maxParticipants'] as num?)?.toInt() ?? 32;
    final prize = data['prizePool'] as num?;
    final logoRaw = (data[LeagueFirestoreFields.logoUrl] as String?)?.trim();
    final bannerRaw = (data[LeagueFirestoreFields.bannerUrl] as String?)?.trim();

    return ExploreLeagueCardEntity(
      id: id,
      title: title,
      sportTag: sportLabel.length > 12 ? sportLabel.substring(0, 12) : sportLabel,
      sport: sport,
      location: data['location'] as String? ?? 'Online',
      footerLeftLabel: 'PRIZE POOL',
      footerLeftValue: prize != null ? AppCurrencyFormat.naira(prize) : '—',
      footerRightLabel: 'TEAMS',
      footerRightValue: '$participantCount / $maxP',
      sportAccentIndex: accentForSport(sport),
      filterMeta: ExploreLeagueFilterMeta(
        sport: sport,
        standardLeague: standardLeague,
        tournament: fmt != 'standard',
        knockout: knockout,
        registrationOpen: true,
        liveNow: false,
        startingSoon: true,
        entryFeeUsd: (data['entryFeeUsd'] as num?)?.toDouble() ?? 0,
      ),
      logoUrl: logoRaw != null && logoRaw.isNotEmpty ? logoRaw : null,
      bannerUrl: bannerRaw != null && bannerRaw.isNotEmpty ? bannerRaw : null,
    );
  }
}

import '../domain/entities/explore_feed_entity.dart';
import '../domain/entities/explore_league_card_entity.dart';
import '../domain/entities/explore_sport.dart';
import '../domain/entities/explore_suggested_row_entity.dart';

/// Fallback content when no published leagues exist in Firestore.
abstract final class ExploreMockFeed {
  static ExploreFeedEntity build() {
    const grid = <ExploreLeagueCardEntity>[
      ExploreLeagueCardEntity(
        id: 'epl-1',
        title: 'Champions Elite League',
        sportTag: 'SOCCER',
        sport: ExploreSport.soccer,
        location: 'London, United Kingdom',
        footerLeftLabel: 'PRIZE POOL',
        footerLeftValue: r'₦5,000',
        footerRightLabel: 'TEAMS',
        footerRightValue: '14 / 16',
        sportAccentIndex: 0,
        filterMeta: ExploreLeagueFilterMeta(
          sport: ExploreSport.soccer,
          standardLeague: true,
          tournament: false,
          knockout: false,
          registrationOpen: true,
          liveNow: false,
          startingSoon: true,
          entryFeeUsd: 50,
        ),
      ),
      ExploreLeagueCardEntity(
        id: 'cgc-2',
        title: 'Urban Hoop Classic',
        sportTag: 'BASKETBALL',
        sport: ExploreSport.basketball,
        location: 'Brooklyn, USA',
        footerLeftLabel: 'PRIZE POOL',
        footerLeftValue: r'₦2,500',
        footerRightLabel: 'FORMAT',
        footerRightValue: '5 vs 5',
        sportAccentIndex: 1,
        filterMeta: ExploreLeagueFilterMeta(
          sport: ExploreSport.basketball,
          standardLeague: true,
          tournament: false,
          knockout: false,
          registrationOpen: true,
          liveNow: false,
          startingSoon: true,
          entryFeeUsd: 40,
        ),
      ),
      ExploreLeagueCardEntity(
        id: 'lwp-3',
        title: 'Grand Clay Open',
        sportTag: 'TENNIS',
        sport: ExploreSport.tennis,
        location: 'Paris, France',
        footerLeftLabel: 'PRIZE POOL',
        footerLeftValue: r'₦1,200',
        footerRightLabel: 'TYPE',
        footerRightValue: 'Singles',
        sportAccentIndex: 0,
        filterMeta: ExploreLeagueFilterMeta(
          sport: ExploreSport.tennis,
          standardLeague: false,
          tournament: true,
          knockout: false,
          registrationOpen: true,
          liveNow: false,
          startingSoon: true,
          entryFeeUsd: 120,
        ),
      ),
    ];

    final trending = <ExploreLeagueCardEntity>[
      grid[0].copyWith(
        isLive: true,
        trendingSubtitle: 'CHAMPIONS ELITE',
        trendingTitleLarge: 'PRO SEASON 24',
      ),
      grid[1].copyWith(
        trendingSubtitle: 'URBAN HOOP',
        trendingTitleLarge: 'CLASSIC 24',
      ),
    ];

    const suggested = <ExploreSuggestedRowEntity>[
      ExploreSuggestedRowEntity(
        leagueId: 'epl-1',
        categoryLine: 'TENNIS • SOLO',
        title: 'Emerald Open Championship',
        statusLine: '48/64 Joined',
        isFull: false,
        thumbnailIndex: 0,
      ),
      ExploreSuggestedRowEntity(
        leagueId: 'cgc-2',
        categoryLine: 'FOOTBALL • 5V5',
        title: 'Night Kickoff League',
        statusLine: 'FULL',
        isFull: true,
        thumbnailIndex: 1,
      ),
    ];

    return ExploreFeedEntity(gridLeagues: grid, trending: trending, suggested: suggested);
  }
}

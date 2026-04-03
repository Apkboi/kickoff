import 'package:equatable/equatable.dart';

import 'explore_sport.dart';

/// Client-side filter metadata (mock / Firestore later).
class ExploreLeagueFilterMeta extends Equatable {
  const ExploreLeagueFilterMeta({
    required this.sport,
    required this.standardLeague,
    required this.tournament,
    required this.knockout,
    required this.registrationOpen,
    required this.liveNow,
    required this.startingSoon,
    required this.entryFeeUsd,
  });

  final ExploreSport sport;
  final bool standardLeague;
  final bool tournament;
  final bool knockout;
  final bool registrationOpen;
  final bool liveNow;
  final bool startingSoon;
  final double entryFeeUsd;

  @override
  List<Object?> get props => [
        sport,
        standardLeague,
        tournament,
        knockout,
        registrationOpen,
        liveNow,
        startingSoon,
        entryFeeUsd,
      ];
}

/// Card for grid / trending carousel (desktop + mobile).
class ExploreLeagueCardEntity extends Equatable {
  const ExploreLeagueCardEntity({
    required this.id,
    required this.title,
    required this.sportTag,
    required this.sport,
    required this.location,
    required this.footerLeftLabel,
    required this.footerLeftValue,
    required this.footerRightLabel,
    required this.footerRightValue,
    required this.sportAccentIndex,
    required this.filterMeta,
    this.isLive = false,
    this.trendingSubtitle,
    this.trendingTitleLarge,
    this.logoUrl,
    this.bannerUrl,
  });

  final String id;
  final String title;
  final String sportTag;
  final ExploreSport sport;
  final String location;
  final String footerLeftLabel;
  final String footerLeftValue;
  final String footerRightLabel;
  final String footerRightValue;
  /// 0 = green tag, 1 = amber (basketball), etc.
  final int sportAccentIndex;
  final ExploreLeagueFilterMeta filterMeta;
  final bool isLive;
  final String? trendingSubtitle;
  final String? trendingTitleLarge;
  final String? logoUrl;
  final String? bannerUrl;

  ExploreLeagueCardEntity copyWith({
    bool? isLive,
    String? trendingSubtitle,
    String? trendingTitleLarge,
    String? logoUrl,
    String? bannerUrl,
  }) {
    return ExploreLeagueCardEntity(
      id: id,
      title: title,
      sportTag: sportTag,
      sport: sport,
      location: location,
      footerLeftLabel: footerLeftLabel,
      footerLeftValue: footerLeftValue,
      footerRightLabel: footerRightLabel,
      footerRightValue: footerRightValue,
      sportAccentIndex: sportAccentIndex,
      filterMeta: filterMeta,
      isLive: isLive ?? this.isLive,
      trendingSubtitle: trendingSubtitle ?? this.trendingSubtitle,
      trendingTitleLarge: trendingTitleLarge ?? this.trendingTitleLarge,
      logoUrl: logoUrl ?? this.logoUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        sportTag,
        sport,
        location,
        footerLeftLabel,
        footerLeftValue,
        footerRightLabel,
        footerRightValue,
        sportAccentIndex,
        filterMeta,
        isLive,
        trendingSubtitle,
        trendingTitleLarge,
        logoUrl,
        bannerUrl,
      ];
}

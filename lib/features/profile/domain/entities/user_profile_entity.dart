import 'package:equatable/equatable.dart';

class ProfileStatItem extends Equatable {
  const ProfileStatItem({
    required this.label,
    required this.value,
    this.emphasizeValue = false,
    this.goldValue = false,
    this.progress,
  });

  final String label;
  final String value;
  final bool emphasizeValue;
  final bool goldValue;
  final double? progress;

  @override
  List<Object?> get props => [label, value, emphasizeValue, goldValue, progress];
}

class ProfileSportSection extends Equatable {
  const ProfileSportSection({
    required this.sportName,
    required this.roleLabel,
    required this.rankBadge,
    required this.rankBadgeGold,
    required this.isPrimary,
    required this.stats,
    this.showViewAnalytics = false,
  });

  final String sportName;
  final String roleLabel;
  final String rankBadge;
  final bool rankBadgeGold;
  final bool isPrimary;
  final List<ProfileStatItem> stats;
  final bool showViewAnalytics;

  @override
  List<Object?> get props => [sportName, roleLabel, rankBadge, rankBadgeGold, isPrimary, stats, showViewAnalytics];
}

class ProfileAchievement extends Equatable {
  const ProfileAchievement({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  List<Object?> get props => [title, description];
}

class UserProfileEntity extends Equatable {
  const UserProfileEntity({
    required this.displayName,
    required this.locationLine,
    required this.tagline,
    required this.level,
    required this.xpCurrent,
    required this.xpToNext,
    required this.bio,
    required this.matches,
    required this.wins,
    required this.leaguesJoined,
    required this.sports,
    required this.achievement,
    this.streakDays = 12,
    this.photoUrl,
  });

  final String? photoUrl;
  final String displayName;
  final String locationLine;
  final String tagline;
  final int level;
  final int xpCurrent;
  final int xpToNext;
  final String bio;
  final int matches;
  final int wins;
  final int leaguesJoined;
  final List<ProfileSportSection> sports;
  final ProfileAchievement achievement;
  final int streakDays;

  double get xpProgress => xpToNext > 0 ? xpCurrent / xpToNext : 0;

  @override
  List<Object?> get props => [
        displayName,
        locationLine,
        tagline,
        level,
        xpCurrent,
        xpToNext,
        bio,
        matches,
        wins,
        leaguesJoined,
        sports,
        achievement,
        streakDays,
        photoUrl,
      ];
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/user_firestore_fields.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.displayName,
    required super.locationLine,
    required super.tagline,
    required super.level,
    required super.xpCurrent,
    required super.xpToNext,
    required super.bio,
    required super.matches,
    required super.wins,
    required super.leaguesJoined,
    required super.sports,
    required super.achievement,
    super.streakDays,
    super.photoUrl,
  });

  factory UserProfileModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final data = snap.data();
    if (data == null) {
      throw const ProfileNotFoundException();
    }
    final xpPoints = (data['xpPoints'] as num?)?.toInt() ?? 0;
    final level = (xpPoints ~/ 1000) + 1;
    final xpCurrent = xpPoints % 1000;
    const xpToNext = 1000;
    final rawName = (data['displayName'] as String?)?.trim();
    final role = ((data['role'] as String?) ?? 'player').trim();
    final membershipTier = ((data['membershipTier'] as String?) ?? 'free').trim();
    final bioRaw = (data['bio'] as String?)?.trim() ?? '';
    final bio = bioRaw.isNotEmpty
        ? bioRaw
        : 'Tell the community about your game and goals.';
    final locationRaw = (data['location'] as String?)?.trim() ?? '';
    final locationLine =
        locationRaw.isNotEmpty ? locationRaw : 'Location not set';

    final photoRaw = (data[UserFirestoreFields.photoUrl] as String?)?.trim();
    final photoUrl = photoRaw != null && photoRaw.isNotEmpty ? photoRaw : null;

    return UserProfileModel(
      displayName: rawName != null && rawName.isNotEmpty ? rawName : 'Player',
      locationLine: locationLine,
      tagline: _formatRole(role),
      level: level,
      xpCurrent: xpCurrent,
      xpToNext: xpToNext,
      bio: bio,
      matches: (data['matchesPlayed'] as num?)?.toInt() ?? 0,
      wins: (data['wins'] as num?)?.toInt() ?? 0,
      leaguesJoined: (data['leaguesJoined'] as num?)?.toInt() ?? 0,
      streakDays: (data['streakDays'] as num?)?.toInt() ?? 0,
      sports: const [],
      achievement: ProfileAchievement(
        title: 'KickOff member',
        description: _membershipDescription(membershipTier),
      ),
      photoUrl: photoUrl,
    );
  }

  static String _formatRole(String role) {
    if (role.isEmpty) return 'Player';
    return '${role[0].toUpperCase()}${role.length > 1 ? role.substring(1).toLowerCase() : ''}';
  }

  static String _membershipDescription(String tier) {
    final label = switch (tier.toLowerCase()) {
      'pro' => 'Pro',
      'premium' => 'Premium',
      _ => 'Free',
    };
    return 'Your $label membership is active. Play matches to earn XP and badges.';
  }
}

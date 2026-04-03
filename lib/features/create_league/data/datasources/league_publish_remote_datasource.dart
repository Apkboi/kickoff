import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/constants/league_firestore_fields.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/league_format.dart';
import '../../domain/entities/league_participant_draft.dart';
import '../../domain/utils/league_schedule_generator.dart';

abstract class LeaguePublishRemoteDataSource {
  Future<String> publishLeague({
    required String leagueName,
    required String sport,
    required LeagueFormat format,
    required bool automateFixtures,
    required String creatorId,
    required String creatorDisplayName,
    required List<LeagueParticipantDraft> invitedParticipants,
    required List<LeagueParticipantDraft> invitedAdmins,
    required int soloMatchCount,
    required bool creatorJoinsAsParticipant,
    required DateTime? endDate,
    required double? prizePool,
    required String? logoUrl,
    required String? bannerUrl,
    required int maxParticipants,
  });
}

class LeaguePublishRemoteDataSourceImpl implements LeaguePublishRemoteDataSource {
  LeaguePublishRemoteDataSourceImpl(
    this._firestore, {
    FirebaseAuth? auth,
  }) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  static const _members = 'members';
  static const _fixtures = 'fixtures';
  static const _standings = 'standings';

  static const _maxBatchOps = 450;

  @override
  Future<String> publishLeague({
    required String leagueName,
    required String sport,
    required LeagueFormat format,
    required bool automateFixtures,
    required String creatorId,
    required String creatorDisplayName,
    required List<LeagueParticipantDraft> invitedParticipants,
    required List<LeagueParticipantDraft> invitedAdmins,
    required int soloMatchCount,
    required bool creatorJoinsAsParticipant,
    required DateTime? endDate,
    required double? prizePool,
    required String? logoUrl,
    required String? bannerUrl,
    required int maxParticipants,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.uid != creatorId) {
      throw const FirebaseDataException('Not signed in');
    }
    try {
      final leagueRef = _firestore.collection(FirestoreCollections.leagues).doc();
      final leagueId = leagueRef.id;

      final merged = _mergeMembers(
        creatorId: creatorId,
        creatorName: creatorDisplayName,
        invitedPlayers: invitedParticipants,
        invitedAdmins: invitedAdmins,
        creatorJoinsAsParticipant: creatorJoinsAsParticipant,
      );

      final playingMembers = merged.where((m) => m.playsInLeague).toList();

      final fixtures = LeagueScheduleGenerator.buildFixtures(
        format: format,
        automateFixtures: automateFixtures,
        members: playingMembers,
        soloMatchCount: soloMatchCount,
      );
      final standingRows = LeagueScheduleGenerator.standingsForMembers(playingMembers);

      final now = FieldValue.serverTimestamp();
      final leagueData = <String, dynamic>{
        LeagueFirestoreFields.name: leagueName.trim(),
        LeagueFirestoreFields.sport: sport,
        LeagueFirestoreFields.format: format.name,
        LeagueFirestoreFields.automateFixtures: automateFixtures,
        LeagueFirestoreFields.creatorId: creatorId,
        LeagueFirestoreFields.location: 'Online',
        LeagueFirestoreFields.maxParticipants: maxParticipants,
        LeagueFirestoreFields.participantCount: playingMembers.length,
        LeagueFirestoreFields.published: true,
        LeagueFirestoreFields.entryFeeUsd: 0,
        LeagueFirestoreFields.createdAt: now,
        LeagueFirestoreFields.updatedAt: now,
      };
      if (logoUrl != null && logoUrl.isNotEmpty) {
        leagueData[LeagueFirestoreFields.logoUrl] = logoUrl;
      }
      if (bannerUrl != null && bannerUrl.isNotEmpty) {
        leagueData[LeagueFirestoreFields.bannerUrl] = bannerUrl;
      }
      if (prizePool != null) {
        leagueData[LeagueFirestoreFields.prizePool] = prizePool;
      }
      if (endDate != null) {
        leagueData[LeagueFirestoreFields.endDate] = Timestamp.fromDate(endDate);
      }

      var batch = _firestore.batch();
      batch.set(leagueRef, leagueData);

      for (final m in merged) {
        final ref = leagueRef.collection(_members).doc(m.id);
        batch.set(ref, {
          LeagueFirestoreFields.userId: m.id,
          LeagueFirestoreFields.displayName: m.name,
          LeagueFirestoreFields.isAdmin: m.isAdmin,
          LeagueFirestoreFields.isTeam: m.isTeam,
          LeagueFirestoreFields.playsInLeague: m.playsInLeague,
          LeagueFirestoreFields.joinedAt: now,
        });
      }
      await batch.commit();

      for (var i = 0; i < fixtures.length; i += _maxBatchOps) {
        batch = _firestore.batch();
        final end = min(i + _maxBatchOps, fixtures.length);
        for (var j = i; j < end; j++) {
          final f = fixtures[j];
          final ref = leagueRef.collection(_fixtures).doc();
          batch.set(ref, {
            LeagueFirestoreFields.round: f.round,
            LeagueFirestoreFields.matchWeek: f.matchWeek,
            LeagueFirestoreFields.kickoffAt: Timestamp.fromDate(f.kickoffAt),
            LeagueFirestoreFields.homeId: f.homeId,
            LeagueFirestoreFields.awayId: f.awayId,
            LeagueFirestoreFields.homeName: f.homeName,
            LeagueFirestoreFields.awayName: f.awayName,
            LeagueFirestoreFields.matchIndex: f.matchIndex,
            LeagueFirestoreFields.status: 'scheduled',
          });
        }
        await batch.commit();
      }

      for (var i = 0; i < standingRows.length; i += _maxBatchOps) {
        batch = _firestore.batch();
        final end = min(i + _maxBatchOps, standingRows.length);
        for (var j = i; j < end; j++) {
          final s = standingRows[j];
          final ref = leagueRef.collection(_standings).doc(s.participantId);
          batch.set(ref, {
            LeagueFirestoreFields.participantId: s.participantId,
            LeagueFirestoreFields.displayName: s.name,
            LeagueFirestoreFields.played: 0,
            LeagueFirestoreFields.won: 0,
            LeagueFirestoreFields.drawn: 0,
            LeagueFirestoreFields.lost: 0,
            LeagueFirestoreFields.goalsFor: 0,
            LeagueFirestoreFields.goalsAgainst: 0,
            LeagueFirestoreFields.points: 0,
          });
        }
        await batch.commit();
      }

      return leagueId;
    } on FirebaseException catch (e) {
      throw FirebaseDataException(e.message ?? 'Failed to publish league');
    }
  }

  List<LeagueParticipantDraft> _mergeMembers({
    required String creatorId,
    required String creatorName,
    required List<LeagueParticipantDraft> invitedPlayers,
    required List<LeagueParticipantDraft> invitedAdmins,
    required bool creatorJoinsAsParticipant,
  }) {
    final map = <String, LeagueParticipantDraft>{};
    map[creatorId] = LeagueParticipantDraft(
      id: creatorId,
      name: creatorName,
      subtitle: 'League creator',
      isTeam: false,
      isAdmin: false,
      playsInLeague: creatorJoinsAsParticipant,
    );
    for (final p in invitedPlayers) {
      map[p.id] = p.copyWith(isAdmin: false, playsInLeague: true);
    }
    for (final admin in invitedAdmins) {
      if (admin.id == creatorId) continue;
      final current = map[admin.id];
      if (current != null) {
        map[admin.id] = current.copyWith(isAdmin: true);
      } else {
        map[admin.id] = admin.copyWith(isAdmin: true);
      }
    }
    return map.values.toList();
  }
}

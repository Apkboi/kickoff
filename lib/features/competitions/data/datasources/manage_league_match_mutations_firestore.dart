import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/constants/league_firestore_fields.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/models/stream_link.dart';
import '../../domain/entities/manage_match_event_entity.dart';

Future<void> startMatchInFirestore({
  required FirebaseFirestore firestore,
  required String competitionId,
  required String matchId,
  List<StreamLink> streamLinks = const [],
}) async {
  try {
    final fixtureRef = firestore
        .collection(FirestoreCollections.leagues)
        .doc(competitionId)
        .collection(FirestoreCollections.fixtures)
        .doc(matchId);

    final startTime = DateTime.now();
    final payload = <String, dynamic>{
      LeagueFirestoreFields.status: 'live',
      LeagueFirestoreFields.startedAt: FieldValue.serverTimestamp(),
      LeagueFirestoreFields.kickoffAt: Timestamp.fromDate(startTime),
      LeagueFirestoreFields.updatedAt: FieldValue.serverTimestamp(),
    };
    final links = streamLinks.where((l) => l.url.trim().isNotEmpty).toList();
    if (links.isNotEmpty) {
      payload[LeagueFirestoreFields.streamLinks] = links
          .map((l) => <String, String>{'label': l.label.trim(), 'url': l.url.trim()})
          .toList();
      payload[LeagueFirestoreFields.streamUrl] = links.first.url.trim();
    }
    await fixtureRef.update(payload);
  } on FirebaseException catch (e) {
    throw FirebaseDataException(e.message ?? 'Failed to start match');
  } catch (_) {
    throw const FirebaseDataException('Failed to start match');
  }
}

Future<void> updateMatchScoresInFirestore({
  required FirebaseFirestore firestore,
  required String competitionId,
  required String matchId,
  required int homeScore,
  required int awayScore,
}) async {
  try {
    final fixtureRef = firestore
        .collection(FirestoreCollections.leagues)
        .doc(competitionId)
        .collection(FirestoreCollections.fixtures)
        .doc(matchId);

    await fixtureRef.update({
      LeagueFirestoreFields.homeScore: homeScore,
      LeagueFirestoreFields.awayScore: awayScore,
      LeagueFirestoreFields.updatedAt: FieldValue.serverTimestamp(),
    });
  } on FirebaseException catch (e) {
    throw FirebaseDataException(e.message ?? 'Failed to update score');
  } catch (_) {
    throw const FirebaseDataException('Failed to update score');
  }
}

/// Updates kickoff time only (match week / round unchanged).
Future<void> updateMatchScheduleInFirestore({
  required FirebaseFirestore firestore,
  required String competitionId,
  required String matchId,
  required DateTime kickoffAt,
}) async {
  try {
    final fixtureRef = firestore
        .collection(FirestoreCollections.leagues)
        .doc(competitionId)
        .collection(FirestoreCollections.fixtures)
        .doc(matchId);
    await fixtureRef.update({
      LeagueFirestoreFields.kickoffAt: Timestamp.fromDate(kickoffAt),
      LeagueFirestoreFields.updatedAt: FieldValue.serverTimestamp(),
    });
  } on FirebaseException catch (e) {
    throw FirebaseDataException(e.message ?? 'Failed to update fixture schedule');
  } catch (_) {
    throw const FirebaseDataException('Failed to update fixture schedule');
  }
}

String _kindToFirestore(ManageMatchEventKind kind) {
  return switch (kind) {
    ManageMatchEventKind.goal => 'goal',
    ManageMatchEventKind.yellowCard => 'yellowCard',
    ManageMatchEventKind.redCard => 'redCard',
    ManageMatchEventKind.substitution => 'substitution',
  };
}

Future<String> addMatchEventInFirestore({
  required FirebaseFirestore firestore,
  required String competitionId,
  required String matchId,
  required ManageMatchEventKind kind,
  required String playerName,
  required String minuteLabel,
  required String title,
  required String subtitle,
}) async {
  try {
    final eventsRef = firestore
        .collection(FirestoreCollections.leagues)
        .doc(competitionId)
        .collection(FirestoreCollections.fixtures)
        .doc(matchId)
        .collection(FirestoreCollections.events);

    final eventRef = eventsRef.doc();
    await eventRef.set({
      LeagueFirestoreFields.eventKind: _kindToFirestore(kind),
      LeagueFirestoreFields.eventPlayerName: playerName,
      LeagueFirestoreFields.eventMinuteLabel: minuteLabel,
      LeagueFirestoreFields.eventTitle: title,
      LeagueFirestoreFields.eventSubtitle: subtitle,
      LeagueFirestoreFields.createdAt: FieldValue.serverTimestamp(),
    });
    return eventRef.id;
  } on FirebaseException catch (e) {
    throw FirebaseDataException(e.message ?? 'Failed to add event');
  } catch (_) {
    throw const FirebaseDataException('Failed to add event');
  }
}


import '../entities/league_format.dart';
import '../entities/league_participant_draft.dart';

class GeneratedFixture {
  const GeneratedFixture({
    required this.round,
    required this.matchWeek,
    required this.kickoffAt,
    required this.homeId,
    required this.awayId,
    required this.homeName,
    required this.awayName,
    required this.matchIndex,
  });

  final int round;
  final int matchWeek;
  final DateTime kickoffAt;
  final String homeId;
  final String awayId;
  final String homeName;
  final String awayName;
  final int matchIndex;
}

class GeneratedStandingRow {
  const GeneratedStandingRow({
    required this.participantId,
    required this.name,
  });

  final String participantId;
  final String name;
}

abstract final class LeagueScheduleGenerator {
  static List<GeneratedStandingRow> standingsForMembers(
    List<LeagueParticipantDraft> members,
  ) {
    return members
        .map(
          (m) => GeneratedStandingRow(
            participantId: m.id,
            name: m.name,
          ),
        )
        .toList();
  }

  static List<GeneratedFixture> buildFixtures({
    required LeagueFormat format,
    required bool automateFixtures,
    required List<LeagueParticipantDraft> members,
    required int soloMatchCount,
  }) {
    if (!automateFixtures || members.length < 2) {
      return [];
    }
    switch (format) {
      case LeagueFormat.solo:
        return _soloSeries(members, soloMatchCount);
      case LeagueFormat.standard:
        return _roundRobinAllPairs(members);
      case LeagueFormat.knockout:
        return _knockoutFirstRound(members);
    }
  }

  static List<GeneratedFixture> _roundRobinAllPairs(
    List<LeagueParticipantDraft> members,
  ) {
    final sorted = List<LeagueParticipantDraft>.from(members)
      ..sort((a, b) => a.id.compareTo(b.id));
    final out = <GeneratedFixture>[];
    final start = DateTime.now().add(const Duration(days: 1));
    var idx = 0;
    for (var i = 0; i < sorted.length; i++) {
      for (var j = i + 1; j < sorted.length; j++) {
        final a = sorted[i];
        final b = sorted[j];
        out.add(
          GeneratedFixture(
            round: 1,
            matchWeek: 1,
            kickoffAt: start.add(Duration(days: idx)),
            homeId: a.id,
            awayId: b.id,
            homeName: a.name,
            awayName: b.name,
            matchIndex: idx++,
          ),
        );
      }
    }
    return out;
  }

  static List<GeneratedFixture> _knockoutFirstRound(
    List<LeagueParticipantDraft> members,
  ) {
    final sorted = List<LeagueParticipantDraft>.from(members)
      ..sort((a, b) => a.id.compareTo(b.id));
    final pairCount = sorted.length ~/ 2;
    final out = <GeneratedFixture>[];
    final start = DateTime.now().add(const Duration(days: 1));
    for (var k = 0; k < pairCount; k++) {
      final a = sorted[k * 2];
      final b = sorted[k * 2 + 1];
      out.add(
        GeneratedFixture(
          round: 1,
          matchWeek: 1,
          kickoffAt: start.add(Duration(days: k)),
          homeId: a.id,
          awayId: b.id,
          homeName: a.name,
          awayName: b.name,
          matchIndex: k,
        ),
      );
    }
    return out;
  }

  static List<GeneratedFixture> _soloSeries(
    List<LeagueParticipantDraft> members,
    int soloMatchCount,
  ) {
    if (members.length < 2) return [];
    final sorted = List<LeagueParticipantDraft>.from(members)
      ..sort((a, b) => a.id.compareTo(b.id));
    final a = sorted.first;
    final b = sorted[1];
    final start = DateTime.now().add(const Duration(days: 1));
    return List.generate(
      soloMatchCount,
      (i) => GeneratedFixture(
        round: 1,
        matchWeek: i + 1,
        kickoffAt: start.add(Duration(days: i)),
        homeId: i.isEven ? a.id : b.id,
        awayId: i.isEven ? b.id : a.id,
        homeName: i.isEven ? a.name : b.name,
        awayName: i.isEven ? b.name : a.name,
        matchIndex: i,
      ),
    );
  }
}

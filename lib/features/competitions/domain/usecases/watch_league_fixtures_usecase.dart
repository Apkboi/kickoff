import '../entities/league_fixture_summary_entity.dart';
import '../repositories/league_fixtures_repository.dart';

class WatchLeagueFixturesUseCase {
  const WatchLeagueFixturesUseCase(this._repository);

  final LeagueFixturesRepository _repository;

  Stream<List<LeagueFixtureSummaryEntity>> call({
    required String competitionId,
  }) {
    return _repository.watchFixtures(competitionId: competitionId);
  }
}


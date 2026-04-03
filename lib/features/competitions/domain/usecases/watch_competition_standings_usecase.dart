import '../entities/standing_row_entity.dart';
import '../repositories/competition_repository.dart';

class WatchCompetitionStandingsUseCase {
  const WatchCompetitionStandingsUseCase(this._repository);

  final CompetitionRepository _repository;

  Stream<List<StandingRowEntity>> call(String competitionId) {
    return _repository.watchCompetitionStandings(competitionId);
  }
}


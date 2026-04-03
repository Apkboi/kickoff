import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/league_detail_entity.dart';
import '../repositories/competition_repository.dart';

class GetCompetitionByIdParams extends Equatable {
  const GetCompetitionByIdParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

class GetCompetitionByIdUseCase {
  const GetCompetitionByIdUseCase(this._repository);

  final CompetitionRepository _repository;

  Future<Either<Failure, LeagueDetailEntity>> call(GetCompetitionByIdParams params) {
    return _repository.getCompetitionById(params.id);
  }
}

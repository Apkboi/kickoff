import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/competition_entity.dart';
import '../repositories/competition_repository.dart';

class GetCompetitionsParams extends Equatable {
  const GetCompetitionsParams();

  @override
  List<Object?> get props => [];
}

class GetCompetitionsUseCase {
  const GetCompetitionsUseCase(this._repository);

  final CompetitionRepository _repository;

  Future<Either<Failure, List<CompetitionEntity>>> call(GetCompetitionsParams params) {
    return _repository.getCompetitions();
  }
}

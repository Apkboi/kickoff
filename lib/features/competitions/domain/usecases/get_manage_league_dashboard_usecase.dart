import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/manage_league_dashboard_entity.dart';
import '../repositories/manage_league_repository.dart';

class GetManageLeagueDashboardParams extends Equatable {
  const GetManageLeagueDashboardParams({required this.competitionId});

  final String competitionId;

  @override
  List<Object?> get props => [competitionId];
}

class GetManageLeagueDashboardUseCase {
  const GetManageLeagueDashboardUseCase(this._repository);

  final ManageLeagueRepository _repository;

  Future<Either<Failure, ManageLeagueDashboardEntity>> call(GetManageLeagueDashboardParams params) {
    return _repository.getDashboard(params.competitionId);
  }
}

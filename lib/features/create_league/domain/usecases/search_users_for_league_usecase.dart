import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_search_result_entity.dart';
import '../repositories/user_search_repository.dart';

class SearchUsersForLeagueParams extends Equatable {
  const SearchUsersForLeagueParams({
    required this.query,
    this.excludeUserId,
  });

  final String query;
  final String? excludeUserId;

  @override
  List<Object?> get props => [query, excludeUserId];
}

class SearchUsersForLeagueUseCase {
  const SearchUsersForLeagueUseCase(this._repository);

  final UserSearchRepository _repository;

  Future<Either<Failure, List<UserSearchResultEntity>>> call(
    SearchUsersForLeagueParams params,
  ) {
    return _repository.searchUsers(
      query: params.query,
      excludeUserId: params.excludeUserId,
    );
  }
}

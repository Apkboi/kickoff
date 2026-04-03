import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_search_result_entity.dart';
import '../../domain/repositories/user_search_repository.dart';
import '../datasources/user_search_remote_datasource.dart';

class UserSearchRepositoryImpl implements UserSearchRepository {
  const UserSearchRepositoryImpl(this._remote);

  final UserSearchRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<UserSearchResultEntity>>> searchUsers({
    required String query,
    String? excludeUserId,
  }) async {
    try {
      final list = await _remote.searchUsers(
        query: query,
        excludeUserId: excludeUserId,
      );
      return Right(
        list
            .map(
              (m) => UserSearchResultEntity(
                id: m.id,
                displayName: m.displayName,
                email: m.email,
              ),
            )
            .toList(),
      );
    } on FirebaseDataException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure('Search failed'));
    }
  }
}

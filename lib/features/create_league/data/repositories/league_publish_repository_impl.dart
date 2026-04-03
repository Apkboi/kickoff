import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/league_publish_repository.dart';
import '../datasources/league_publish_remote_datasource.dart';

class LeaguePublishRepositoryImpl implements LeaguePublishRepository {
  const LeaguePublishRepositoryImpl(this._remote);

  final LeaguePublishRemoteDataSource _remote;

  @override
  Future<Either<Failure, String>> publish(PublishLeagueParams params) async {
    try {
      final id = await _remote.publishLeague(
        leagueName: params.leagueName,
        sport: params.sport,
        format: params.format,
        automateFixtures: params.automateFixtures,
        creatorId: params.creatorId,
        creatorDisplayName: params.creatorDisplayName,
        invitedParticipants: params.invitedParticipants,
        invitedAdmins: params.invitedAdmins,
        soloMatchCount: params.soloMatchCount,
        creatorJoinsAsParticipant: params.creatorJoinsAsParticipant,
        endDate: params.endDate,
        prizePool: params.prizePool,
        logoUrl: params.logoUrl,
        bannerUrl: params.bannerUrl,
        maxParticipants: params.maxParticipants,
      );
      return Right(id);
    } on FirebaseDataException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure('Could not publish league'));
    }
  }
}

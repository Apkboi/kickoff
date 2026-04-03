import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remote);

  final ProfileRemoteDataSource _remote;

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile(String uid) async {
    try {
      final model = await _remote.getUserProfile(uid);
      return Right(model);
    } on ProfileNotFoundException {
      return const Left(UnknownFailure('Profile not found'));
    } on FirebaseDataException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure('Unable to load profile'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateDisplayName(String displayName) async {
    try {
      await _remote.updateDisplayName(displayName);
      return const Right(unit);
    } on FirebaseDataException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure('Could not update name'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfilePhoto(Uint8List imageBytes) async {
    try {
      await _remote.uploadProfileAvatar(imageBytes);
      return const Right(unit);
    } on FirebaseDataException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure('Could not update photo'));
    }
  }
}

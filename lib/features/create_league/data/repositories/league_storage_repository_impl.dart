import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/league_image_kind.dart';
import '../../domain/repositories/league_storage_repository.dart';
import '../datasources/league_storage_remote_datasource.dart';

class LeagueStorageRepositoryImpl implements LeagueStorageRepository {
  LeagueStorageRepositoryImpl(this._remote);

  final LeagueStorageRemoteDataSource _remote;

  @override
  Future<Either<Failure, String>> uploadLeagueDraftImage({
    required LeagueImageKind kind,
    required Uint8List imageBytes,
    required String contentType,
  }) async {
    try {
      final url = await _remote.uploadLeagueDraftImage(
        kind: kind,
        imageBytes: imageBytes,
        contentType: contentType,
      );
      return Right(url);
    } on FirebaseException catch (e) {
      return Left(StorageFailure(e.message ?? 'Upload failed'));
    } on StateError catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }
}

import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/league_image_kind.dart';

abstract class LeagueStorageRepository {
  Future<Either<Failure, String>> uploadLeagueDraftImage({
    required LeagueImageKind kind,
    required Uint8List imageBytes,
    required String contentType,
  });
}

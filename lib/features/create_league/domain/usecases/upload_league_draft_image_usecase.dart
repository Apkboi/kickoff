import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/league_image_kind.dart';
import '../repositories/league_storage_repository.dart';

class UploadLeagueDraftImageParams extends Equatable {
  const UploadLeagueDraftImageParams({
    required this.kind,
    required this.imageBytes,
    required this.contentType,
  });

  final LeagueImageKind kind;
  final Uint8List imageBytes;
  final String contentType;

  @override
  List<Object?> get props => [kind, contentType];
}

class UploadLeagueDraftImageUseCase {
  UploadLeagueDraftImageUseCase(this._repository);

  final LeagueStorageRepository _repository;

  Future<Either<Failure, String>> call(UploadLeagueDraftImageParams params) {
    return _repository.uploadLeagueDraftImage(
      kind: params.kind,
      imageBytes: params.imageBytes,
      contentType: params.contentType,
    );
  }
}

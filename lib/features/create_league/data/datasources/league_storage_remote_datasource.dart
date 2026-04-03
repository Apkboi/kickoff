import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/constants/firebase_storage_paths.dart';
import '../../domain/entities/league_image_kind.dart';
import '../utils/league_image_compress.dart';

abstract class LeagueStorageRemoteDataSource {
  Future<String> uploadLeagueDraftImage({
    required LeagueImageKind kind,
    required Uint8List imageBytes,
    required String contentType,
  });
}

class LeagueStorageRemoteDataSourceImpl implements LeagueStorageRemoteDataSource {
  LeagueStorageRemoteDataSourceImpl({
    FirebaseAuth? auth,
    FirebaseStorage? storage,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseAuth _auth;
  final FirebaseStorage _storage;

  @override
  Future<String> uploadLeagueDraftImage({
    required LeagueImageKind kind,
    required Uint8List imageBytes,
    required String contentType,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('Not signed in');
    }

    final compressed = await compressLeagueImageForUpload(
      bytes: imageBytes,
      kind: kind,
    );

    final millis = DateTime.now().millisecondsSinceEpoch;
    final path = FirebaseStoragePaths.leagueDraft(uid, kind.name, millis);
    final ref = _storage.ref().child(path);

    await ref.putData(
      compressed,
      SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'kind': kind.name},
      ),
    );

    return ref.getDownloadURL();
  }
}

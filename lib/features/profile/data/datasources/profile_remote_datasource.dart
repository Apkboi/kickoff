import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/constants/firebase_storage_paths.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/constants/user_firestore_fields.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_profile_model.dart';
import '../utils/profile_avatar_compress.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile(String uid);

  Future<void> uploadProfileAvatar(Uint8List imageBytes);

  Future<void> updateDisplayName(String displayName);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(
    this._firestore, {
    FirebaseAuth? auth,
    FirebaseStorage? storage,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;

  @override
  Future<UserProfileModel> getUserProfile(String uid) async {
    try {
      final doc = await _firestore
          .collection(FirestoreCollections.users)
          .doc(uid)
          .get();
      if (!doc.exists) {
        throw const ProfileNotFoundException();
      }
      return UserProfileModel.fromFirestore(doc);
    } on ProfileNotFoundException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirebaseDataException(e.message ?? 'Firestore error');
    }
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw const FirebaseDataException('Not signed in');
    }
    final trimmed = displayName.trim();
    if (trimmed.isEmpty) {
      throw const FirebaseDataException('Name cannot be empty');
    }
    try {
      await _firestore.collection(FirestoreCollections.users).doc(uid).set(
        {
          UserFirestoreFields.displayName: trimmed,
          UserFirestoreFields.updatedAt: FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } on FirebaseException catch (e) {
      throw FirebaseDataException(e.message ?? 'Failed to update name');
    }
  }

  @override
  Future<void> uploadProfileAvatar(Uint8List imageBytes) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw const FirebaseDataException('Not signed in');
    }
    try {
      final compressed = await compressProfileAvatar(bytes: imageBytes);
      final path = FirebaseStoragePaths.profileAvatar(uid);
      final ref = _storage.ref().child(path);
      await ref.putData(
        compressed,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final url = await ref.getDownloadURL();
      await _firestore.collection(FirestoreCollections.users).doc(uid).set(
        {
          UserFirestoreFields.photoUrl: url,
          UserFirestoreFields.updatedAt: FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } on FirebaseException catch (e) {
      throw FirebaseDataException(e.message ?? 'Upload failed');
    }
  }
}

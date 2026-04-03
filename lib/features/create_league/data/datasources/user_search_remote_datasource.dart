import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/errors/exceptions.dart';

class UserSearchResultModel {
  const UserSearchResultModel({
    required this.id,
    required this.displayName,
    this.email,
  });

  final String id;
  final String displayName;
  final String? email;
}

abstract class UserSearchRemoteDataSource {
  Future<List<UserSearchResultModel>> searchUsers({
    required String query,
    String? excludeUserId,
  });
}

class UserSearchRemoteDataSourceImpl implements UserSearchRemoteDataSource {
  UserSearchRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<List<UserSearchResultModel>> searchUsers({
    required String query,
    String? excludeUserId,
  }) async {
    final q = query.trim();
    if (q.length < 2) {
      return [];
    }
    try {
      // Requires single-field index on users.displayName (Firestore console).
      final snap = await _firestore
          .collection(FirestoreCollections.users)
          .orderBy('displayName')
          .startAt([q])
          .endAt(['$q\u{f8ff}'])
          .limit(20)
          .get();

      final out = <UserSearchResultModel>[];
      for (final doc in snap.docs) {
        if (excludeUserId != null && doc.id == excludeUserId) continue;
        final data = doc.data();
        out.add(
          UserSearchResultModel(
            id: doc.id,
            displayName: data['displayName'] as String? ?? 'User',
            email: data['email'] as String?,
          ),
        );
      }
      return out;
    } on FirebaseException catch (e) {
      throw FirebaseDataException(e.message ?? 'User search failed');
    }
  }
}

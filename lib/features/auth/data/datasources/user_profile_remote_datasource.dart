import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/constants/user_firestore_fields.dart';
import '../../../../core/errors/exceptions.dart';

abstract class UserProfileRemoteDataSource {
  Future<void> ensureUserProfile({
    required String uid,
    required String email,
    required String displayName,
  });
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  UserProfileRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<void> ensureUserProfile({
    required String uid,
    required String email,
    required String displayName,
  }) async {
    try {
      final doc = _firestore.collection(FirestoreCollections.users).doc(uid);
      final snap = await doc.get();
      if (!snap.exists) {
        await doc.set({
          'uid': uid,
          'email': email,
          'displayName': displayName,
          'photoUrl': null,
          'role': 'player',
          UserFirestoreFields.xpPoints: 50,
          UserFirestoreFields.badges: ['kickoff_welcome'],
          'membershipTier': 'free',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      } else {
        await doc.set(
          {
            'email': email,
            if (displayName.isNotEmpty) 'displayName': displayName,
            'lastLoginAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
      }
    } on FirebaseException catch (e) {
      throw FirebaseDataException(e.message ?? 'Firestore error');
    }
  }
}

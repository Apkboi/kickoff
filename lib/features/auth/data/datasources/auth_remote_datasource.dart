import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/auth_user_model.dart';
import '../utils/firebase_auth_messages.dart';
import 'user_profile_remote_datasource.dart';

abstract class AuthRemoteDataSource {
  Stream<AuthUserModel> authStateChanges();

  Future<AuthUserModel> getCurrentUser();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(
    this._userProfileDataSource,
  );

  final UserProfileRemoteDataSource _userProfileDataSource;

  FirebaseAuth get _auth => FirebaseAuth.instance;

  AuthUserModel _mapUser(User? user) {
    if (user == null) {
      return const AuthUserModel(
        id: '',
        email: '',
        isAuthenticated: false,
      );
    }
    return AuthUserModel(
      id: user.uid,
      email: user.email ?? '',
      isAuthenticated: true,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  @override
  Stream<AuthUserModel> authStateChanges() {
    return _auth.authStateChanges().map(_mapUser);
  }

  @override
  Future<AuthUserModel> getCurrentUser() async {
    try {
      if (Firebase.apps.isEmpty) {
        return _mapUser(null);
      }
      return _mapUser(_auth.currentUser);
    } on FirebaseException catch (e) {
      throw FirebaseDataException(e.message ?? 'Firebase auth error');
    }
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        await _userProfileDataSource.ensureUserProfile(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? '',
        );
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseDataException(FirebaseAuthMessages.fromException(e));
    }
  }

  @override
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        if (displayName.trim().isNotEmpty) {
          await user.updateDisplayName(displayName.trim());
        }
        await _userProfileDataSource.ensureUserProfile(
          uid: user.uid,
          email: user.email ?? '',
          displayName: displayName.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseDataException(FirebaseAuthMessages.fromException(e));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseException catch (e) {
      throw FirebaseDataException(e.message ?? 'Sign out failed');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw FirebaseDataException(FirebaseAuthMessages.fromException(e));
    }
  }
}

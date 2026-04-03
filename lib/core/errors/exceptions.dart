class FirebaseDataException implements Exception {
  const FirebaseDataException(this.message);

  final String message;
}

class ProfileNotFoundException implements Exception {
  const ProfileNotFoundException();
}

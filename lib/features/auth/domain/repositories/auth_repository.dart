import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  });

  Future<void> signOut();

  Future<UserEntity?> getCurrentUser();

  Stream<UserEntity?> get authStateChanges;

  Future<void> sendPasswordResetEmail(String email);

  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  });
} 
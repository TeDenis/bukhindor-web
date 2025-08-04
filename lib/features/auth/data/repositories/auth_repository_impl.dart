import 'dart:async';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  UserEntity? _currentUser;
  final StreamController<UserEntity?> _authStateController = StreamController<UserEntity?>.broadcast();

  @override
  Future<UserEntity?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Быстрая мок-авторизация
    if (email == 'demo@example.com' && password == 'password') {
      _currentUser = UserEntity(
        id: 'demo-user-id',
        email: email,
        displayName: 'Demo User',
        emailVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      );
      _authStateController.add(_currentUser);
      return _currentUser;
    } else {
      throw Exception('Неверный email или пароль');
    }
  }

  @override
  Future<UserEntity?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    // Быстрая мок-регистрация
    _currentUser = UserEntity(
      id: 'new-user-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: displayName ?? email.split('@')[0],
      emailVerified: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _authStateController.add(_currentUser);
    return _currentUser;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _authStateController.add(null);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Stream<UserEntity?> get authStateChanges => _authStateController.stream;

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    // Мок-отправка email
  }

  @override
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        displayName: displayName ?? _currentUser!.displayName,
        updatedAt: DateTime.now(),
      );
      _authStateController.add(_currentUser);
    }
  }

  void dispose() {
    _authStateController.close();
  }
} 
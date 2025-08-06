import 'dart:async';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/token_manager.dart';
import '../../../../core/mappers/user_mapper.dart';
import '../../../../core/models/api_models.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService = ApiService();
  UserEntity? _currentUser;
  final StreamController<UserEntity?> _authStateController =
      StreamController<UserEntity?>.broadcast();

  @override
  Future<UserEntity?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final loginRequest = LoginRequest(email: email, password: password);
      final loginResponse = await _apiService.login(loginRequest);

      // Получаем данные пользователя
      final userResponse = await _apiService.getCurrentUser();
      _currentUser = UserMapper.fromApiResponse(userResponse);

      _authStateController.add(_currentUser);
      return _currentUser;
    } catch (e) {
      throw Exception('Ошибка входа: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final registerRequest = RegisterRequest(
        name: displayName ?? email.split('@')[0],
        email: email,
        password: password,
      );

      final registerResponse = await _apiService.register(registerRequest);
      _currentUser = UserMapper.fromApiResponse(registerResponse.user);

      _authStateController.add(_currentUser);
      return _currentUser;
    } catch (e) {
      throw Exception('Ошибка регистрации: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _apiService.logout();
    } catch (e) {
      // Игнорируем ошибки при выходе
    } finally {
      _currentUser = null;
      _authStateController.add(null);
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      // Проверяем наличие токенов
      if (!await TokenManager.hasTokens()) {
        return null;
      }

      final userResponse = await _apiService.getCurrentUser();
      _currentUser = UserMapper.fromApiResponse(userResponse);
      return _currentUser;
    } catch (e) {
      // Если токены недействительны, очищаем их
      await TokenManager.clearTokens();
      _currentUser = null;
      return null;
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges => _authStateController.stream;

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      final resetRequest = ResetPasswordRequest(email: email);
      await _apiService.resetPassword(resetRequest);
    } catch (e) {
      throw Exception(
          'Ошибка отправки email для сброса пароля: ${e.toString()}');
    }
  }

  @override
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    if (_currentUser != null) {
      try {
        final updateRequest = UpdateUserRequest(
          name: displayName,
        );

        final userResponse =
            await _apiService.updateUser(_currentUser!.id, updateRequest);
        _currentUser = UserMapper.fromApiResponse(userResponse);
        _authStateController.add(_currentUser);
      } catch (e) {
        throw Exception('Ошибка обновления профиля: ${e.toString()}');
      }
    }
  }

  void dispose() {
    _authStateController.close();
  }
}

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import '../config/api_config.dart';
import '../models/api_models.dart';
import 'token_manager.dart';

class ApiService {
  late final Dio _dio;
  bool _isRefreshing = false;

  ApiService() {
    final options = BaseOptions(
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {'Content-Type': ApiConfig.contentType},
    );
    if (ApiConfig.baseUrl.isNotEmpty) {
      options.baseUrl = ApiConfig.baseUrl;
    }
    _dio = Dio(options);

    // Добавляем retry interceptor
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: print,
        retries: ApiConfig.maxRetries,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
    );

    // Добавляем auth interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: _onRequest, onError: _onError),
    );
  }

  // Interceptor для добавления токенов к запросам
  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Добавляем токен только к защищенным эндпоинтам
    if (_isProtectedEndpoint(options.path)) {
      final token = await TokenManager.getAccessToken();
      if (token != null) {
        options.headers[ApiConfig.authorizationHeader] =
            '${ApiConfig.bearerPrefix}$token';
      }
    }
    handler.next(options);
  }

  // Interceptor для обработки ошибок и обновления токенов
  Future<void> _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshToken = await TokenManager.getRefreshToken();
        if (refreshToken != null) {
          final response = await _dio.post(
            ApiConfig.authRefresh,
            data: RefreshTokenRequest(refresh_token: refreshToken).toJson(),
          );

          final refreshResponse = RefreshTokenResponse.fromJson(response.data);

          // Сохраняем новые токены
          await TokenManager.saveTokens(
            accessToken: refreshResponse.user.access_token,
            refreshToken: refreshResponse.user.refresh_token,
          );

          // Повторяем оригинальный запрос с новым токеном
          final newToken = await TokenManager.getAccessToken();
          err.requestOptions.headers[ApiConfig.authorizationHeader] =
              '${ApiConfig.bearerPrefix}$newToken';

          final retryResponse = await _dio.fetch(err.requestOptions);
          handler.resolve(retryResponse);
          return;
        }
      } catch (e) {
        // Если обновление токена не удалось, очищаем токены
        await TokenManager.clearTokens();
      } finally {
        _isRefreshing = false;
      }
    }

    handler.next(err);
  }

  // Проверка защищенных эндпоинтов
  bool _isProtectedEndpoint(String path) {
    return path.startsWith('/api/v1/auth/me') ||
        path.startsWith('/api/v1/users') ||
        path.startsWith('/api/v1/');
  }

  // Health check
  Future<HealthResponse> healthCheck() async {
    final response = await _dio.get(ApiConfig.health);
    return HealthResponse.fromJson(response.data);
  }

  // Регистрация
  Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await _dio.post(
      ApiConfig.authRegister,
      data: request.toJson(),
    );
    return RegisterResponse.fromJson(response.data);
  }

  // Вход
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post(
      ApiConfig.authLogin,
      data: request.toJson(),
    );

    final loginResponse = LoginResponse.fromJson(response.data);

    // Сохраняем токены
    await TokenManager.saveTokens(
      accessToken: loginResponse.user.access_token,
      refreshToken: loginResponse.user.refresh_token,
    );

    return loginResponse;
  }

  // Сброс пароля
  Future<MessageResponse> resetPassword(ResetPasswordRequest request) async {
    final response = await _dio.post(
      ApiConfig.authResetPassword,
      data: request.toJson(),
    );
    return MessageResponse.fromJson(response.data);
  }

  // Получение текущего пользователя
  Future<UserResponse> getCurrentUser() async {
    final response = await _dio.get(ApiConfig.authMe);
    return UserResponse.fromJson(response.data);
  }

  // Обновление токенов
  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest request) async {
    final response = await _dio.post(
      ApiConfig.authRefresh,
      data: request.toJson(),
    );

    final refreshResponse = RefreshTokenResponse.fromJson(response.data);

    // Сохраняем новые токены
    await TokenManager.saveTokens(
      accessToken: refreshResponse.user.access_token,
      refreshToken: refreshResponse.user.refresh_token,
    );

    return refreshResponse;
  }

  // Получение списка пользователей
  Future<UsersListResponse> getUsers({int page = 1, int limit = 20}) async {
    final response = await _dio.get(
      ApiConfig.users,
      queryParameters: {'page': page, 'limit': limit},
    );
    return UsersListResponse.fromJson(response.data);
  }

  // Создание пользователя
  Future<UserResponse> createUser(CreateUserRequest request) async {
    final response = await _dio.post(ApiConfig.users, data: request.toJson());
    return UserResponse.fromJson(response.data);
  }

  // Получение пользователя по ID
  Future<UserResponse> getUser(String id) async {
    final response = await _dio.get('${ApiConfig.users}/$id');
    return UserResponse.fromJson(response.data);
  }

  // Обновление пользователя
  Future<UserResponse> updateUser(String id, UpdateUserRequest request) async {
    final response = await _dio.put(
      '${ApiConfig.users}/$id',
      data: request.toJson(),
    );
    return UserResponse.fromJson(response.data);
  }

  // Удаление пользователя
  Future<MessageResponse> deleteUser(String id) async {
    final response = await _dio.delete('${ApiConfig.users}/$id');
    return MessageResponse.fromJson(response.data);
  }

  // Выход (очистка токенов)
  Future<void> logout() async {
    await TokenManager.clearTokens();
  }
}

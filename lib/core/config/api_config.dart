import '../constants/app_constants.dart';

class ApiConfig {
  // Base URL (can be relative, e.g. '/api' to avoid CORS via nginx proxy)
  static const String baseUrl = AppConstants.apiBaseUrl;

  // API Endpoints
  static const String health = '/api/health';
  static const String authRegister = '/api/v1/auth/register';
  static const String authLogin = '/api/v1/auth/login';
  static const String authResetPassword = '/api/v1/auth/reset-password';
  static const String authRefresh = '/api/v1/auth/refresh';
  static const String authMe = '/api/v1/auth/me';
  static const String users = '/api/v1/users';

  // Headers
  static const String contentType = 'application/json';
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';

  // Timeouts
  static const Duration connectTimeout = Duration(
    milliseconds: AppConstants.apiTimeout,
  );
  static const Duration receiveTimeout = Duration(
    milliseconds: AppConstants.apiTimeout,
  );

  // Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);
}

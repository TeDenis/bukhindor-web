class AppConstants {
  // App Info
  static const String appName = 'Bukhindor';
  static const String appDescription = 'Сервис пятничного вечера';

  // Version Info
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';
  static const String buildDate = '2024-12-19';
  static const String buildCommit = 'a1b2c3d';
  static const String buildBranch = 'main';

  // Release Info
  static const String releaseNotes = '''
🎉 Первый релиз Bukhindor!

✨ Новые возможности:
• Система аутентификации с анимированными карточками
• Красивые анимации жидкости с пузырьками
• Адаптивный дизайн для всех устройств
• Восстановление пароля
• Современный UI с градиентами

🔧 Технические улучшения:
• Clean Architecture с BLoC
• Flutter Web оптимизация
• Docker контейнеризация
• Responsive дизайн

🐛 Исправления:
• Плавные анимации без рывков
• Улучшенная производительность
• Оптимизированная навигация
''';

  // Development Info
  static const String developerName = 'Denis Telegin';
  static const String developerEmail = 'denis@example.com';
  static const String repositoryUrl =
      'https://github.com/TeDenis/bukhindor-web';

  // Environment
  static const String environment =
      'production'; // 'development', 'staging', 'production'
  static const bool isDebugMode = false;

  // API Configuration
  static const String apiBaseUrl = 'https://api.bukhindor.com';
  static const int apiTimeout = 30000; // milliseconds

  // Animation Configuration
  static const double animationDuration = 600.0; // milliseconds
  static const double liquidWaveSpeed = 0.5;
  static const int maxBubbles = 40;

  // UI Configuration
  static const double borderRadius = 16.0;
  static const double cardElevation = 8.0;
  static const double iconSize = 24.0;

  // Validation Rules
  static const int minPasswordLength = 6;
  static const int minNameLength = 2;
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
}

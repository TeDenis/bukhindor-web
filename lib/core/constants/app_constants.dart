class AppConstants {
  // Название приложения
  static const String appName = 'Bukhindor';
  static const String appSubtitle = 'Сервис пятничного вечера';
  static const String appTagline = 'Пивная авторизация';
  
  // Анимации
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration fadeAnimationDuration = Duration(milliseconds: 1500);
  static const Duration slideAnimationDuration = Duration(milliseconds: 1200);
  static const Duration liquidAnimationDuration = Duration(milliseconds: 6000);
  
  // Размеры
  static const double logoSize = 100.0;
  static const double cardBorderRadius = 24.0;
  static const double buttonBorderRadius = 16.0;
  static const double textFieldBorderRadius = 12.0;
  
  // Отступы
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  static const double cardPadding = 24.0;
  
  // Цвета (если нужно переопределить тему)
  static const int primaryColorValue = 0xFF667eea;
  static const int secondaryColorValue = 0xFF764ba2;
  static const int accentColorValue = 0xFFf093fb;
  
  // Тексты
  static const Map<String, String> authTexts = {
    'login': 'Войти',
    'register': 'Зарегистрироваться',
    'email': 'Email',
    'password': 'Пароль',
    'confirmPassword': 'Подтвердите пароль',
    'name': 'Имя',
    'rememberMe': 'Запомнить меня',
    'forgotPassword': 'Забыли пароль?',
    'noAccount': 'Нет аккаунта?',
    'hasAccount': 'Уже есть аккаунт?',
    'acceptTerms': 'Я принимаю условия использования',
    'loading': 'Загрузка...',
    'fillingGlass': 'Наполняем бокал...',
  };
  
  // Сообщения об ошибках
  static const Map<String, String> errorMessages = {
    'emailRequired': 'Email обязателен',
    'emailInvalid': 'Введите корректный email',
    'passwordRequired': 'Пароль обязателен',
    'passwordTooShort': 'Пароль должен содержать минимум 6 символов',
    'passwordsDoNotMatch': 'Пароли не совпадают',
    'nameRequired': 'Имя обязательно',
    'termsNotAccepted': 'Необходимо принять условия использования',
    'loginFailed': 'Ошибка входа',
    'registrationFailed': 'Ошибка регистрации',
    'networkError': 'Ошибка сети',
    'unknownError': 'Неизвестная ошибка',
  };
  
  // Валидация
  static const int minPasswordLength = 6;
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  
  // Навигация
  static const String splashRoute = '/splash';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
} 
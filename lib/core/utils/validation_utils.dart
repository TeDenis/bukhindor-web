import '../constants/app_constants.dart';

class ValidationUtils {
  // Валидация email
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email обязателен';
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(email)) {
      return 'Введите корректный email';
    }

    if (email.length > 255) {
      return 'Email слишком длинный (максимум 255 символов)';
    }

    return null;
  }

  // Валидация пароля
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Пароль обязателен';
    }

    if (password.length < 6) {
      return 'Пароль должен содержать минимум 6 символов';
    }

    if (password.length > 128) {
      return 'Пароль слишком длинный (максимум 128 символов)';
    }

    return null;
  }

  // Валидация подтверждения пароля
  static String? validatePasswordConfirmation(
      String? password, String? confirmation) {
    if (confirmation == null || confirmation.isEmpty) {
      return 'Подтвердите пароль';
    }

    if (password != confirmation) {
      return 'Пароли не совпадают';
    }

    return null;
  }

  // Валидация имени пользователя
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Имя обязательно';
    }

    if (name.length < 1) {
      return 'Имя не может быть пустым';
    }

    if (name.length > 100) {
      return 'Имя слишком длинное (максимум 100 символов)';
    }

    // Проверка на специальные символы
    final nameRegex = RegExp(r'^[a-zA-Zа-яА-ЯёЁ\s\-\.]+$');
    if (!nameRegex.hasMatch(name)) {
      return 'Имя содержит недопустимые символы';
    }

    return null;
  }

  // Валидация формы входа
  static Map<String, String?> validateLoginForm({
    required String email,
    required String password,
  }) {
    return {
      'email': validateEmail(email),
      'password': validatePassword(password),
    };
  }

  // Валидация формы регистрации
  static Map<String, String?> validateRegisterForm({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) {
    return {
      'name': validateName(name),
      'email': validateEmail(email),
      'password': validatePassword(password),
      'passwordConfirmation':
          validatePasswordConfirmation(password, passwordConfirmation),
    };
  }

  // Валидация формы сброса пароля
  static Map<String, String?> validateResetPasswordForm({
    required String email,
  }) {
    return {
      'email': validateEmail(email),
    };
  }

  // Проверка валидности формы
  static bool isFormValid(Map<String, String?> errors) {
    return errors.values.every((error) => error == null);
  }

  // Получение первой ошибки
  static String? getFirstError(Map<String, String?> errors) {
    for (final error in errors.values) {
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}

import '../constants/app_constants.dart';

class ValidationUtils {
  /// Валидация email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.errorMessages['emailRequired'];
    }
    
    final emailRegex = RegExp(AppConstants.emailRegex);
    if (!emailRegex.hasMatch(value)) {
      return AppConstants.errorMessages['emailInvalid'];
    }
    
    return null;
  }
  
  /// Валидация пароля
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.errorMessages['passwordRequired'];
    }
    
    if (value.length < AppConstants.minPasswordLength) {
      return AppConstants.errorMessages['passwordTooShort'];
    }
    
    return null;
  }
  
  /// Валидация подтверждения пароля
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AppConstants.errorMessages['passwordRequired'];
    }
    
    if (value != password) {
      return AppConstants.errorMessages['passwordsDoNotMatch'];
    }
    
    return null;
  }
  
  /// Валидация имени
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.errorMessages['nameRequired'];
    }
    
    if (value.trim().length < 2) {
      return 'Имя должно содержать минимум 2 символа';
    }
    
    return null;
  }
  
  /// Валидация принятия условий
  static String? validateTerms(bool? value) {
    if (value != true) {
      return AppConstants.errorMessages['termsNotAccepted'];
    }
    
    return null;
  }
  
  /// Очистка email от лишних пробелов
  static String cleanEmail(String email) {
    return email.trim().toLowerCase();
  }
  
  /// Очистка имени от лишних пробелов
  static String cleanName(String name) {
    return name.trim();
  }
} 
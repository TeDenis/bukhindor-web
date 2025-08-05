import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../utils/validation_utils.dart';
import '../utils/format_utils.dart';
import '../utils/navigation_utils.dart';
import '../utils/animation_utils.dart';
import '../utils/style_utils.dart';

/// Примеры использования утилит для разработчиков
class UsageExamples {
  
  /// Пример использования констант
  static void constantsExample() {
    // Использование названия приложения
    const appName = AppConstants.appName; // 'Bukhindor'
    
    // Использование текстов
    final loginText = AppConstants.authTexts['login']; // 'Войти'
    
    // Использование сообщений об ошибках
    final emailError = AppConstants.errorMessages['emailRequired']; // 'Email обязателен'
    
    // Использование размеров
    const borderRadius = AppConstants.buttonBorderRadius; // 16.0
  }
  
  /// Пример использования валидации
  static String? validateFormExample(String? email, String? password) {
    // Валидация email
    final emailError = ValidationUtils.validateEmail(email);
    if (emailError != null) return emailError;
    
    // Валидация пароля
    final passwordError = ValidationUtils.validatePassword(password);
    if (passwordError != null) return passwordError;
    
    return null;
  }
  
  /// Пример использования форматирования
  static void formattingExample() {
    final date = DateTime.now();
    final formattedDate = FormatUtils.formatDate(date); // '25.12.2024'
    
    const email = 'user@example.com';
    final maskedEmail = FormatUtils.maskEmail(email); // 'u***r@example.com'
    
    const name = 'john doe';
    final formattedName = FormatUtils.formatDisplayName(name); // 'John doe'
  }
  
  /// Пример использования навигации
  static void navigationExample(BuildContext context) {
    // Переход на страницу входа
    NavigationUtils.goToLogin(context);
    
    // Переход на домашнюю страницу
    NavigationUtils.goToHome(context);
    
    // Проверка текущей страницы
    final isOnAuthPage = NavigationUtils.isOnAuthPage(context);
    
    // Получение текущего маршрута
    final currentRoute = NavigationUtils.getCurrentRoute(context);
  }
  
  /// Пример использования анимаций
  static void animationExample(TickerProvider vsync) {
    // Создание контроллеров
    final fadeController = AnimationUtils.createFadeController(vsync);
    final slideController = AnimationUtils.createSlideController(vsync);
    
    // Создание анимаций
    final fadeAnimation = AnimationUtils.createFadeAnimation(fadeController);
    final slideAnimation = AnimationUtils.createSlideAnimation(slideController);
    
    // Запуск анимаций
    AnimationUtils.startPageAnimations(fadeController, slideController);
    
    // Освобождение ресурсов
    AnimationUtils.disposeAnimations([fadeController, slideController]);
  }
  
  /// Пример использования стилей
  static Widget styleExample(BuildContext context) {
    return Column(
      children: [
        // Заголовок
        Text(
          'Заголовок',
          style: StyleUtils.createHeadlineStyle(context),
        ),
        
        // Подзаголовок
        Text(
          'Подзаголовок',
          style: StyleUtils.createSubtitleStyle(context),
        ),
        
        // Кнопка
        ElevatedButton(
          onPressed: () {},
          style: StyleUtils.createPrimaryButtonStyle(context),
          child: const Text('Кнопка'),
        ),
        
        // Текстовое поле
        TextFormField(
          decoration: StyleUtils.createTextFieldDecoration(
            context,
            labelText: 'Email',
            hintText: 'Введите email',
            prefixIcon: Icons.email,
          ),
        ),
        
        // Карточка
        Container(
          decoration: StyleUtils.createCardDecoration(context),
          padding: const EdgeInsets.all(AppConstants.cardPadding),
          child: const Text('Содержимое карточки'),
        ),
      ],
    );
  }
  
  /// Пример создания новой страницы с утилитами
  static Widget createPageExample(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: StyleUtils.createBackgroundGradient(context),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            children: [
              Text(
                'Новая страница',
                style: StyleUtils.createHeadlineStyle(context),
              ),
              const SizedBox(height: AppConstants.largePadding),
              Text(
                'Описание страницы',
                style: StyleUtils.createSubtitleStyle(context),
              ),
              const SizedBox(height: AppConstants.largePadding),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => NavigationUtils.goToLogin(context),
                      style: StyleUtils.createPrimaryButtonStyle(context),
                      child: Text(AppConstants.authTexts['login']!),
                    ),
                  ),
                  const SizedBox(width: AppConstants.defaultPadding),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => NavigationUtils.goToRegister(context),
                      style: StyleUtils.createSecondaryButtonStyle(context),
                      child: Text(AppConstants.authTexts['register']!),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
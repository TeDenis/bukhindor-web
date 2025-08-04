import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class StyleUtils {
  /// Создание стиля для заголовка
  static TextStyle createHeadlineStyle(BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return Theme.of(context).textTheme.headlineLarge?.copyWith(
      fontSize: fontSize ?? 32,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color ?? Theme.of(context).colorScheme.primary,
    ) ?? const TextStyle();
  }
  
  /// Создание стиля для подзаголовка
  static TextStyle createSubtitleStyle(BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontSize: fontSize ?? 16,
      fontWeight: fontWeight ?? FontWeight.w300,
      color: color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9),
    ) ?? const TextStyle();
  }
  
  /// Создание стиля для основного текста
  static TextStyle createBodyStyle(BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Theme.of(context).colorScheme.onSurface,
    ) ?? const TextStyle();
  }
  
  /// Создание стиля для кнопки
  static ButtonStyle createPrimaryButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.largePadding,
        vertical: AppConstants.defaultPadding,
      ),
    );
  }
  
  /// Создание стиля для вторичной кнопки
  static ButtonStyle createSecondaryButtonStyle(BuildContext context) {
    return OutlinedButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.primary,
      side: BorderSide(color: Theme.of(context).colorScheme.primary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.largePadding,
        vertical: AppConstants.defaultPadding,
      ),
    );
  }
  
  /// Создание стиля для текстового поля
  static InputDecoration createTextFieldDecoration(
    BuildContext context, {
    required String labelText,
    String? hintText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconPressed,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      suffixIcon: suffixIcon != null 
        ? IconButton(
            icon: Icon(suffixIcon),
            onPressed: onSuffixIconPressed,
          )
        : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.textFieldBorderRadius),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.textFieldBorderRadius),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.textFieldBorderRadius),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.textFieldBorderRadius),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.textFieldBorderRadius),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: 2,
        ),
      ),
    );
  }
  
  /// Создание стиля для карточки
  static BoxDecoration createCardDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
  
  /// Создание градиента для фона
  static LinearGradient createBackgroundGradient(BuildContext context) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
        Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.05),
      ],
    );
  }
  
  /// Создание градиента для кнопки
  static LinearGradient createButtonGradient(BuildContext context) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.secondary,
      ],
    );
  }
  
  /// Получение цвета для статуса
  static Color getStatusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'active':
      case 'verified':
        return Colors.green;
      case 'warning':
      case 'pending':
        return Colors.orange;
      case 'error':
      case 'inactive':
      case 'unverified':
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.onSurface;
    }
  }
} 
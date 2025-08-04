import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AnimationUtils {
  /// Создание контроллера fade анимации
  static AnimationController createFadeController(TickerProvider vsync) {
    return AnimationController(
      duration: AppConstants.fadeAnimationDuration,
      vsync: vsync,
    );
  }
  
  /// Создание fade анимации
  static Animation<double> createFadeAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
  }
  
  /// Создание контроллера slide анимации
  static AnimationController createSlideController(TickerProvider vsync) {
    return AnimationController(
      duration: AppConstants.slideAnimationDuration,
      vsync: vsync,
    );
  }
  
  /// Создание slide анимации
  static Animation<Offset> createSlideAnimation(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    ));
  }
  
  /// Создание контроллера scale анимации
  static AnimationController createScaleController(TickerProvider vsync) {
    return AnimationController(
      duration: AppConstants.fadeAnimationDuration,
      vsync: vsync,
    );
  }
  
  /// Создание scale анимации
  static Animation<double> createScaleAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.elasticOut,
    ));
  }
  
  /// Создание контроллера liquid анимации
  static AnimationController createLiquidController(TickerProvider vsync) {
    return AnimationController(
      duration: AppConstants.liquidAnimationDuration,
      vsync: vsync,
    );
  }
  
  /// Создание liquid анимации
  static Animation<double> createLiquidAnimation(AnimationController controller) {
    return Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159, // 2 * pi
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));
  }
  
  /// Запуск fade и slide анимаций
  static void startPageAnimations(AnimationController fadeController, AnimationController slideController) {
    fadeController.forward();
    slideController.forward();
  }
  
  /// Запуск liquid анимации в цикле
  static void startLiquidAnimation(AnimationController liquidController) {
    liquidController.repeat();
  }
  
  /// Остановка всех анимаций
  static void stopAllAnimations(List<AnimationController> controllers) {
    for (final controller in controllers) {
      controller.stop();
    }
  }
  
  /// Освобождение ресурсов анимаций
  static void disposeAnimations(List<AnimationController> controllers) {
    for (final controller in controllers) {
      controller.dispose();
    }
  }
  
  /// Создание staggered анимации для списка элементов
  static List<Animation<double>> createStaggeredAnimations(
    AnimationController controller,
    int itemCount, {
    double stagger = 0.1,
  }) {
    final animations = <Animation<double>>[];
    
    for (int i = 0; i < itemCount; i++) {
      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(
          i * stagger,
          (i + 1) * stagger,
          curve: Curves.easeInOut,
        ),
      ));
      
      animations.add(animation);
    }
    
    return animations;
  }
} 
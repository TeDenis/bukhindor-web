import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';

class NavigationUtils {
  /// Переход на splash страницу
  static void goToSplash(BuildContext context) {
    context.go(AppConstants.splashRoute);
  }
  
  /// Переход на страницу входа
  static void goToLogin(BuildContext context) {
    context.go(AppConstants.loginRoute);
  }
  
  /// Переход на страницу регистрации
  static void goToRegister(BuildContext context) {
    context.go(AppConstants.registerRoute);
  }
  
  /// Переход на домашнюю страницу
  static void goToHome(BuildContext context) {
    context.go(AppConstants.homeRoute);
  }
  
  /// Переход на страницу входа с заменой текущего маршрута
  static void replaceWithLogin(BuildContext context) {
    context.go(AppConstants.loginRoute);
  }
  
  /// Переход на домашнюю страницу с заменой текущего маршрута
  static void replaceWithHome(BuildContext context) {
    context.go(AppConstants.homeRoute);
  }
  
  /// Возврат на предыдущую страницу
  static void goBack(BuildContext context) {
    context.pop();
  }
  
  /// Проверка, находится ли пользователь на определенной странице
  static bool isOnPage(BuildContext context, String route) {
    return GoRouterState.of(context).matchedLocation == route;
  }
  
  /// Получение текущего маршрута
  static String getCurrentRoute(BuildContext context) {
    return GoRouterState.of(context).matchedLocation;
  }
  
  /// Проверка, находится ли пользователь на странице авторизации
  static bool isOnAuthPage(BuildContext context) {
    final currentRoute = getCurrentRoute(context);
    return currentRoute == AppConstants.loginRoute || 
           currentRoute == AppConstants.registerRoute;
  }
  
  /// Проверка, находится ли пользователь на splash странице
  static bool isOnSplashPage(BuildContext context) {
    return getCurrentRoute(context) == AppConstants.splashRoute;
  }
} 
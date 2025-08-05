import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Конфигурация для анимации пива
class BeerAnimationConfig {
  // Общие настройки
  final int bubbleCount;
  final int foamBubbleCount;
  final double topMarginPercent; // Отступ сверху в процентах
  final double coveragePercent; // Покрытие экрана в процентах
  
  // Настройки пузырьков
  final double minBubbleSize;
  final double maxBubbleSize;
  final double minBubbleSpeed;
  final double maxBubbleSpeed;
  final double bubbleOpacity;
  
  // Настройки пены
  final double minFoamSize;
  final double maxFoamSize;
  final double minFoamSpeed;
  final double maxFoamSpeed;
  final double foamOpacity;
  
  // Временные настройки
  final Duration bubbleAnimationDuration;
  final Duration foamAnimationDuration;
  final Duration liquidAnimationDuration;
  
  // Цветовые настройки
  final List<Color> beerColors;
  final List<Color> foamColors;
  final Color bubbleColor;
  
  const BeerAnimationConfig({
    // Общие настройки
    this.bubbleCount = 50,
    this.foamBubbleCount = 30,
    this.topMarginPercent = 0.1, // 10% отступ сверху
    this.coveragePercent = 0.9,  // 90% покрытие
    
    // Настройки пузырьков
    this.minBubbleSize = 2.0,
    this.maxBubbleSize = 8.0,
    this.minBubbleSpeed = 0.3,
    this.maxBubbleSpeed = 1.2,
    this.bubbleOpacity = 0.6,
    
    // Настройки пены
    this.minFoamSize = 3.0,
    this.maxFoamSize = 12.0,
    this.minFoamSpeed = 0.2,
    this.maxFoamSpeed = 0.8,
    this.foamOpacity = 0.8,
    
    // Временные настройки
    this.bubbleAnimationDuration = const Duration(seconds: 8),
    this.foamAnimationDuration = const Duration(seconds: 6),
    this.liquidAnimationDuration = const Duration(seconds: 10),
    
    // Цветовые настройки
    this.beerColors = const [
      Color(0xFFFFF8DC), // Cornsilk
      Color(0xFFFFD700), // Gold
      Color(0xFFFFA500), // Orange
    ],
    this.foamColors = const [
      Color(0xFFFFFFFF), // White
      Color(0xFFFFFAF0), // Floral White
      Color(0xFFF5F5DC), // Beige
    ],
    this.bubbleColor = const Color(0xFFFFD700), // Gold для лучшей видимости
  });
  
  /// Конфигурация для фонового использования (более тонкая)
  static const BeerAnimationConfig background = BeerAnimationConfig(
    bubbleCount: 35,
    foamBubbleCount: 20,
    bubbleOpacity: 0.8, // Увеличил с 0.3 до 0.8 для видимости
    foamOpacity: 0.7,   // Увеличил с 0.4 до 0.7 для видимости
    minBubbleSize: 3.0, // Увеличил размер с 1.5 до 3.0
    maxBubbleSize: 12.0, // Увеличил размер с 6.0 до 12.0
    bubbleAnimationDuration: Duration(seconds: 12),
    foamAnimationDuration: Duration(seconds: 10),
  );
  
  /// Конфигурация для splash экрана (более интенсивная)
  static const BeerAnimationConfig splash = BeerAnimationConfig(
    bubbleCount: 60,
    foamBubbleCount: 40,
    bubbleOpacity: 0.7,
    foamOpacity: 0.9,
    maxBubbleSize: 10.0,
    maxFoamSize: 15.0,
    bubbleAnimationDuration: Duration(seconds: 6),
    foamAnimationDuration: Duration(seconds: 4),
  );
  
  /// Адаптация цветов под тему
  BeerAnimationConfig adaptForTheme(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    
    if (isDark) {
      return BeerAnimationConfig(
        bubbleCount: bubbleCount,
        foamBubbleCount: foamBubbleCount,
        topMarginPercent: topMarginPercent,
        coveragePercent: coveragePercent,
        minBubbleSize: minBubbleSize,
        maxBubbleSize: maxBubbleSize,
        minBubbleSpeed: minBubbleSpeed,
        maxBubbleSpeed: maxBubbleSpeed,
        bubbleOpacity: bubbleOpacity * 0.7, // Менее яркие в темной теме
        minFoamSize: minFoamSize,
        maxFoamSize: maxFoamSize,
        minFoamSpeed: minFoamSpeed,
        maxFoamSpeed: maxFoamSpeed,
        foamOpacity: foamOpacity * 0.6,
        bubbleAnimationDuration: bubbleAnimationDuration,
        foamAnimationDuration: foamAnimationDuration,
        liquidAnimationDuration: liquidAnimationDuration,
        beerColors: [
          const Color(0xFF4A4A4A), // Dark Gray
          const Color(0xFF8B4513), // Saddle Brown
          const Color(0xFFB8860B), // Dark Goldenrod
        ],
        foamColors: [
          const Color(0x88FFFFFF), // Semi-transparent White
          const Color(0x77F5F5DC), // Semi-transparent Beige
          const Color(0x66FFFACD), // Semi-transparent Lemon Chiffon
        ],
        bubbleColor: const Color(0x99FFFFFF), // Semi-transparent White
      );
    }
    
    return this; // Светлая тема использует оригинальные цвета
  }
}

/// Улучшенный менеджер анимации пива с бесшовным циклом
class BeerAnimationManager {
  static final BeerAnimationManager _instance = BeerAnimationManager._internal();
  factory BeerAnimationManager() => _instance;
  BeerAnimationManager._internal();

  AnimationController? _bubbleController;
  AnimationController? _foamController;
  AnimationController? _liquidController;
  bool _isInitialized = false;
  BeerAnimationConfig _config = const BeerAnimationConfig();

  void initialize(TickerProvider vsync, {BeerAnimationConfig? config}) {
    if (_isInitialized) return;
    
    _config = config ?? const BeerAnimationConfig();
    
    _bubbleController = AnimationController(
      duration: _config.bubbleAnimationDuration,
      vsync: vsync,
    )..repeat();
    
    _foamController = AnimationController(
      duration: _config.foamAnimationDuration,
      vsync: vsync,
    )..repeat();
    
    _liquidController = AnimationController(
      duration: _config.liquidAnimationDuration,
      vsync: vsync,
    )..repeat();
    
    _isInitialized = true;
  }

  void dispose() {
    _bubbleController?.dispose();
    _foamController?.dispose();
    _liquidController?.dispose();
    _isInitialized = false;
  }

  AnimationController? get bubbleController => _bubbleController;
  AnimationController? get foamController => _foamController;
  AnimationController? get liquidController => _liquidController;
  bool get isInitialized => _isInitialized;
  BeerAnimationConfig get config => _config;

  /// Генерация пузырьков с улучшенной рандомизацией и бесшовным циклом
  List<BeerBubble> generateBubbles(double screenWidth, double screenHeight) {
    final random = math.Random();
    final bubbles = <BeerBubble>[];
    
    final animationHeight = screenHeight * _config.coveragePercent;
    final startY = screenHeight * _config.topMarginPercent;
    
    for (int i = 0; i < _config.bubbleCount; i++) {
      // Создаем различные "слои" пузырьков для более естественного вида
      final layer = i % 6; // Увеличиваем количество слоев для большей хаотичности
      
      // Полностью случайный timeOffset для хаотичного появления
      final randomOffset = random.nextDouble();
      final layerDelay = (layer / 6.0) * 0.8; // Слои с разными задержками
      final chaosOffset = random.nextDouble() * 0.5; // Дополнительная хаотичность
      
      bubbles.add(BeerBubble(
        id: i,
        initialX: random.nextDouble() * screenWidth,
        startY: startY + animationHeight + random.nextDouble() * 100,
        endY: startY - 50,
        size: _config.minBubbleSize + 
              random.nextDouble() * (_config.maxBubbleSize - _config.minBubbleSize),
        speed: _config.minBubbleSpeed + 
               random.nextDouble() * (_config.maxBubbleSpeed - _config.minBubbleSpeed),
        // Хаотичный timeOffset для случайного появления
        timeOffset: (randomOffset + layerDelay + chaosOffset) % 1.0,
        horizontalAmplitude: 15 + random.nextDouble() * 25,
        horizontalFrequency: 1 + random.nextDouble() * 3,
        opacity: _config.bubbleOpacity * (0.6 + random.nextDouble() * 0.4),
        // Добавляем случайные фазовые сдвиги для более хаотичного движения
        phaseShift: random.nextDouble() * 2 * math.pi,
      ));
    }
    
    return bubbles;
  }

  /// Генерация пены с улучшенной рандомизацией
  List<BeerFoam> generateFoamBubbles(double screenWidth, double screenHeight) {
    final random = math.Random();
    final foamBubbles = <BeerFoam>[];
    
    final foamZoneHeight = screenHeight * 0.25; // Зона пены - 25% экрана
    final foamStartY = screenHeight * _config.topMarginPercent + 
                      screenHeight * _config.coveragePercent * 0.7;
    
    for (int i = 0; i < _config.foamBubbleCount; i++) {
      // Полностью случайное появление пены
      final randomDelay = random.nextDouble();
      final chaosOffset = random.nextDouble() * 0.7;
      
      foamBubbles.add(BeerFoam(
        id: i,
        initialX: random.nextDouble() * screenWidth,
        startY: foamStartY + foamZoneHeight + random.nextDouble() * 50,
        endY: foamStartY - 25,
        size: _config.minFoamSize + 
              random.nextDouble() * (_config.maxFoamSize - _config.minFoamSize),
        speed: _config.minFoamSpeed + 
               random.nextDouble() * (_config.maxFoamSpeed - _config.minFoamSpeed),
        // Хаотичный timeOffset для случайного появления
        timeOffset: (randomDelay + chaosOffset) % 1.0,
        horizontalAmplitude: 8 + random.nextDouble() * 15,
        horizontalFrequency: 0.5 + random.nextDouble() * 2,
        opacity: _config.foamOpacity * (0.7 + random.nextDouble() * 0.3),
        // Добавляем фазовый сдвиг для хаотичности
        phaseShift: random.nextDouble() * 2 * math.pi,
      ));
    }
    
    return foamBubbles;
  }
}

/// Модель пузырька с расширенными параметрами для бесшовной анимации
class BeerBubble {
  final int id;
  final double initialX;
  final double startY;
  final double endY;
  final double size;
  final double speed;
  final double timeOffset; // Ключевой параметр для бесшовности
  final double horizontalAmplitude;
  final double horizontalFrequency;
  final double opacity;
  final double phaseShift; // Дополнительный фазовый сдвиг для хаотичности
  
  BeerBubble({
    required this.id,
    required this.initialX,
    required this.startY,
    required this.endY,
    required this.size,
    required this.speed,
    required this.timeOffset,
    required this.horizontalAmplitude,
    required this.horizontalFrequency,
    required this.opacity,
    this.phaseShift = 0.0,
  });
  
  /// Вычисляет позицию с бесшовным циклом и хаотичным движением
  Offset getPosition(double animationValue) {
    // Нормализуем время с учетом offset для бесшовности
    final normalizedTime = (animationValue + timeOffset) % 1.0;
    
    // Вертикальная позиция
    final y = startY - (normalizedTime * (startY - endY));
    
    // Горизонтальная позиция с более сложным волновым движением
    final baseWave = math.sin((normalizedTime * horizontalFrequency * 2 * math.pi) + phaseShift);
    final chaosWave = math.sin((normalizedTime * horizontalFrequency * 4 * math.pi) + phaseShift * 1.5) * 0.3;
    final x = initialX + (baseWave + chaosWave) * horizontalAmplitude;
    
    return Offset(x, y);
  }
  
  /// Проверяет, должен ли пузырек быть видимым
  bool isVisible(double animationValue) {
    final position = getPosition(animationValue);
    return position.dy > (endY - 50) && position.dy < (startY + 50);
  }
}

/// Модель пены
class BeerFoam {
  final int id;
  final double initialX;
  final double startY;
  final double endY;
  final double size;
  final double speed;
  final double timeOffset;
  final double horizontalAmplitude;
  final double horizontalFrequency;
  final double opacity;
  final double phaseShift; // Дополнительный фазовый сдвиг для хаотичности
  
  BeerFoam({
    required this.id,
    required this.initialX,
    required this.startY,
    required this.endY,
    required this.size,
    required this.speed,
    required this.timeOffset,
    required this.horizontalAmplitude,
    required this.horizontalFrequency,
    required this.opacity,
    this.phaseShift = 0.0,
  });
  
  Offset getPosition(double animationValue) {
    final normalizedTime = (animationValue + timeOffset) % 1.0;
    final y = startY - (normalizedTime * (startY - endY));
    
    // Более хаотичное движение пены с фазовым сдвигом
    final baseWave = math.sin((normalizedTime * horizontalFrequency * 2 * math.pi) + phaseShift);
    final microWave = math.sin((normalizedTime * horizontalFrequency * 6 * math.pi) + phaseShift * 2) * 0.2;
    final x = initialX + (baseWave + microWave) * horizontalAmplitude;
    
    return Offset(x, y);
  }
  
  bool isVisible(double animationValue) {
    final position = getPosition(animationValue);
    return position.dy > (endY - 25) && position.dy < (startY + 25);
  }
}
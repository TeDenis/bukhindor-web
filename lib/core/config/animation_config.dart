import 'package:flutter/material.dart';
import 'dart:math' as math;

class BeerAnimationManager {
  static final BeerAnimationManager _instance = BeerAnimationManager._internal();
  factory BeerAnimationManager() => _instance;
  BeerAnimationManager._internal();

  AnimationController? _bubbleController;
  AnimationController? _foamController;
  AnimationController? _liquidController;
  TickerProvider? _vsync;
  bool _isInitialized = false;

  void initialize(TickerProvider vsync) {
    if (_isInitialized) return;
    
    _vsync = vsync;
    
    _bubbleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: vsync,
    )..repeat();
    
    _foamController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: vsync,
    )..repeat();
    
    _liquidController = AnimationController(
      duration: const Duration(seconds: 4),
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

  // Генерация стабильных пузырьков
  List<Bubble> generateBubbles() {
    final random = math.Random(42); // Фиксированное зерно для стабильности
    final bubbles = <Bubble>[];
    
    for (int i = 0; i < 15; i++) {
      bubbles.add(Bubble(
        x: random.nextDouble() * 300,
        y: 400 + random.nextDouble() * 100,
        size: 3 + random.nextDouble() * 8,
        speed: 0.5 + random.nextDouble() * 1.5,
        offset: random.nextDouble(), // Смещение для разных стартовых позиций
      ));
    }
    
    return bubbles;
  }

  // Генерация стабильной пены
  List<FoamBubble> generateFoamBubbles() {
    final random = math.Random(123); // Фиксированное зерно для стабильности
    final foamBubbles = <FoamBubble>[];
    
    for (int i = 0; i < 20; i++) {
      foamBubbles.add(FoamBubble(
        x: random.nextDouble() * 300,
        y: 350 + random.nextDouble() * 50,
        size: 2 + random.nextDouble() * 6,
        speed: 0.3 + random.nextDouble() * 0.7,
        offset: random.nextDouble(), // Смещение для разных стартовых позиций
      ));
    }
    
    return foamBubbles;
  }
}

class Bubble {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double offset;
  
  Bubble({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.offset,
  });
}

class FoamBubble {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double offset;
  
  FoamBubble({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.offset,
  });
} 
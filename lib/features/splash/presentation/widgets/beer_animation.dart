import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../../core/config/animation_config.dart';

class BeerAnimation extends StatefulWidget {
  const BeerAnimation({super.key});

  @override
  State<BeerAnimation> createState() => _BeerAnimationState();
}

class _BeerAnimationState extends State<BeerAnimation>
    with TickerProviderStateMixin {
  final BeerAnimationManager _animationManager = BeerAnimationManager();
  late List<Bubble> _bubbles;
  late List<FoamBubble> _foamBubbles;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    if (_isInitialized) return;
    
    // Инициализируем глобальный менеджер анимации
    _animationManager.initialize(this);
    
    // Генерируем стабильные пузырьки и пену
    _bubbles = _animationManager.generateBubbles();
    _foamBubbles = _animationManager.generateFoamBubbles();
    
    _isInitialized = true;
  }

  @override
  void dispose() {
    // НЕ удаляем контроллеры здесь, так как они глобальные
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Проверяем, что анимация инициализирована
    if (!_isInitialized || 
        _animationManager.bubbleController == null ||
        _animationManager.foamController == null ||
        _animationManager.liquidController == null) {
      return const SizedBox(
        width: 300,
        height: 500,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      width: 300,
      height: 500,
      child: Stack(
        children: [
          // Размытый фон
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.amber.shade100,
                    Colors.amber.shade200,
                    Colors.amber.shade300,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          
          // Жидкость (пиво)
          AnimatedBuilder(
            animation: _animationManager.liquidController!,
            builder: (context, child) {
              return Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 350 + math.sin(_animationManager.liquidController!.value * 2 * math.pi) * 10,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.amber.shade400,
                        Colors.amber.shade600,
                        Colors.amber.shade800,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Пузырьки
          ..._bubbles.map((bubble) => AnimatedBuilder(
            animation: _animationManager.bubbleController!,
            builder: (context, child) {
              // Используем offset для создания непрерывной анимации
              final progress = (_animationManager.bubbleController!.value + bubble.offset) % 1.0;
              final y = bubble.y - progress * 400;
              
              if (y < 50) return const SizedBox.shrink();
              
              return Positioned(
                left: bubble.x + math.sin(progress * 4 * math.pi) * 10,
                top: y,
                child: Container(
                  width: bubble.size,
                  height: bubble.size,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.3),
                        blurRadius: 2,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
          
          // Пена
          ..._foamBubbles.map((foam) => AnimatedBuilder(
            animation: _animationManager.foamController!,
            builder: (context, child) {
              // Используем offset для создания непрерывной анимации
              final progress = (_animationManager.foamController!.value + foam.offset) % 1.0;
              final y = foam.y - progress * 100;
              
              if (y < 300) return const SizedBox.shrink();
              
              return Positioned(
                left: foam.x + math.sin(progress * 6 * math.pi) * 5,
                top: y,
                child: Container(
                  width: foam.size,
                  height: foam.size,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.5),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
          
          // Верхняя пена
          Positioned(
            top: 300,
            left: 0,
            right: 0,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: CustomPaint(
                painter: FoamPainter(_animationManager.foamController!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FoamPainter extends CustomPainter {
  final Animation<double> animation;
  
  FoamPainter(this.animation) : super(repaint: animation);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(0, size.height);
    
    for (double x = 0; x <= size.width; x += 5) {
      final y = size.height * 0.3 + 
                math.sin((x / size.width * 4 + animation.value * 2) * math.pi) * 10 +
                math.sin((x / size.width * 8 + animation.value * 4) * math.pi) * 5;
      path.lineTo(x, y);
    }
    
    path.lineTo(size.width, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 
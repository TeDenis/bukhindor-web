import 'package:flutter/material.dart';
import 'dart:math' as math;

class BackgroundAnimation extends StatefulWidget {
  final Widget child;
  final bool enableWaves;
  final bool enableBubbles;
  final Color? waveColor;
  final Color? bubbleColor;
  final double waveOpacity;
  final double bubbleOpacity;

  const BackgroundAnimation({
    super.key,
    required this.child,
    this.enableWaves = true,
    this.enableBubbles = true,
    this.waveColor,
    this.bubbleColor,
    this.waveOpacity = 0.1,
    this.bubbleOpacity = 0.05,
  });

  @override
  State<BackgroundAnimation> createState() => _BackgroundAnimationState();
}

class _BackgroundAnimationState extends State<BackgroundAnimation>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _bubbleController;
  
  final List<Wave> _waves = [];
  final List<Bubble> _bubbles = [];

  @override
  void initState() {
    super.initState();
    
    _waveController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
    
    _bubbleController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();
    
    // Создаем волны
    if (widget.enableWaves) {
      for (int i = 0; i < 3; i++) {
        _waves.add(Wave(
          amplitude: 20 + i * 10,
          frequency: 0.5 + i * 0.3,
          speed: 0.3 + i * 0.2,
          offset: i * 0.3,
        ));
      }
    }
    
    // Создаем пузырьки
    if (widget.enableBubbles) {
      for (int i = 0; i < 25; i++) {
        _bubbles.add(Bubble(
          x: math.Random().nextDouble(),
          y: math.Random().nextDouble(),
          size: 2 + math.Random().nextDouble() * 6,
          speed: 0.2 + math.Random().nextDouble() * 0.8,
          delay: math.Random().nextDouble() * 2,
        ));
      }
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Фоновый градиент
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.background,
                  Theme.of(context).colorScheme.surface,
                ],
              ),
            ),
          ),
        ),
        
        // Волны
        if (widget.enableWaves)
          ..._waves.map((wave) => AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              return Positioned.fill(
                child: CustomPaint(
                  painter: WavePainter(
                    wave: wave,
                    animation: _waveController,
                    color: widget.waveColor ?? Theme.of(context).colorScheme.primary,
                    opacity: widget.waveOpacity,
                  ),
                ),
              );
            },
          )),
        
        // Пузырьки
        if (widget.enableBubbles)
          ..._bubbles.map((bubble) => AnimatedBuilder(
            animation: _bubbleController,
            builder: (context, child) {
              final progress = (_bubbleController.value + bubble.delay) % 1.0;
              final y = bubble.y - progress;
              
              if (y < -0.1) return const SizedBox.shrink();
              
              return Positioned(
                left: bubble.x * MediaQuery.of(context).size.width,
                top: y * MediaQuery.of(context).size.height,
                child: Container(
                  width: bubble.size,
                  height: bubble.size,
                  decoration: BoxDecoration(
                    color: (widget.bubbleColor ?? Theme.of(context).colorScheme.primary)
                        .withValues(alpha: widget.bubbleOpacity),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (widget.bubbleColor ?? Theme.of(context).colorScheme.primary)
                            .withValues(alpha: widget.bubbleOpacity * 0.5),
                        blurRadius: 2,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
        
        // Основной контент
        Positioned.fill(child: widget.child),
      ],
    );
  }
}

class Wave {
  final double amplitude;
  final double frequency;
  final double speed;
  final double offset;
  
  Wave({
    required this.amplitude,
    required this.frequency,
    required this.speed,
    required this.offset,
  });
}

class Bubble {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double delay;
  
  Bubble({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.delay,
  });
}

class WavePainter extends CustomPainter {
  final Wave wave;
  final Animation<double> animation;
  final Color color;
  final double opacity;
  
  WavePainter({
    required this.wave,
    required this.animation,
    required this.color,
    required this.opacity,
  }) : super(repaint: animation);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    final path = Path();
    path.moveTo(0, size.height);
    
    for (double x = 0; x <= size.width; x += 2) {
      final normalizedX = x / size.width;
      final y = size.height * 0.8 + 
                wave.amplitude * 
                math.sin((normalizedX * wave.frequency + 
                         animation.value * wave.speed + 
                         wave.offset) * 2 * math.pi);
      path.lineTo(x, y);
    }
    
    path.lineTo(size.width, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 
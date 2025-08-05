import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../config/beer_animation_config.dart';

/// Универсальный компонент фоновой анимации пива
/// Используется как задник на всех страницах приложения
class BeerBackgroundAnimation extends StatefulWidget {
  final Widget child;
  final BeerAnimationConfig? config;
  final bool enabled;
  
  const BeerBackgroundAnimation({
    super.key,
    required this.child,
    this.config,
    this.enabled = true,
  });

  @override
  State<BeerBackgroundAnimation> createState() => _BeerBackgroundAnimationState();
}

class _BeerBackgroundAnimationState extends State<BeerBackgroundAnimation>
    with TickerProviderStateMixin {
  
  late AnimationController _bubbleController;
  late AnimationController _foamController;
  late AnimationController _liquidController;
  late BeerAnimationConfig _config;
  
  List<BeerBubble> _bubbles = [];
  List<BeerFoam> _foamBubbles = [];
  
  // Для динамического появления пузырьков
  double _lastRegenerationTime = 0.0;
  final double _regenerationInterval = 0.1; // Каждые 10% анимации
  final math.Random _random = math.Random();
  
  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateConfigForTheme();
  }
  
  void _initializeAnimation() {
    // Используем конфигурацию для фона по умолчанию
    _config = widget.config ?? BeerAnimationConfig.background;
    
    // Debug: Простейшая рабочая конфигурация
    _config = BeerAnimationConfig.background;
    
    _bubbleController = AnimationController(
      duration: _config.bubbleAnimationDuration,
      vsync: this,
    );
    
    _foamController = AnimationController(
      duration: _config.foamAnimationDuration,
      vsync: this,
    );
    
    _liquidController = AnimationController(
      duration: _config.liquidAnimationDuration,
      vsync: this,
    );
    
    if (widget.enabled) {
      _bubbleController.repeat();
      _foamController.repeat();
      _liquidController.repeat();
    }
    
    // Создаем пузырьки после первого build для получения размеров экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _generateBubbles();
      }
    });
  }
  
  void _updateConfigForTheme() {
    _config = (_config).adaptForTheme(Theme.of(context));
  }
  
  void _generateBubbles() {
    final size = MediaQuery.of(context).size;
    
    setState(() {
      // Генерируем пузырьки используя размеры экрана и конфигурацию
      _bubbles = _generateBubblesLocal(size.width, size.height);
      _foamBubbles = _generateFoamBubblesLocal(size.width, size.height);
      
      // Debug: информация о генерации (убираем принты для production)
      // Generated ${_bubbles.length} bubbles and ${_foamBubbles.length} foam bubbles
      // Screen size: ${size.width}x${size.height}
      // Config: bubbleCount=${_config.bubbleCount}, opacity=${_config.bubbleOpacity}
    });
  }
  
  List<BeerBubble> _generateBubblesLocal(double screenWidth, double screenHeight) {
    final List<BeerBubble> bubbles = [];
    final random = math.Random();
    
    for (int i = 0; i < _config.bubbleCount; i++) {
      final bubble = BeerBubble(
        id: i,
        initialX: random.nextDouble() * screenWidth,
        startY: screenHeight * 0.9,  // Простая фиксированная позиция
        endY: screenHeight * 0.1,   // Простая фиксированная позиция
        size: _config.minBubbleSize + random.nextDouble() * (_config.maxBubbleSize - _config.minBubbleSize),
        speed: _config.minBubbleSpeed + random.nextDouble() * (_config.maxBubbleSpeed - _config.minBubbleSpeed),
        timeOffset: random.nextDouble(), // Важно для бесшовности
        phaseShift: random.nextDouble() * 2 * math.pi, // Фазовый сдвиг для хаотичности
        horizontalAmplitude: 10 + random.nextDouble() * 20,
        horizontalFrequency: 2 + random.nextDouble() * 6,
        opacity: _config.bubbleOpacity,
      );
      bubbles.add(bubble);
    }
    
    return bubbles;
  }
  
  List<BeerFoam> _generateFoamBubblesLocal(double screenWidth, double screenHeight) {
    final List<BeerFoam> foamBubbles = [];
    final random = math.Random();
    
    for (int i = 0; i < _config.foamBubbleCount; i++) {
      final foam = BeerFoam(
        id: i,
        initialX: random.nextDouble() * screenWidth,
        startY: screenHeight * 0.15,
        endY: screenHeight * 0.05,
        size: _config.minFoamSize + random.nextDouble() * (_config.maxFoamSize - _config.minFoamSize),
        speed: _config.minFoamSpeed + random.nextDouble() * (_config.maxFoamSpeed - _config.minFoamSpeed),
        timeOffset: random.nextDouble(),
        phaseShift: random.nextDouble() * 2 * math.pi, // Фазовый сдвиг для хаотичности
        horizontalAmplitude: 5 + random.nextDouble() * 10,
        horizontalFrequency: 3 + random.nextDouble() * 4,
        opacity: _config.foamOpacity,
      );
      foamBubbles.add(foam);
    }
    
    return foamBubbles;
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    _foamController.dispose();
    _liquidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Создаем пузырьки если их нет
        if (_bubbles.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _generateBubbles();
            }
          });
        }

        return Stack(
          children: [
            // Фоновый градиент пива
            _buildBackground(context, constraints),
            
            // Анимированные пузырьки (за контентом)
            ..._buildSimpleBubbles(),
            
            // Анимированная пена (за контентом)
            if (_foamBubbles.isNotEmpty) ..._buildFoam(),
            
            // Основной контент ПОВЕРХ анимации
            widget.child,
          ],
        );
      },
    );
  }
  
  // Улучшенная версия пузырьков с бесшовной анимацией и динамической регенерацией
  List<Widget> _buildSimpleBubbles() {
    if (_bubbles.isEmpty) return [];
    
    // Проверяем, нужно ли добавить новые пузырьки для большей хаотичности
    _maybeAddRandomBubbles();
    
    return _bubbles.map((bubble) {
      return AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          // Бесшовная анимация с timeOffset
          final normalizedTime = (_bubbleController.value + bubble.timeOffset) % 1.0;
          
          // Вертикальное движение
          final y = bubble.startY - (normalizedTime * (bubble.startY - bubble.endY));
          
          // Более хаотичное горизонтальное покачивание
          final baseWave = math.sin((normalizedTime * bubble.horizontalFrequency * 2 * math.pi) + bubble.phaseShift);
          final chaosWave = math.sin((normalizedTime * bubble.horizontalFrequency * 4 * math.pi) + bubble.phaseShift * 1.5) * 0.3;
          final x = bubble.initialX + (baseWave + chaosWave) * bubble.horizontalAmplitude;
          
          // Проверка видимости
          if (y > bubble.startY + 50 || y < bubble.endY - 50) {
            return const SizedBox.shrink();
          }
          
          return Positioned(
            left: x,
            top: y,
            child: Container(
              width: bubble.size,
              height: bubble.size,
              decoration: BoxDecoration(
                color: _config.bubbleColor.withValues(alpha: bubble.opacity),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _config.bubbleColor.withValues(alpha: bubble.opacity * 0.3),
                    blurRadius: bubble.size * 0.5,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }).toList();
  }
  
  /// Добавляет случайные пузырьки во время анимации для большей хаотичности
  void _maybeAddRandomBubbles() {
    final currentTime = _bubbleController.value;
    
    // Проверяем, прошло ли достаточно времени с последней регенерации
    if (currentTime - _lastRegenerationTime >= _regenerationInterval) {
      _lastRegenerationTime = currentTime;
      
      // Случайно добавляем 1-3 новых пузырька
      if (_random.nextDouble() < 0.3) { // 30% шанс добавления новых пузырьков
        final size = MediaQuery.of(context).size;
        final newBubblesCount = 1 + _random.nextInt(3);
        
        for (int i = 0; i < newBubblesCount; i++) {
          final newBubble = BeerBubble(
            id: _bubbles.length + i,
            initialX: _random.nextDouble() * size.width,
            startY: size.height * 0.9,
            endY: size.height * 0.1,
            size: _config.minBubbleSize + _random.nextDouble() * (_config.maxBubbleSize - _config.minBubbleSize),
            speed: _config.minBubbleSpeed + _random.nextDouble() * (_config.maxBubbleSpeed - _config.minBubbleSpeed),
            timeOffset: currentTime + _random.nextDouble() * 0.1, // Появляются почти сразу
            phaseShift: _random.nextDouble() * 2 * math.pi,
            horizontalAmplitude: 10 + _random.nextDouble() * 20,
            horizontalFrequency: 2 + _random.nextDouble() * 6,
            opacity: _config.bubbleOpacity * (0.6 + _random.nextDouble() * 0.4),
          );
          
          setState(() {
            _bubbles.add(newBubble);
          });
        }
        
        // Ограничиваем количество пузырьков, удаляя старые
        if (_bubbles.length > _config.bubbleCount * 1.5) {
          setState(() {
            _bubbles.removeRange(0, newBubblesCount);
          });
        }
      }
    }
  }
  
  Widget _buildBackground(BuildContext context, BoxConstraints constraints) {
    return AnimatedBuilder(
      animation: _liquidController,
      builder: (context, child) {
        return Positioned.fill(
          child: Stack(
            children: [
              // Основной градиент пива
              Container(
                decoration: BoxDecoration(
                  gradient: _createBeerGradient(),
                ),
              ),
              
              // Волновой эффект поверх градиента
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: BeerWavePainter(
                  animationValue: _liquidController.value,
                  waveColor: _config.beerColors[1].withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  List<Widget> _buildFoam() {
    if (_foamBubbles.isEmpty) return [];
    
    // Также добавляем динамическую пену
    _maybeAddRandomFoam();
    
    return _foamBubbles.map((foam) {
      return AnimatedBuilder(
        animation: _foamController,
        builder: (context, child) {
          // Бесшовная анимация пены с timeOffset
          final normalizedTime = (_foamController.value + foam.timeOffset) % 1.0;
          final y = foam.startY - (normalizedTime * (foam.startY - foam.endY));
          
          // Более хаотичное движение пены
          final baseWave = math.sin((normalizedTime * foam.horizontalFrequency * 2 * math.pi) + foam.phaseShift);
          final microWave = math.sin((normalizedTime * foam.horizontalFrequency * 6 * math.pi) + foam.phaseShift * 2) * 0.2;
          final x = foam.initialX + (baseWave + microWave) * foam.horizontalAmplitude;
          
          if (y > foam.startY + 20 || y < foam.endY - 20) {
            return const SizedBox.shrink();
          }
          
          return Positioned(
            left: x,
            top: y,
            child: Container(
              width: foam.size,
              height: foam.size,
              decoration: BoxDecoration(
                color: _config.foamColors[0].withValues(alpha: foam.opacity),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _config.foamColors[1].withValues(alpha: foam.opacity * 0.2),
                    blurRadius: foam.size * 0.3,
                    spreadRadius: 0.5,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }).toList();
  }
  
  /// Добавляет случайную пену во время анимации
  void _maybeAddRandomFoam() {
    final currentTime = _foamController.value;
    
    // Пену добавляем реже, чем пузырьки
    if (_random.nextDouble() < 0.2) { // 20% шанс добавления новой пены
      final size = MediaQuery.of(context).size;
      
      final newFoam = BeerFoam(
        id: _foamBubbles.length,
        initialX: _random.nextDouble() * size.width,
        startY: size.height * 0.15,
        endY: size.height * 0.05,
        size: _config.minFoamSize + _random.nextDouble() * (_config.maxFoamSize - _config.minFoamSize),
        speed: _config.minFoamSpeed + _random.nextDouble() * (_config.maxFoamSpeed - _config.minFoamSpeed),
        timeOffset: currentTime + _random.nextDouble() * 0.1,
        phaseShift: _random.nextDouble() * 2 * math.pi,
        horizontalAmplitude: 5 + _random.nextDouble() * 10,
        horizontalFrequency: 3 + _random.nextDouble() * 4,
        opacity: _config.foamOpacity * (0.7 + _random.nextDouble() * 0.3),
      );
      
      setState(() {
        _foamBubbles.add(newFoam);
      });
      
      // Ограничиваем количество пены
      if (_foamBubbles.length > _config.foamBubbleCount * 1.3) {
        setState(() {
          _foamBubbles.removeAt(0);
        });
      }
    }
  }
  
  LinearGradient _createBeerGradient() {
    // Создаем градиент пива с небольшой анимацией
    final progress = _liquidController.value;
    final colors = _config.beerColors;
    
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [
        0.0 + progress * 0.1,
        0.5 + math.sin(progress * 2 * math.pi) * 0.1,
        1.0,
      ],
      colors: [
        colors[0].withValues(alpha: 0.3), // Увеличил с 0.1 до 0.3
        colors[1].withValues(alpha: 0.4), // Увеличил с 0.15 до 0.4
        colors[2].withValues(alpha: 0.3), // Увеличил с 0.1 до 0.3
      ],
    );
  }
  

}

/// Painter для рисования волнового эффекта пива
class BeerWavePainter extends CustomPainter {
  final double animationValue;
  final Color waveColor;
  
  BeerWavePainter({
    required this.animationValue,
    required this.waveColor,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill;
    
    final path = Path();
    
    // Создаем бесшовный волновой эффект
    const waveHeight = 15.0;
    final waveLength = size.width / 2; // Увеличиваем длину волны для плавности
    
    // Используем фазовый сдвиг вместо offset для бесшовности
    final phase1 = animationValue * 2 * math.pi;
    final phase2 = animationValue * 4 * math.pi;
    
    // Первая волна - бесшовная анимация
    path.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x += 5) {
      final normalizedX = x / waveLength;
      final wave1 = math.sin(normalizedX * 2 * math.pi + phase1) * waveHeight;
      final wave2 = math.sin(normalizedX * 4 * math.pi + phase2) * (waveHeight * 0.3);
      final y = size.height * 0.7 + wave1 + wave2;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Вторая волна с другой частотой - также бесшовная
    final paint2 = Paint()
      ..color = waveColor.withValues(alpha: waveColor.alpha * 0.5)
      ..style = PaintingStyle.fill;
    
    final path2 = Path();
    final phase3 = animationValue * 1.5 * math.pi;
    final phase4 = animationValue * 3 * math.pi;
    
    path2.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x += 5) {
      final normalizedX = x / waveLength;
      final wave3 = math.sin(normalizedX * 1.5 * math.pi + phase3) * (waveHeight * 0.7);
      final wave4 = math.sin(normalizedX * 3 * math.pi + phase4) * (waveHeight * 0.2);
      final y = size.height * 0.8 + wave3 + wave4;
      path2.lineTo(x, y);
    }
    path2.lineTo(size.width, size.height);
    path2.close();
    
    canvas.drawPath(path2, paint2);
  }
  
  @override
  bool shouldRepaint(covariant BeerWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.waveColor != waveColor;
  }
}

/// Компонент пивной анимации для splash экрана
/// Использует более интенсивную конфигурацию
class BeerSplashAnimation extends StatefulWidget {
  final double width;
  final double height;
  
  const BeerSplashAnimation({
    super.key,
    this.width = 300,
    this.height = 500,
  });

  @override
  State<BeerSplashAnimation> createState() => _BeerSplashAnimationState();
}

class _BeerSplashAnimationState extends State<BeerSplashAnimation>
    with TickerProviderStateMixin {
  
  final BeerAnimationManager _animationManager = BeerAnimationManager();
  List<BeerBubble> _bubbles = [];
  List<BeerFoam> _foamBubbles = [];
  bool _isInitialized = false;
  late BeerAnimationConfig _config;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateConfigForTheme();
  }

  void _initializeAnimation() {
    if (_isInitialized) return;
    
    _config = BeerAnimationConfig.splash;
    _updateConfigForTheme();
    
    // Инициализируем глобальный менеджер анимации
    _animationManager.initialize(this, config: _config);
    
    // Генерируем пузырьки для конкретного размера виджета
    _bubbles = _animationManager.generateBubbles(widget.width, widget.height);
    _foamBubbles = _animationManager.generateFoamBubbles(widget.width, widget.height);
    
    _isInitialized = true;
  }
  
  void _updateConfigForTheme() {
    if (_isInitialized) {
      setState(() {
        _config = _config.adaptForTheme(Theme.of(context));
      });
    }
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
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          // Фоновый градиент пива
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationManager.liquidController!,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: _config.beerColors,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            ),
          ),
          
          // Анимированные пузырьки
          ..._bubbles.map((bubble) => AnimatedBuilder(
            animation: _animationManager.bubbleController!,
            builder: (context, child) {
              if (!bubble.isVisible(_animationManager.bubbleController!.value)) {
                return const SizedBox.shrink();
              }
              
              final position = bubble.getPosition(_animationManager.bubbleController!.value);
              
              return Positioned(
                left: position.dx,
                top: position.dy,
                child: Container(
                  width: bubble.size,
                  height: bubble.size,
                  decoration: BoxDecoration(
                    color: _config.bubbleColor.withValues(alpha: bubble.opacity),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _config.bubbleColor.withValues(alpha: bubble.opacity * 0.3),
                        blurRadius: bubble.size * 0.3,
                        spreadRadius: bubble.size * 0.1,
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
          
          // Анимированная пена
          ..._foamBubbles.map((foam) => AnimatedBuilder(
            animation: _animationManager.foamController!,
            builder: (context, child) {
              if (!foam.isVisible(_animationManager.foamController!.value)) {
                return const SizedBox.shrink();
              }
              
              final position = foam.getPosition(_animationManager.foamController!.value);
              
              return Positioned(
                left: position.dx,
                top: position.dy,
                child: Container(
                  width: foam.size,
                  height: foam.size,
                  decoration: BoxDecoration(
                    color: _config.foamColors[0].withValues(alpha: foam.opacity),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _config.foamColors[1].withValues(alpha: foam.opacity * 0.4),
                        blurRadius: foam.size * 0.4,
                        spreadRadius: foam.size * 0.15,
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
          
          // Верхняя пена с волнистой поверхностью
          Positioned(
            top: widget.height * 0.6,
            left: 0,
            right: 0,
            height: widget.height * 0.4,
            child: Container(
              decoration: BoxDecoration(
                color: _config.foamColors[0].withValues(alpha: 0.9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: CustomPaint(
                painter: FoamSurfacePainter(_animationManager.foamController!, _config),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Улучшенный painter для поверхности пены
class FoamSurfacePainter extends CustomPainter {
  final Animation<double> animation;
  final BeerAnimationConfig config;
  
  FoamSurfacePainter(this.animation, this.config) : super(repaint: animation);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = config.foamColors[0].withValues(alpha: config.foamOpacity)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(0, size.height);
    
    // Создаем более естественную волнистую поверхность
    for (double x = 0; x <= size.width; x += 3) {
      final normalizedX = x / size.width;
      final wave1 = math.sin((normalizedX * 6 + animation.value * 2) * math.pi) * 8;
      final wave2 = math.sin((normalizedX * 10 + animation.value * 3) * math.pi) * 4;
      final wave3 = math.sin((normalizedX * 14 + animation.value * 1.5) * math.pi) * 2;
      
      final y = size.height * 0.2 + wave1 + wave2 + wave3;
      path.lineTo(x, y);
    }
    
    path.lineTo(size.width, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Добавляем блики на поверхности пены
    final highlightPaint = Paint()
      ..color = config.foamColors[2].withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    final highlightPath = Path();
    for (double x = 0; x <= size.width; x += 5) {
      final normalizedX = x / size.width;
      final wave = math.sin((normalizedX * 4 + animation.value * 2.5) * math.pi) * 6;
      final y = size.height * 0.15 + wave;
      
      if (x == 0) {
        highlightPath.moveTo(x, y);
      } else {
        highlightPath.lineTo(x, y);
      }
    }
    
    canvas.drawPath(highlightPath, highlightPaint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
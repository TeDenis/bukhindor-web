import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../bloc/auth_bloc_simple.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/owl_logo_widget.dart';
// import '../../../core/widgets/app_layout.dart';
// import '../../../core/config/animation_config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _liquidController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _liquidAnimation;
  late Animation<double> _bubbleAnimation;
  
  // Для хаотичных пузырьков
  final List<ChaoticBubble> _chaoticBubbles = [];
  final Random _random = Random();
  bool _hasValidationErrors = false;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _liquidController = AnimationController(
      duration: const Duration(seconds: 8), // Замедляем волну
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _liquidAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0, // Используем 0-1 вместо 0-2π для более плавной анимации
    ).animate(CurvedAnimation(
      parent: _liquidController,
      curve: Curves.linear,
    ));
    
    // Отдельная анимация для пузырьков
    _bubbleAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _liquidController,
      curve: Curves.linear,
    ));
    
    _fadeController.forward();
    _slideController.forward();
    _liquidController.repeat();
    
    // Непрерывная генерация пузырьков через listener
    _liquidController.addListener(() {
      // Генерируем пузырьки чаще - каждые 0.1 секунды (10% от цикла)
      if (_liquidController.value % 0.1 < 0.005) {
        setState(() {
          if (_chaoticBubbles.length < 40) { // Увеличиваем лимит пузырьков
            final screenWidth = MediaQuery.of(context).size.width;
            final newBubble = ChaoticBubble(
              x: 20.0 + _random.nextDouble() * (screenWidth - 40.0), // Распределяем по всей ширине экрана
              y: MediaQuery.of(context).size.height,
              size: 4.0 + _random.nextDouble() * 6.0, // Увеличиваем размер для лучшей видимости
              speed: 20.0 + _random.nextDouble() * 60.0, // Больше вариативности в скорости
              horizontalDrift: (_random.nextDouble() - 0.5) * 30.0, // Больше горизонтального движения
              opacity: 0.7 + _random.nextDouble() * 0.3, // Увеличиваем непрозрачность
              createdAt: DateTime.now().millisecondsSinceEpoch,
            );
            _chaoticBubbles.add(newBubble);
          }
        });
      }
      
      // Обновляем позиции пузырьков
      setState(() {
        for (var bubble in _chaoticBubbles) {
          bubble.update(1.0 / 60.0);
        }
        // Удаляем пузырьки, которые вышли за пределы экрана или лопнули
        _chaoticBubbles.removeWhere((bubble) {
          final popHeight = MediaQuery.of(context).size.height * 0.05;
          final time = (DateTime.now().millisecondsSinceEpoch - bubble.createdAt) / 1000.0;
          final popProgress = (time * 4.0) % (2 * pi);
          
          // Удаляем если пузырек вышел за пределы экрана или завершил анимацию лопания
          return bubble.y < -50 || (bubble.y <= popHeight && popProgress >= 2 * pi);
        });
      });
    });
  }
  


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _liquidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Анимация жидкости
          AnimatedBuilder(
            animation: _liquidAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: LiquidPainter(
                  animation: _liquidAnimation.value,
                  bubbleAnimation: _bubbleAnimation.value,
                  chaoticBubbles: _chaoticBubbles,
                ),
              );
            },
          ),
          
          // Основной контент
          SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
                child: Column(
                  children: [
                    // Верхняя секция с логотипом и заголовком
                    Expanded(
                      flex: 2,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Логотип совы с анимацией
                              const OwlLogoWidget(),
                              const SizedBox(height: 24),
                              
                              // Название приложения с логотипом
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: SvgPicture.asset(
                                      'assets/icons/owl_logo.svg',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Bukhindor',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              
                              // Подзаголовок
                              Text(
                                'Сервис пятничного вечера',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Нижняя секция с формой
                    Expanded(
                      flex: 3,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height: _hasValidationErrors ? 600 : 500, // Динамическая высота
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, -10),
                                  ),
                                ],
                              ),
                          child: BlocListener<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is AuthError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(32),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Заголовок формы
                                    Text(
                                      'Добро пожаловать!',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    
                                    Text(
                                      'Войдите в свой аккаунт',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w400,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 32),
                                    
                                    // Поле email
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.grey[200]!,
                                          width: 1,
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[800],
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Email',
                                          hintStyle: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 16,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.email_outlined,
                                            color: Colors.grey[600],
                                            size: 20,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 16,
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Пожалуйста, введите email';
                                          }
                                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                            return 'Пожалуйста, введите корректный email';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          if (_hasValidationErrors) {
                                            setState(() {
                                              _hasValidationErrors = false;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // Поле пароля
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.grey[200]!,
                                          width: 1,
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: _passwordController,
                                        obscureText: _obscurePassword,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[800],
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Пароль',
                                          hintStyle: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 16,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.lock_outline,
                                            color: Colors.grey[600],
                                            size: 20,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                              color: Colors.grey[600],
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscurePassword = !_obscurePassword;
                                              });
                                            },
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 16,
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Пожалуйста, введите пароль';
                                          }
                                          if (value.length < 6) {
                                            return 'Пароль должен содержать минимум 6 символов';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          if (_hasValidationErrors) {
                                            setState(() {
                                              _hasValidationErrors = false;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // Забыли пароль и "Запомнить меня"
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                value: _rememberMe,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _rememberMe = value ?? false;
                                                  });
                                                },
                                                activeColor: const Color(0xFF667eea),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'Запомнить меня',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // TODO: Implement forgot password
                                          },
                                          child: const Text(
                                            'Забыли пароль?',
                                            style: TextStyle(
                                              color: Color(0xFF667eea),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    
                                    // Кнопка входа
                                    BlocBuilder<AuthBloc, AuthState>(
                                      builder: (context, state) {
                                        return Container(
                                          height: 56,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF667eea),
                                                Color(0xFF764ba2),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF667eea).withOpacity(0.3),
                                                blurRadius: 15,
                                                offset: const Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton(
                                            onPressed: state is AuthLoading ? null : () {
                                              final isValid = _formKey.currentState!.validate();
                                              setState(() {
                                                _hasValidationErrors = !isValid;
                                              });
                                              if (isValid) {
                                                context.read<AuthBloc>().add(
                                                  AuthSignInRequested(
                                                    email: _emailController.text.trim(),
                                                    password: _passwordController.text,
                                                  ),
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                            child: state is AuthLoading
                                                ? const SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                    ),
                                                  )
                                                : const Text(
                                                    'Войти',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    
                                    // Разделитель
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Divider(
                                            color: Colors.grey[300],
                                            thickness: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          child: Text(
                                            'или',
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Divider(
                                            color: Colors.grey[300],
                                            thickness: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    
                                    // Ссылка на регистрацию
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Нет аккаунта? ',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 16,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // TODO: Navigate to registration page
                                          },
                                          child: const Text(
                                            'Зарегистрироваться',
                                            style: TextStyle(
                                              color: Color(0xFF667eea),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                    ),
                  ],
              ),
            ),
          ),
        ),
        ],
    ));
  }
}

// Кастомный painter для анимации жидкости
class LiquidPainter extends CustomPainter {
  final double animation;
  final double bubbleAnimation;
  final List<ChaoticBubble> chaoticBubbles;

  LiquidPainter({
    required this.animation, 
    required this.bubbleAnimation,
    required this.chaoticBubbles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Создаем градиент для жидкости
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF667eea).withOpacity(0.9),
          const Color(0xFF764ba2).withOpacity(0.8),
          const Color(0xFFf093fb).withOpacity(0.7),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Отступ сверху 2%
    final topOffset = size.height * 0.02;
    final liquidTop = size.height * 0.15; // Начинаем жидкость выше

    final path = Path();
    
    // Создаем плавную качающуюся жидкость как в бокале с зацикливанием
    path.moveTo(0, liquidTop);
    
    // Используем время напрямую для бесконечной волны без циклов
    final currentTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
    
    for (double x = 0; x <= size.width; x += 1) {
      // Истинно бесконечная волна без рывков - используем время напрямую
      final waveLength = size.width;
      const waveSpeed = 0.5; // Скорость движения волны
      final offset = currentTime * waveSpeed * 2 * pi; // Непрерывное время
      
      // Основная волна с более плавным движением
      final mainWave = sin((x / waveLength * 2 * pi) + offset) * 18;
      
      // Вторичные волны с разными частотами и скоростями
      final secondaryWave = sin((x / waveLength * 3 * pi) + offset * 1.1) * 10 * 0.5;
      final tertiaryWave = sin((x / waveLength * 4 * pi) + offset * 0.7) * 6 * 0.3;
      
      // Поверхностные колебания
      final surfaceRipple = sin((x / waveLength * 7 * pi) + offset * 1.3) * 3 * 0.6;
      
      // Эффект наклона
      final tiltEffect = sin(offset * 0.15) * 4 * (x / size.width - 0.5);
      
      final y = liquidTop + mainWave + secondaryWave + tertiaryWave + surfaceRipple + tiltEffect;
      path.lineTo(x, y);
    }
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    // Рисуем основной слой жидкости
    canvas.drawPath(path, paint);
    
    // Добавляем плавные блики как в бокале
    final highlightPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.3),
          Colors.white.withOpacity(0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    // Рисуем плавные блики на поверхности жидкости
    for (int i = 0; i < 2; i++) {
      final highlightPath = Path();
      highlightPath.moveTo(0, liquidTop);
      
      for (double x = 0; x <= size.width; x += 1) {
        // Непрерывные блики
        final waveLength = size.width;
        final offset = animation * 2 * pi;
        final highlightOffset = offset + i * 0.5; // Смещение для разных бликов
        
        final mainWave = sin((x / waveLength * 2 * pi) + highlightOffset) * 20;
        final secondaryWave = sin((x / waveLength * 4 * pi) + highlightOffset * 1.2) * 12 * 0.6;
        final tiltEffect = sin(highlightOffset * 0.4) * 6 * (x / size.width - 0.5);
        
        final y = liquidTop + mainWave + secondaryWave + tiltEffect;
        highlightPath.lineTo(x, y);
      }
      
      highlightPath.lineTo(size.width, size.height);
      highlightPath.lineTo(0, size.height);
      highlightPath.close();
      
      canvas.drawPath(highlightPath, highlightPaint);
    }
    
    // Добавляем отражения на стенках "бокала"
    final reflectionPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.2),
          Colors.transparent,
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    // Рисуем отражения
    final reflectionPath = Path();
    reflectionPath.moveTo(size.width * 0.1, liquidTop);
    reflectionPath.lineTo(size.width * 0.15, liquidTop + 50);
    reflectionPath.lineTo(size.width * 0.12, size.height);
    reflectionPath.lineTo(size.width * 0.08, size.height);
    reflectionPath.close();
    
    canvas.drawPath(reflectionPath, reflectionPaint);
    
    // Добавляем пузырьки (независимые от волны)
    final bubblePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.8),
          Colors.white.withOpacity(0.4),
          Colors.transparent,
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    // Рисуем хаотичные пузырьки
    for (final bubble in chaoticBubbles) {
      // Обновляем позицию пузырька
      bubble.update(1.0 / 60.0); // Примерно 60 FPS
      
      // Проверяем, достиг ли пузырек высоты 5% от верха экрана
      final popHeight = size.height * 0.05; // 5% от высоты экрана
      if (bubble.y <= popHeight) {
        // Пузырек лопается на высоте 5% от верха - анимация лопания
        final time = (DateTime.now().millisecondsSinceEpoch - bubble.createdAt) / 1000.0;
        final popProgress = (time * 4.0) % (2 * pi);
        final popSize = bubble.size * (1 + sin(popProgress) * 0.6);
        final popOpacity = (bubble.opacity * (1 - (popProgress / (2 * pi)))).clamp(0.0, 1.0);
        
        final popPaint = Paint()
          ..color = Colors.white.withOpacity(0.9 * popOpacity) // Увеличиваем яркость
          ..style = PaintingStyle.fill;
        
        final popPath = Path();
        popPath.addOval(Rect.fromCenter(
          center: Offset(bubble.x, popHeight),
          width: popSize,
          height: popSize,
        ));
        
        canvas.drawPath(popPath, popPaint);
      } else if (bubble.y > 0 && bubble.y < size.height) {
        // Пузырек поднимается - рисуем его
        final bubblePath = Path();
        bubblePath.addOval(Rect.fromCenter(
          center: Offset(bubble.x, bubble.y),
          width: bubble.size,
          height: bubble.size,
        ));
        
        final bubblePaintDynamic = Paint()
          ..color = Colors.white.withOpacity(bubble.opacity * 0.8) // Увеличиваем яркость
          ..style = PaintingStyle.fill;
        
        canvas.drawPath(bubblePath, bubblePaintDynamic);
        
        // Добавляем блик для лучшей видимости
        final highlightPaint = Paint()
          ..color = Colors.white.withOpacity(bubble.opacity * 0.4)
          ..style = PaintingStyle.fill;
        
        final highlightPath = Path();
        highlightPath.addOval(Rect.fromCenter(
          center: Offset(bubble.x - bubble.size * 0.2, bubble.y - bubble.size * 0.2),
          width: bubble.size * 0.4,
          height: bubble.size * 0.4,
        ));
        
        canvas.drawPath(highlightPath, highlightPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Модель для хаотичного пузырька
class ChaoticBubble {
  double x;
  double y;
  final double size;
  final double speed;
  final double horizontalDrift;
  final double opacity;
  final int createdAt;
  
  ChaoticBubble({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.horizontalDrift,
    required this.opacity,
    required this.createdAt,
  });
  
  /// Обновляет позицию пузырька
  void update(double deltaTime) {
    y -= speed * deltaTime;
    
    // Добавляем горизонтальное колебание
    final time = (DateTime.now().millisecondsSinceEpoch - createdAt) / 1000.0;
    x += sin(time * 2.0) * horizontalDrift * deltaTime;
  }
} 
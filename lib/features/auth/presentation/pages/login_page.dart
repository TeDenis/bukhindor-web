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
      duration: const Duration(milliseconds: 6000),
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
      end: 2 * pi,
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
                ),
              );
            },
          ),
          
          // Основной контент
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
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
                                  Text(
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
                            child: Container(
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
                                          child: Text(
                                            'Забыли пароль?',
                                            style: TextStyle(
                                              color: const Color(0xFF667eea),
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
                                            gradient: LinearGradient(
                                              colors: [
                                                const Color(0xFF667eea),
                                                const Color(0xFF764ba2),
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
                                              if (_formKey.currentState!.validate()) {
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
                                                : Text(
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
                                          child: Text(
                                            'Зарегистрироваться',
                                            style: TextStyle(
                                              color: const Color(0xFF667eea),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Кастомный painter для анимации жидкости
class LiquidPainter extends CustomPainter {
  final double animation;
  final double bubbleAnimation;

  LiquidPainter({required this.animation, required this.bubbleAnimation});

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
    
    for (double x = 0; x <= size.width; x += 1) {
      // Основная плавная волна с зацикливанием
      final mainWave = sin(x * 0.008 + animation * 0.5) * 25;
      
      // Вторичные плавные волны с зацикливанием
      final secondaryWave = sin(x * 0.015 + animation * 0.3) * 15 * 0.7;
      final tertiaryWave = sin(x * 0.025 + animation * 0.7) * 10 * 0.5;
      
      // Плавные колебания поверхности с зацикливанием
      final surfaceRipple = sin(x * 0.04 + animation * 0.2) * 5 * 
                           (sin(animation * 0.1) * 0.3 + 0.7);
      
      // Эффект наклона бокала с зацикливанием
      final tiltEffect = sin(animation * 0.3) * 8 * (x / size.width - 0.5);
      
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
        final mainWave = sin(x * 0.008 + animation * 0.5 + i * 0.2) * 20;
        final secondaryWave = sin(x * 0.015 + animation * 0.3 + i * 0.1) * 12 * 0.6;
        final tiltEffect = sin(animation * 0.3 + i * 0.5) * 6 * (x / size.width - 0.5);
        
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
    
    // Рисуем больше пузырьков
    for (int i = 0; i < 25; i++) {
      // Позиция пузырька
      final bubbleX = (size.width * 0.05 + i * size.width * 0.04) % size.width;
      
      // Независимая анимация подъема пузырька
      final bubbleProgress = (bubbleAnimation * 0.2 + i * 0.3) % (2 * pi);
      final bubbleY = size.height - (bubbleProgress / (2 * pi)) * (size.height - liquidTop + 50);
      
      // Размер пузырька
      final bubbleSize = 4 + sin(bubbleAnimation * 1.5 + i) * 2;
      
      // Проверяем, достиг ли пузырек поверхности
      if (bubbleY <= liquidTop + 30) {
        // Пузырек на поверхности - анимация лопания
        final popProgress = (bubbleProgress * 3) % (2 * pi);
        final popSize = bubbleSize * (1 + sin(popProgress) * 0.8);
        final popOpacity = (1 - (popProgress / (2 * pi))).clamp(0.0, 1.0);
        
        final popPaint = Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.white.withOpacity(0.7 * popOpacity),
              Colors.white.withOpacity(0.3 * popOpacity),
              Colors.transparent,
            ],
            stops: const [0.0, 0.7, 1.0],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
        
        final popPath = Path();
        popPath.addOval(Rect.fromCenter(
          center: Offset(bubbleX, liquidTop + 20),
          width: popSize,
          height: popSize,
        ));
        
        canvas.drawPath(popPath, popPaint);
      } else {
        // Пузырек поднимается
        final bubblePath = Path();
        bubblePath.addOval(Rect.fromCenter(
          center: Offset(bubbleX, bubbleY),
          width: bubbleSize,
          height: bubbleSize,
        ));
        
        canvas.drawPath(bubblePath, bubblePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../bloc/auth_bloc_simple.dart';
import '../widgets/owl_logo_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final _forgotPasswordFormKey = GlobalKey<FormState>();

  // Контроллеры для формы входа
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  bool _loginObscurePassword = true;
  bool _rememberMe = false;

  // Контроллеры для формы регистрации
  final _registerNameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerConfirmPasswordController = TextEditingController();
  bool _registerObscurePassword = true;
  bool _registerObscureConfirmPassword = true;
  bool _acceptTerms = false;

  // Контроллеры для формы восстановления пароля
  final _forgotPasswordEmailController = TextEditingController();

  // Состояние карточек (0 - вход, 1 - регистрация, 2 - забыли пароль)
  int _currentCardIndex = 0;
  bool _hasValidationErrors = false;

  // Анимации
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _liquidController;
  late AnimationController _cardSlideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _liquidAnimation;
  late Animation<double> _bubbleAnimation;
  late Animation<Offset> _cardSlideAnimation;

  // Для хаотичных пузырьков
  final List<ChaoticBubble> _chaoticBubbles = [];
  final Random _random = Random();

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
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _cardSlideController = AnimationController(
      duration: const Duration(milliseconds: 600),
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
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _liquidController,
      curve: Curves.linear,
    ));

    _bubbleAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _liquidController,
      curve: Curves.linear,
    ));

    _cardSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardSlideController,
      curve: Curves.easeInOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
    _liquidController.repeat();
    _cardSlideController.forward();

    // Генерация пузырьков
    _liquidController.addListener(() {
      if (_liquidController.value % 0.1 < 0.005) {
        setState(() {
          if (_chaoticBubbles.length < 40) {
            final screenWidth = MediaQuery.of(context).size.width;
            _chaoticBubbles.add(ChaoticBubble(
              x: 20.0 + _random.nextDouble() * (screenWidth - 40.0),
              y: MediaQuery.of(context).size.height,
              size: 4.0 + _random.nextDouble() * 6.0,
              speed: 20.0 + _random.nextDouble() * 60.0,
              horizontalDrift: (_random.nextDouble() - 0.5) * 30.0,
              opacity: 0.7 + _random.nextDouble() * 0.3,
              createdAt: DateTime.now().millisecondsSinceEpoch,
            ));
          }
        });
      }

      setState(() {
        for (var bubble in _chaoticBubbles) {
          bubble.update(1.0 / 60.0);
        }
        _chaoticBubbles.removeWhere((bubble) {
          final popHeight = MediaQuery.of(context).size.height * 0.05;
          final time =
              (DateTime.now().millisecondsSinceEpoch - bubble.createdAt) /
                  1000.0;
          final popProgress = (time * 4.0) % (2 * pi);
          return bubble.y < -50 ||
              (bubble.y <= popHeight && popProgress >= 2 * pi);
        });
      });
    });
  }

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    _forgotPasswordEmailController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _liquidController.dispose();
    _cardSlideController.dispose();
    super.dispose();
  }

  void _switchToCard(int cardIndex) {
    setState(() {
      _currentCardIndex = cardIndex;
    });
    _cardSlideController.reset();
    _cardSlideController.forward();
  }

  double _getCardHeight() {
    switch (_currentCardIndex) {
      case 0: // Вход
        return 500;
      case 1: // Регистрация
        return 700;
      case 2: // Забыли пароль
        return 450;
      default:
        return 500;
    }
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
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
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
                              const OwlLogoWidget(
                                size: 100,
                                enableVersionAccess: true,
                              ),
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

                    // Нижняя секция с карточками
                    Expanded(
                      flex: 3,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height: _getCardHeight(),
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: SlideTransition(
                                  position: _cardSlideAnimation,
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(32),
                                    child: _buildCurrentForm(),
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
      ),
    );
  }

  Widget _buildCurrentForm() {
    switch (_currentCardIndex) {
      case 0:
        return _buildLoginForm();
      case 1:
        return _buildRegisterForm();
      case 2:
        return _buildForgotPasswordForm();
      default:
        return _buildLoginForm();
    }
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
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
          _buildTextField(
            controller: _loginEmailController,
            hintText: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста, введите email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Пожалуйста, введите корректный email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Поле пароля
          _buildPasswordField(
            controller: _loginPasswordController,
            hintText: 'Пароль',
            obscureText: _loginObscurePassword,
            onToggleVisibility: () {
              setState(() {
                _loginObscurePassword = !_loginObscurePassword;
              });
            },
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
                onPressed: () => _switchToCard(2),
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
              return _buildGradientButton(
                onPressed: state is AuthLoading
                    ? null
                    : () {
                        final isValid = _loginFormKey.currentState!.validate();
                        setState(() {
                          _hasValidationErrors = !isValid;
                        });
                        if (isValid) {
                          context.read<AuthBloc>().add(
                                AuthSignInRequested(
                                  email: _loginEmailController.text.trim(),
                                  password: _loginPasswordController.text,
                                ),
                              );
                        }
                      },
                child: state is AuthLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
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
              );
            },
          ),
          const SizedBox(height: 24),

          // Разделитель
          _buildDivider(),
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
                onPressed: () => _switchToCard(1),
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
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Заголовок формы
          Text(
            'Регистрация',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          Text(
            'Заполните форму для создания аккаунта',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Поле имени
          _buildTextField(
            controller: _registerNameController,
            hintText: 'Имя',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста, введите имя';
              }
              if (value.length < 2) {
                return 'Имя должно содержать минимум 2 символа';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Поле email
          _buildTextField(
            controller: _registerEmailController,
            hintText: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста, введите email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Пожалуйста, введите корректный email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Поле пароля
          _buildPasswordField(
            controller: _registerPasswordController,
            hintText: 'Пароль',
            obscureText: _registerObscurePassword,
            onToggleVisibility: () {
              setState(() {
                _registerObscurePassword = !_registerObscurePassword;
              });
            },
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
          const SizedBox(height: 16),

          // Поле подтверждения пароля
          _buildPasswordField(
            controller: _registerConfirmPasswordController,
            hintText: 'Подтвердите пароль',
            obscureText: _registerObscureConfirmPassword,
            onToggleVisibility: () {
              setState(() {
                _registerObscureConfirmPassword =
                    !_registerObscureConfirmPassword;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста, подтвердите пароль';
              }
              if (value != _registerPasswordController.text) {
                return 'Пароли не совпадают';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Согласие с условиями
          Row(
            children: [
              Checkbox(
                value: _acceptTerms,
                onChanged: (value) {
                  setState(() {
                    _acceptTerms = value ?? false;
                  });
                },
                activeColor: const Color(0xFF667eea),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Expanded(
                child: Text(
                  'Я согласен с условиями использования и политикой конфиденциальности',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Кнопка регистрации
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return _buildGradientButton(
                onPressed: _acceptTerms && state is! AuthLoading
                    ? () {
                        final isValid =
                            _registerFormKey.currentState!.validate();
                        setState(() {
                          _hasValidationErrors = !isValid;
                        });
                        if (isValid) {
                          context.read<AuthBloc>().add(
                                AuthSignUpRequested(
                                  email: _registerEmailController.text.trim(),
                                  password: _registerPasswordController.text,
                                  displayName:
                                      _registerNameController.text.trim(),
                                ),
                              );
                        }
                      }
                    : null,
                child: state is AuthLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Зарегистрироваться',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Разделитель
          _buildDivider(),
          const SizedBox(height: 24),

          // Ссылка на вход
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Уже есть аккаунт? ',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () => _switchToCard(0),
                child: const Text(
                  'Войти',
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
    );
  }

  Widget _buildForgotPasswordForm() {
    return Form(
      key: _forgotPasswordFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Заголовок формы
          Text(
            'Восстановление пароля',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          Text(
            'Введите email для получения инструкций',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Иконка
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF667eea).withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.lock_reset,
              size: 40,
              color: Color(0xFF667eea),
            ),
          ),
          const SizedBox(height: 24),

          // Поле email
          _buildTextField(
            controller: _forgotPasswordEmailController,
            hintText: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста, введите email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Пожалуйста, введите корректный email';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Кнопка восстановления
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return _buildGradientButton(
                onPressed: state is AuthLoading
                    ? null
                    : () {
                        final isValid =
                            _forgotPasswordFormKey.currentState!.validate();
                        setState(() {
                          _hasValidationErrors = !isValid;
                        });
                        if (isValid) {
                          // TODO: Implement forgot password functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Инструкции по восстановлению пароля отправлены на ваш email',
                              ),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }
                      },
                child: state is AuthLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Отправить инструкции',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Разделитель
          _buildDivider(),
          const SizedBox(height: 24),

          // Ссылка на вход
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Вспомнили пароль? ',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () => _switchToCard(0),
                child: const Text(
                  'Войти',
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[800],
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.grey[600],
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        validator: validator,
        onChanged: (value) {
          if (_hasValidationErrors) {
            setState(() {
              _hasValidationErrors = false;
            });
          }
        },
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[800],
        ),
        decoration: InputDecoration(
          hintText: hintText,
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
              obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey[600],
              size: 20,
            ),
            onPressed: onToggleVisibility,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        validator: validator,
        onChanged: (value) {
          if (_hasValidationErrors) {
            setState(() {
              _hasValidationErrors = false;
            });
          }
        },
      ),
    );
  }

  Widget _buildGradientButton({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
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
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: child,
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
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
    );
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

    final liquidTop = size.height * 0.15;
    final path = Path();

    // Создаем плавную качающуюся жидкость
    path.moveTo(0, liquidTop);

    final currentTime = DateTime.now().millisecondsSinceEpoch / 1000.0;

    for (double x = 0; x <= size.width; x += 1) {
      final waveLength = size.width;
      const waveSpeed = 0.5;
      final offset = currentTime * waveSpeed * 2 * pi;

      final mainWave = sin((x / waveLength * 2 * pi) + offset) * 18;
      final secondaryWave =
          sin((x / waveLength * 3 * pi) + offset * 1.1) * 10 * 0.5;
      final tertiaryWave =
          sin((x / waveLength * 4 * pi) + offset * 0.7) * 6 * 0.3;
      final surfaceRipple =
          sin((x / waveLength * 7 * pi) + offset * 1.3) * 3 * 0.6;
      final tiltEffect = sin(offset * 0.15) * 4 * (x / size.width - 0.5);

      final y = liquidTop +
          mainWave +
          secondaryWave +
          tertiaryWave +
          surfaceRipple +
          tiltEffect;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Добавляем блики
    final highlightPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.3),
          Colors.white.withOpacity(0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    for (int i = 0; i < 2; i++) {
      final highlightPath = Path();
      highlightPath.moveTo(0, liquidTop);

      for (double x = 0; x <= size.width; x += 1) {
        final waveLength = size.width;
        final offset = animation * 2 * pi;
        final highlightOffset = offset + i * 0.5;

        final mainWave = sin((x / waveLength * 2 * pi) + highlightOffset) * 20;
        final secondaryWave =
            sin((x / waveLength * 4 * pi) + highlightOffset * 1.2) * 12 * 0.6;
        final tiltEffect =
            sin(highlightOffset * 0.4) * 6 * (x / size.width - 0.5);

        final y = liquidTop + mainWave + secondaryWave + tiltEffect;
        highlightPath.lineTo(x, y);
      }

      highlightPath.lineTo(size.width, size.height);
      highlightPath.lineTo(0, size.height);
      highlightPath.close();

      canvas.drawPath(highlightPath, highlightPaint);
    }

    // Добавляем отражения
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

    final reflectionPath = Path();
    reflectionPath.moveTo(size.width * 0.1, liquidTop);
    reflectionPath.lineTo(size.width * 0.15, liquidTop + 50);
    reflectionPath.lineTo(size.width * 0.12, size.height);
    reflectionPath.lineTo(size.width * 0.08, size.height);
    reflectionPath.close();

    canvas.drawPath(reflectionPath, reflectionPaint);

    // Рисуем пузырьки
    for (final bubble in chaoticBubbles) {
      bubble.update(1.0 / 60.0);

      final popHeight = size.height * 0.05;
      if (bubble.y <= popHeight) {
        final time =
            (DateTime.now().millisecondsSinceEpoch - bubble.createdAt) / 1000.0;
        final popProgress = (time * 4.0) % (2 * pi);
        final popSize = bubble.size * (1 + sin(popProgress) * 0.6);
        final popOpacity =
            (bubble.opacity * (1 - (popProgress / (2 * pi)))).clamp(0.0, 1.0);

        final popPaint = Paint()
          ..color = Colors.white.withOpacity(0.9 * popOpacity)
          ..style = PaintingStyle.fill;

        final popPath = Path();
        popPath.addOval(Rect.fromCenter(
          center: Offset(bubble.x, popHeight),
          width: popSize,
          height: popSize,
        ));

        canvas.drawPath(popPath, popPaint);
      } else if (bubble.y > 0 && bubble.y < size.height) {
        final bubblePath = Path();
        bubblePath.addOval(Rect.fromCenter(
          center: Offset(bubble.x, bubble.y),
          width: bubble.size,
          height: bubble.size,
        ));

        final bubblePaintDynamic = Paint()
          ..color = Colors.white.withOpacity(bubble.opacity * 0.8)
          ..style = PaintingStyle.fill;

        canvas.drawPath(bubblePath, bubblePaintDynamic);

        final highlightPaint = Paint()
          ..color = Colors.white.withOpacity(bubble.opacity * 0.4)
          ..style = PaintingStyle.fill;

        final highlightPath = Path();
        highlightPath.addOval(Rect.fromCenter(
          center: Offset(
              bubble.x - bubble.size * 0.2, bubble.y - bubble.size * 0.2),
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

  void update(double deltaTime) {
    y -= speed * deltaTime;

    final time = (DateTime.now().millisecondsSinceEpoch - createdAt) / 1000.0;
    x += sin(time * 2.0) * horizontalDrift * deltaTime;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import '../../../auth/presentation/bloc/auth_bloc_simple.dart';
import '../widgets/adaptive_splash_background.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _authCheckTimer;

  @override
  void initState() {
    super.initState();

    // Проверяем состояние авторизации через 3 секунды
    _authCheckTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        context.read<AuthBloc>().add(AuthCheckRequested());
      }
    });
  }

  @override
  void dispose() {
    _authCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdaptiveSplashBackground(
        child: Stack(
          children: [
            // Адаптивное колесо загрузки
            const AdaptiveLoadingIndicator(
              text: 'Загрузка...',
              topOffset: 0.2,
              showBackground: true,
            ),

            // BlocListener для навигации
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthAuthenticatedState) {
                  // Навигация к главной странице
                  // TODO: Implement navigation to home page
                } else if (state is AuthUnauthenticatedState) {
                  // Навигация к странице входа
                  // TODO: Implement navigation to login page
                }
              },
              child: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/auth_bloc_simple.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/version/presentation/pages/version_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final authBloc = context.read<AuthBloc>();
      final isAuthenticated = authBloc.state is AuthAuthenticatedState;
      final isOnAuthPage = state.matchedLocation == '/auth';
      final isOnVersionPage = state.matchedLocation == '/version';

      if (authBloc.state is AuthLoading) {
        return '/splash';
      }

      if (isAuthenticated && isOnAuthPage) {
        return '/home';
      }

      if (!isAuthenticated &&
          !isOnAuthPage &&
          !isOnVersionPage &&
          state.matchedLocation != '/splash') {
        return '/auth';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/version',
        builder: (context, state) => const VersionPage(),
      ),
    ],
  );
}

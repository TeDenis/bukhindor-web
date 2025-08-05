// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bukhindor_web/main.dart';
import 'package:bukhindor_web/features/splash/presentation/pages/splash_page.dart';
import 'package:bukhindor_web/features/auth/presentation/bloc/auth_bloc_simple.dart';
import 'package:bukhindor_web/features/auth/domain/repositories/auth_repository.dart';
import 'package:bukhindor_web/features/auth/domain/entities/user_entity.dart';

// Mock AuthRepository for testing
class MockAuthRepository implements AuthRepository {
  @override
  Stream<UserEntity?> get authStateChanges => Stream.value(null);

  @override
  Future<UserEntity?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async => null;

  @override
  Future<UserEntity?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async => null;

  @override
  Future<UserEntity?> getCurrentUser() async => null;

  @override
  Future<void> signOut() async {}

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {}
}

void main() {
  testWidgets('Splash page shows loading indicator',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (context) => AuthBloc(authRepository: MockAuthRepository()),
          child: const SplashPage(),
        ),
      ),
    );

    // Verify that loading text is displayed
    expect(find.text('Загрузка...'), findsOneWidget);

    // Verify that CircularProgressIndicator is present
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Splash page has adaptive background',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (context) => AuthBloc(authRepository: MockAuthRepository()),
          child: const SplashPage(),
        ),
      ),
    );

    // Verify that the splash page is rendered
    expect(find.byType(SplashPage), findsOneWidget);

    // Verify that the adaptive background is present
    expect(find.byType(Scaffold), findsOneWidget);
  });
}

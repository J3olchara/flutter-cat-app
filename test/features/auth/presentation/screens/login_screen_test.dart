import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:kototinder/features/auth/presentation/providers/auth_provider.dart';
import 'package:kototinder/features/auth/presentation/screens/login_screen.dart';

import 'login_screen_test.mocks.dart';

@GenerateMocks([AuthProvider])
void main() {
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
  });

  Widget createLoginScreen() {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: mockAuthProvider,
      child: const MaterialApp(
        home: LoginScreen(),
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('should display all required UI elements', (tester) async {
      when(mockAuthProvider.state).thenReturn(AuthState.unauthenticated);

      await tester.pumpWidget(createLoginScreen());

      expect(find.text('Кототиндер'), findsOneWidget);
      expect(find.text('Войдите в свой аккаунт'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Войти'), findsOneWidget);
      expect(find.text('Зарегистрироваться'), findsOneWidget);
    });

    testWidgets('should show validation error for empty email', (tester) async {
      when(mockAuthProvider.state).thenReturn(AuthState.unauthenticated);

      await tester.pumpWidget(createLoginScreen());

      final loginButton = find.text('Войти');
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text('Пожалуйста, введите email'), findsOneWidget);
    });

    testWidgets('should show validation error for invalid email format',
        (tester) async {
      when(mockAuthProvider.state).thenReturn(AuthState.unauthenticated);

      await tester.pumpWidget(createLoginScreen());

      await tester.enterText(find.byType(TextFormField).at(0), 'invalid-email');
      await tester.tap(find.text('Войти'));
      await tester.pump();

      expect(find.text('Некорректный формат email'), findsOneWidget);
    });

    testWidgets('should show validation error for empty password',
        (tester) async {
      when(mockAuthProvider.state).thenReturn(AuthState.unauthenticated);

      await tester.pumpWidget(createLoginScreen());

      await tester.enterText(
          find.byType(TextFormField).at(0), 'test@example.com');
      await tester.tap(find.text('Войти'));
      await tester.pump();

      expect(find.text('Пожалуйста, введите пароль'), findsOneWidget);
    });

    testWidgets('should show validation error for short password',
        (tester) async {
      when(mockAuthProvider.state).thenReturn(AuthState.unauthenticated);

      await tester.pumpWidget(createLoginScreen());

      await tester.enterText(
          find.byType(TextFormField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), '12345');
      await tester.tap(find.text('Войти'));
      await tester.pump();

      expect(find.text('Пароль должен содержать минимум 6 символов'),
          findsOneWidget);
    });

    testWidgets('should call signIn with valid credentials', (tester) async {
      when(mockAuthProvider.state).thenReturn(AuthState.unauthenticated);
      when(mockAuthProvider.signIn(any, any)).thenAnswer((_) async {});

      await tester.pumpWidget(createLoginScreen());

      await tester.enterText(
          find.byType(TextFormField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');

      await tester.tap(find.text('Войти'));
      await tester.pump();

      verify(mockAuthProvider.signIn('test@example.com', 'password123'))
          .called(1);
    });

    testWidgets('should show loading indicator when signing in',
        (tester) async {
      when(mockAuthProvider.state).thenReturn(AuthState.loading);

      await tester.pumpWidget(createLoginScreen());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Войти'), findsNothing);
    });

    testWidgets('should toggle password visibility', (tester) async {
      when(mockAuthProvider.state).thenReturn(AuthState.unauthenticated);

      await tester.pumpWidget(createLoginScreen());

      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'password123');

      final visibilityIcon = find.byIcon(Icons.visibility_outlined);
      expect(visibilityIcon, findsOneWidget);

      await tester.tap(visibilityIcon);
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });
  });
}

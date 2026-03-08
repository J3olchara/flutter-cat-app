import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:kototinder/features/auth/presentation/providers/auth_provider.dart';
import 'package:kototinder/features/auth/presentation/screens/sign_up_screen.dart';

import 'sign_up_screen_test.mocks.dart';

@GenerateMocks([AuthProvider])
void main() {
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
  });

  Widget createSignUpScreen() {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: mockAuthProvider,
      child: const MaterialApp(home: SignUpScreen()),
    );
  }

  group('SignUpScreen Widget Tests', () {
    testWidgets('should display all required UI elements', (tester) async {
      when(mockAuthProvider.state).thenReturn(AuthState.unauthenticated);

      await tester.pumpWidget(createSignUpScreen());

      expect(find.text('Создайте аккаунт'), findsOneWidget);
      expect(find.text('Присоединяйтесь к кототиндеру'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.text('Зарегистрироваться'), findsOneWidget);
      expect(find.text('Войти'), findsOneWidget);
    });

    testWidgets('should show validation error for empty fields', (
      tester,
    ) async {
      when(mockAuthProvider.state).thenReturn(AuthState.unauthenticated);

      await tester.pumpWidget(createSignUpScreen());

      final signUpButton = find.text('Зарегистрироваться');
      await tester.tap(signUpButton);
      await tester.pump();

      expect(find.text('Пожалуйста, введите email'), findsOneWidget);
      expect(find.text('Пожалуйста, введите пароль'), findsOneWidget);
      expect(find.text('Пожалуйста, подтвердите пароль'), findsOneWidget);
    });

    testWidgets('should show validation error when passwords do not match', (
      tester,
    ) async {
      when(mockAuthProvider.state).thenReturn(AuthState.unauthenticated);

      await tester.pumpWidget(createSignUpScreen());

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.enterText(find.byType(TextFormField).at(2), 'different123');

      await tester.tap(find.text('Зарегистрироваться'));
      await tester.pump();

      expect(find.text('Пароли не совпадают'), findsOneWidget);
    });

    testWidgets('should show validation error for invalid email format', (
      tester,
    ) async {
      when(mockAuthProvider.state).thenReturn(AuthState.unauthenticated);

      await tester.pumpWidget(createSignUpScreen());

      await tester.enterText(find.byType(TextFormField).at(0), 'invalid-email');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');

      await tester.tap(find.text('Зарегистрироваться'));
      await tester.pump();

      expect(find.text('Некорректный формат email'), findsOneWidget);
    });

    testWidgets('should show validation error for short password', (
      tester,
    ) async {
      when(mockAuthProvider.state).thenReturn(AuthState.unauthenticated);

      await tester.pumpWidget(createSignUpScreen());

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), '12345');
      await tester.enterText(find.byType(TextFormField).at(2), '12345');

      await tester.tap(find.text('Зарегистрироваться'));
      await tester.pump();

      expect(
        find.text('Пароль должен содержать минимум 6 символов'),
        findsOneWidget,
      );
    });

    testWidgets('should call signUp with valid credentials', (tester) async {
      when(mockAuthProvider.state).thenReturn(AuthState.unauthenticated);
      when(mockAuthProvider.signUp(any, any, any)).thenAnswer((_) async {});

      await tester.pumpWidget(createSignUpScreen());

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');

      await tester.tap(find.text('Зарегистрироваться'));
      await tester.pump();

      verify(
        mockAuthProvider.signUp(
          'test@example.com',
          'password123',
          'password123',
        ),
      ).called(1);
    });

    testWidgets('should show loading indicator when signing up', (
      tester,
    ) async {
      when(mockAuthProvider.state).thenReturn(AuthState.loading);

      await tester.pumpWidget(createSignUpScreen());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Зарегистрироваться'), findsNothing);
    });

    testWidgets('should have password visibility toggles', (tester) async {
      when(mockAuthProvider.state).thenReturn(AuthState.unauthenticated);

      await tester.pumpWidget(createSignUpScreen());

      final visibilityIcons = find.byIcon(Icons.visibility_outlined);
      expect(visibilityIcons, findsNWidgets(2));

      await tester.tap(visibilityIcons.first);
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });
  });
}

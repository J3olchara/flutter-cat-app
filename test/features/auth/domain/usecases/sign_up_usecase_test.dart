import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:kototinder/features/auth/domain/entities/user.dart';
import 'package:kototinder/features/auth/domain/repositories/auth_repository.dart';
import 'package:kototinder/features/auth/domain/usecases/sign_up_usecase.dart';

import 'sign_up_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SignUpUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = SignUpUseCase(mockAuthRepository);
  });

  group('SignUpUseCase', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testConfirmPassword = 'password123';
    final testUser = User(id: '123', email: testEmail, displayName: null);

    test('should sign up successfully with valid credentials', () async {
      when(
        mockAuthRepository.signUp(testEmail, testPassword),
      ).thenAnswer((_) async => testUser);

      final result = await useCase(
        testEmail,
        testPassword,
        testConfirmPassword,
      );

      expect(result, equals(testUser));
      verify(mockAuthRepository.signUp(testEmail, testPassword));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should throw exception when email is empty', () async {
      expect(
        () => useCase('', testPassword, testConfirmPassword),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Все поля обязательны для заполнения'),
          ),
        ),
      );

      verifyNever(mockAuthRepository.signUp(any, any));
    });

    test('should throw exception when password is empty', () async {
      expect(
        () => useCase(testEmail, '', testConfirmPassword),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Все поля обязательны для заполнения'),
          ),
        ),
      );

      verifyNever(mockAuthRepository.signUp(any, any));
    });

    test('should throw exception when confirm password is empty', () async {
      expect(
        () => useCase(testEmail, testPassword, ''),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Все поля обязательны для заполнения'),
          ),
        ),
      );

      verifyNever(mockAuthRepository.signUp(any, any));
    });

    test('should throw exception when email format is invalid', () async {
      expect(
        () => useCase('invalid-email', testPassword, testConfirmPassword),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Некорректный формат email'),
          ),
        ),
      );

      verifyNever(mockAuthRepository.signUp(any, any));
    });

    test('should throw exception when password is too short', () async {
      expect(
        () => useCase(testEmail, '12345', '12345'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Пароль должен содержать минимум 6 символов'),
          ),
        ),
      );

      verifyNever(mockAuthRepository.signUp(any, any));
    });

    test('should throw exception when passwords do not match', () async {
      expect(
        () => useCase(testEmail, testPassword, 'different123'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Пароли не совпадают'),
          ),
        ),
      );

      verifyNever(mockAuthRepository.signUp(any, any));
    });

    test('should propagate repository errors', () async {
      when(
        mockAuthRepository.signUp(testEmail, testPassword),
      ).thenThrow(Exception('Email already in use'));

      expect(
        () => useCase(testEmail, testPassword, testConfirmPassword),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Email already in use'),
          ),
        ),
      );

      verify(mockAuthRepository.signUp(testEmail, testPassword));
    });
  });
}

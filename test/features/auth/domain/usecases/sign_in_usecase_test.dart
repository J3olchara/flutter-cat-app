import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:kototinder/features/auth/domain/entities/user.dart';
import 'package:kototinder/features/auth/domain/repositories/auth_repository.dart';
import 'package:kototinder/features/auth/domain/usecases/sign_in_usecase.dart';

import 'sign_in_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SignInUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = SignInUseCase(mockAuthRepository);
  });

  group('SignInUseCase', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    final testUser = User(
      id: '123',
      email: testEmail,
      displayName: 'Test User',
    );

    test('should sign in successfully with valid credentials', () async {
      when(
        mockAuthRepository.signIn(testEmail, testPassword),
      ).thenAnswer((_) async => testUser);

      final result = await useCase(testEmail, testPassword);

      expect(result, equals(testUser));
      verify(mockAuthRepository.signIn(testEmail, testPassword));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should throw exception when email is empty', () async {
      expect(
        () => useCase('', testPassword),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Email и пароль не могут быть пустыми'),
          ),
        ),
      );

      verifyNever(mockAuthRepository.signIn(any, any));
    });

    test('should throw exception when password is empty', () async {
      expect(
        () => useCase(testEmail, ''),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Email и пароль не могут быть пустыми'),
          ),
        ),
      );

      verifyNever(mockAuthRepository.signIn(any, any));
    });

    test('should throw exception when email format is invalid', () async {
      expect(
        () => useCase('invalid-email', testPassword),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Некорректный формат email'),
          ),
        ),
      );

      verifyNever(mockAuthRepository.signIn(any, any));
    });

    test('should throw exception when password is too short', () async {
      expect(
        () => useCase(testEmail, '12345'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Пароль должен содержать минимум 6 символов'),
          ),
        ),
      );

      verifyNever(mockAuthRepository.signIn(any, any));
    });

    test('should propagate repository errors', () async {
      when(
        mockAuthRepository.signIn(testEmail, testPassword),
      ).thenThrow(Exception('Network error'));

      expect(
        () => useCase(testEmail, testPassword),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Network error'),
          ),
        ),
      );

      verify(mockAuthRepository.signIn(testEmail, testPassword));
    });
  });
}

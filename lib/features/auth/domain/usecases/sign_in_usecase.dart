import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<User> call(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email и пароль не могут быть пустыми');
    }
    
    if (!_isValidEmail(email)) {
      throw Exception('Некорректный формат email');
    }

    if (password.length < 6) {
      throw Exception('Пароль должен содержать минимум 6 символов');
    }

    return await repository.signIn(email, password);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

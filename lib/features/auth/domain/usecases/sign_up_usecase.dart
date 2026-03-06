import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<User> call(
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      throw Exception('Все поля обязательны для заполнения');
    }

    if (!_isValidEmail(email)) {
      throw Exception('Некорректный формат email');
    }

    if (password.length < 6) {
      throw Exception('Пароль должен содержать минимум 6 символов');
    }

    if (password != confirmPassword) {
      throw Exception('Пароли не совпадают');
    }

    return await repository.signUp(email, password);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

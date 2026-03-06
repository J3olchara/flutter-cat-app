import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/analytics/analytics_service.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider with ChangeNotifier {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final AuthRepository authRepository;
  final AnalyticsService analyticsService;

  AuthProvider({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.authRepository,
    required this.analyticsService,
  }) {
    _listenToAuthChanges();
    _checkCurrentUser();
  }

  AuthState _state = AuthState.initial;
  AuthState get state => _state;

  User? _user;
  User? get user => _user;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _listenToAuthChanges() {
    authRepository.authStateChanges.listen((user) {
      _user = user;
      _state = user != null
          ? AuthState.authenticated
          : AuthState.unauthenticated;
      notifyListeners();
    });
  }

  Future<void> _checkCurrentUser() async {
    try {
      _user = await getCurrentUserUseCase();
      _state = _user != null
          ? AuthState.authenticated
          : AuthState.unauthenticated;
    } catch (e) {
      _state = AuthState.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await signInUseCase(email, password);
      _state = AuthState.authenticated;
      await analyticsService.logLoginSuccess();
      debugPrint('Sign in successful: ${_user?.email}');
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      await analyticsService.logLoginFailure(_errorMessage ?? 'Unknown error');
      debugPrint('Sign in error: $e');
    }

    notifyListeners();
  }

  Future<void> signUp(
    String email,
    String password,
    String confirmPassword,
  ) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await signUpUseCase(email, password, confirmPassword);
      _state = AuthState.authenticated;
      await analyticsService.logSignupSuccess();
      debugPrint('Sign up successful: ${_user?.email}');
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      await analyticsService.logSignupFailure(_errorMessage ?? 'Unknown error');
      debugPrint('Sign up error: $e');
    }

    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await signOutUseCase();
      _user = null;
      _state = AuthState.unauthenticated;
      debugPrint('Sign out successful');
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint('Sign out error: $e');
    }

    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

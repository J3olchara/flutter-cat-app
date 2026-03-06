import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../onboarding/presentation/screens/onboarding_screen.dart';
import '../../../onboarding/data/datasources/onboarding_local_datasource.dart';
import '../../../onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../../../core/analytics/analytics_service.dart';
import 'login_screen.dart';
import '../../../cats/presentation/screens/tab_bar_screen.dart';

class AuthWrapperScreen extends StatefulWidget {
  final AnalyticsService analyticsService;

  const AuthWrapperScreen({super.key, required this.analyticsService});

  @override
  State<AuthWrapperScreen> createState() => _AuthWrapperScreenState();
}

class _AuthWrapperScreenState extends State<AuthWrapperScreen> {
  bool _isOnboardingCompleted = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final onboardingRepo = OnboardingRepositoryImpl(
      OnboardingLocalDataSourceImpl(),
    );
    final completed = await onboardingRepo.isOnboardingCompleted();
    setState(() {
      _isOnboardingCompleted = completed;
      _isLoading = false;
    });
  }

  Future<void> _completeOnboarding() async {
    final onboardingRepo = OnboardingRepositoryImpl(
      OnboardingLocalDataSourceImpl(),
    );
    await onboardingRepo.setOnboardingCompleted();
    await widget.analyticsService.logOnboardingCompleted();
    setState(() {
      _isOnboardingCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isOnboardingCompleted) {
      return OnboardingScreen(onComplete: _completeOnboarding);
    }

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.state == AuthState.initial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (authProvider.state == AuthState.authenticated) {
          return const TabBarScreen();
        }

        return const LoginScreen();
      },
    );
  }
}

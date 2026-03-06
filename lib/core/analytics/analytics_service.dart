import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics;

  AnalyticsService({FirebaseAnalytics? analytics})
      : _analytics = analytics ?? FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }

  Future<void> logLoginSuccess() async {
    await _analytics.logEvent(
      name: 'login_success',
      parameters: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logLoginFailure(String error) async {
    await _analytics.logEvent(
      name: 'login_failure',
      parameters: {
        'error': error,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logSignupSuccess() async {
    await _analytics.logEvent(
      name: 'signup_success',
      parameters: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logSignupFailure(String error) async {
    await _analytics.logEvent(
      name: 'signup_failure',
      parameters: {
        'error': error,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logOnboardingCompleted() async {
    await _analytics.logEvent(
      name: 'onboarding_completed',
      parameters: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logCatLiked(String breedName) async {
    await _analytics.logEvent(
      name: 'cat_liked',
      parameters: {
        'breed': breedName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logBreedViewed(String breedName) async {
    await _analytics.logEvent(
      name: 'breed_viewed',
      parameters: {
        'breed': breedName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(
      screenName: screenName,
    );
  }
}

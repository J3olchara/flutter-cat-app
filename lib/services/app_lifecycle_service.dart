import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class AppLifecycleService with WidgetsBindingObserver {
  final FlutterLocalNotificationsPlugin _localNotifications;
  Timer? _reEngagementTimer;
  DateTime? _backgroundTime;
  
  static const _reEngagementDelaySeconds = 30;

  AppLifecycleService(this._localNotifications) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        _onAppGoesToBackground();
        break;
      case AppLifecycleState.resumed:
        _onAppReturnsToForeground();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  void _onAppGoesToBackground() {
    print('Приложение ушло в фон');
    _backgroundTime = DateTime.now();
    
    _reEngagementTimer?.cancel();
    _reEngagementTimer = Timer(
      Duration(seconds: _reEngagementDelaySeconds),
      _showReEngagementNotification,
    );
  }

  void _onAppReturnsToForeground() {
    print('Приложение вернулось на передний план');
    
    _reEngagementTimer?.cancel();
    _reEngagementTimer = null;
    
    if (_backgroundTime != null) {
      final duration = DateTime.now().difference(_backgroundTime!);
      print('Пользователь вернулся через ${duration.inSeconds} секунд');
      _backgroundTime = null;
    }
  }

  Future<void> _showReEngagementNotification() async {
    print('Показываем уведомление для возврата пользователя');
    
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'Важные уведомления',
      channelDescription: 'Канал для важных push-уведомлений',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      styleInformation: BigTextStyleInformation(
        'У нас тут столько милых котиков скучают по тебе! Заходи скорее, они ждут твоих лайков 💕',
      ),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.active,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      999,
      'Котики скучают! 😿',
      'У нас тут столько милых котиков скучают по тебе! Заходи скорее 💕',
      details,
      payload: 're_engagement',
    );
  }

  void dispose() {
    _reEngagementTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }
}

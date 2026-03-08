import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get localNotifications => _localNotifications;

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'high_importance_channel',
        'Важные уведомления',
        description: 'Канал для важных push-уведомлений',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

  Future<void> initialize() async {
    await _requestPermissions();
    await _initializeLocalNotifications();
    await _configureFCM();

    final token = await getToken();
    if (token != null) {
      debugPrint('FCM Token: $token');
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_androidChannel);
    }
  }

  Future<void> _configureFCM() async {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundTap);

    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundTap(initialMessage);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Получено уведомление на переднем плане: ${message.messageId}');

    final notification = message.notification;

    if (notification != null) {
      _showLocalNotification(
        title: notification.title ?? 'Кототиндер',
        body: notification.body ?? '',
        payload: message.data.toString(),
      );
    }
  }

  void _handleBackgroundTap(RemoteMessage message) {
    debugPrint('Уведомление открыто: ${message.messageId}');
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Нажато на уведомление: ${response.payload}');
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'Важные уведомления',
      channelDescription: 'Канал для важных push-уведомлений',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: DateTime.now().millisecond,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  Future<String?> getToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      return token;
    } catch (e) {
      debugPrint('Ошибка получения FCM токена: $e');
      return null;
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('Подписка на топик: $topic');
    } catch (e) {
      debugPrint('Ошибка подписки на топик: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('Отписка от топика: $topic');
    } catch (e) {
      debugPrint('Ошибка отписки от топика: $e');
    }
  }

  Future<void> scheduleWelcomeNotification({int delaySeconds = 15}) async {
    await Future.delayed(Duration(seconds: delaySeconds));

    await _showLocalNotification(
      title: 'Привет, котолюбитель! 🐱',
      body:
          'Не забудь посмотреть на милых котиков сегодня! Свайпай вправо, если понравился ❤️',
      payload: 'welcome_notification',
    );
  }

  void dispose() {}
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Обработка фонового сообщения: ${message.messageId}');
}

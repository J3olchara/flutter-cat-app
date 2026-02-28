# Настройка Firebase Cloud Messaging для Кототиндер

## Обзор

В проект добавлена поддержка push-уведомлений через Firebase Cloud Messaging (FCM). Это руководство описывает шаги для завершения настройки Firebase в вашем проекте.

## 📋 Что уже настроено

✅ Зависимости Firebase добавлены в `pubspec.yaml`:
- `firebase_core` - базовая библиотека Firebase
- `firebase_messaging` - для push-уведомлений
- `flutter_local_notifications` - для локальных уведомлений

✅ Android конфигурация:
- Google Services плагин добавлен в Gradle
- AndroidManifest настроен с необходимыми разрешениями
- Настроен канал уведомлений высокой важности

✅ iOS конфигурация:
- Info.plist настроен для background notifications
- Добавлены необходимые режимы фона

✅ Код сервиса:
- Создан `FirebaseMessagingService` для обработки уведомлений
- Интегрирован в `main.dart` с автоматической инициализацией

## 🔧 Необходимые шаги для завершения настройки

### 1. Создание Firebase проекта

1. Перейдите на [Firebase Console](https://console.firebase.google.com/)
2. Нажмите "Add project" или "Создать проект"
3. Введите название проекта (например, "Kototinder")
4. Следуйте инструкциям мастера создания проекта

### 2. Добавление Android приложения

1. В Firebase Console выберите ваш проект
2. Нажмите на иконку Android
3. Зарегистрируйте приложение:
   - **Android package name**: `com.kototinder.kototinder`
   - **App nickname**: Кототиндер (опционально)
   - **Debug signing certificate SHA-1**: (опционально, для разработки)

4. Скачайте файл `google-services.json`
5. Поместите его в: `android/app/google-services.json`

**Важно:** Файл должен находиться точно в папке `android/app/`, не в подпапках!

### 3. Добавление iOS приложения

1. В Firebase Console выберите ваш проект
2. Нажмите на иконку iOS
3. Зарегистрируйте приложение:
   - **iOS bundle ID**: Можно найти в `ios/Runner.xcodeproj/project.pbxproj` (ищите PRODUCT_BUNDLE_IDENTIFIER)
   - **App nickname**: Кототиндер (опционально)

4. Скачайте файл `GoogleService-Info.plist`
5. Добавьте его в Xcode:
   - Откройте `ios/Runner.xcworkspace` в Xcode
   - Перетащите `GoogleService-Info.plist` в проект Runner
   - Убедитесь, что выбрано "Copy items if needed"
   - Убедитесь, что файл добавлен в Runner target

### 4. Настройка iOS Push Notifications в Xcode

1. Откройте `ios/Runner.xcworkspace` в Xcode
2. Выберите проект Runner в навигаторе
3. Выберите target Runner
4. Перейдите на вкладку "Signing & Capabilities"
5. Нажмите "+ Capability"
6. Добавьте следующие capabilities:
   - **Push Notifications**
   - **Background Modes** (отметьте "Remote notifications")

### 5. Установка зависимостей

После добавления конфигурационных файлов выполните:

```bash
flutter pub get
```

### 6. Проверка настройки

Запустите приложение:

```bash
# Android
flutter run

# iOS
flutter run -d ios
```

В консоли должен появиться FCM токен:
```
FCM Token: <ваш-токен>
```

Сохраните этот токен - он понадобится для отправки тестовых уведомлений.

## 📱 Тестирование уведомлений

### Через Firebase Console

1. В Firebase Console перейдите в Cloud Messaging
2. Нажмите "Send your first message"
3. Заполните:
   - **Notification title**: Тестовое уведомление
   - **Notification text**: Привет из Кототиндера!
4. Нажмите "Send test message"
5. Вставьте FCM токен из консоли
6. Нажмите "Test"

### Через API (curl)

Получите Server Key из Firebase Console → Project Settings → Cloud Messaging → Server key

```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "FCM_TOKEN",
    "notification": {
      "title": "Новый котик!",
      "body": "Посмотри на этого милашку 🐱"
    },
    "data": {
      "cat_id": "123",
      "action": "open_cat_details"
    }
  }'
```

## 🎯 Использование в коде

### Получение FCM токена

```dart
import 'package:kototinder/services/firebase_messaging_service.dart';

final messagingService = FirebaseMessagingService();
await messagingService.initialize();

final token = await messagingService.getToken();
print('FCM Token: $token');
// Отправьте токен на ваш backend сервер
```

### Отложенное уведомление

```dart
// Показать приветственное уведомление через 15 секунд
messagingService.scheduleWelcomeNotification(delaySeconds: 15);

// Или с другой задержкой
messagingService.scheduleWelcomeNotification(delaySeconds: 30);
```

### Re-engagement уведомления

Приложение автоматически отправляет уведомление через 30 секунд после того, как пользователь закрывает приложение (сворачивает его). Это реализовано через `AppLifecycleService`, который отслеживает состояние приложения:

- Когда приложение уходит в фон → запускается таймер на 30 секунд
- Если пользователь возвращается раньше → таймер отменяется
- Если пользователь не вернулся → показывается уведомление "Котики скучают! 😿"

### Подписка на топики

```dart
// Подписаться на топик "new_cats"
await messagingService.subscribeToTopic('new_cats');

// Отписаться от топика
await messagingService.unsubscribeFromTopic('new_cats');
```

### Обработка данных уведомлений

Вы можете расширить методы в `firebase_messaging_service.dart`:

```dart
void _handleBackgroundTap(RemoteMessage message) {
  print('Уведомление открыто: ${message.messageId}');
  
  // Пример обработки данных
  final catId = message.data['cat_id'];
  if (catId != null) {
    // Открыть экран с деталями котика
    navigatorKey.currentState?.pushNamed('/cat-details', arguments: catId);
  }
}
```

## 🔔 Типы уведомлений

Сервис поддерживает три типа обработки:

1. **Foreground (приложение открыто)**: Показывается локальное уведомление
2. **Background (приложение свернуто)**: Обрабатывается `firebaseMessagingBackgroundHandler`
3. **Terminated (приложение закрыто)**: Обрабатывается через `getInitialMessage()`

## ⚙️ Структура уведомления

### Notification payload

```json
{
  "notification": {
    "title": "Заголовок",
    "body": "Текст уведомления"
  },
  "data": {
    "key1": "value1",
    "key2": "value2"
  }
}
```

### Data-only payload (не показывает уведомление автоматически)

```json
{
  "data": {
    "title": "Заголовок",
    "body": "Текст",
    "custom_field": "значение"
  }
}
```

## 🛠️ Дополнительные возможности

### Каналы уведомлений Android

В `firebase_messaging_service.dart` настроен канал `high_importance_channel`. Вы можете добавить больше каналов:

```dart
const lowPriorityChannel = AndroidNotificationChannel(
  'low_importance_channel',
  'Обычные уведомления',
  description: 'Канал для обычных уведомлений',
  importance: Importance.low,
);

await _localNotifications
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    ?.createNotificationChannel(lowPriorityChannel);
```

### iOS Badge счетчик

```dart
// Установить badge
await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  alert: true,
  badge: true,
  sound: true,
);
```

## 🔒 Безопасность

**ВАЖНО:** 
- Никогда не коммитьте `google-services.json` и `GoogleService-Info.plist` в публичный репозиторий
- Добавьте в `.gitignore`:
  ```
  android/app/google-services.json
  ios/Runner/GoogleService-Info.plist
  ```

## 📝 Troubleshooting

### Android

**Ошибка:** "google-services.json not found"
- Убедитесь, что файл находится в `android/app/`
- Выполните `flutter clean` и `flutter pub get`

**Ошибка:** "Default FirebaseApp is not initialized"
- Проверьте, что `Firebase.initializeApp()` вызывается в `main()`
- Убедитесь, что `google-services.json` правильно настроен

### iOS

**Уведомления не приходят**
- Проверьте, что добавлена capability "Push Notifications" в Xcode
- Убедитесь, что Apple Push Notification сертификат настроен в Firebase Console
- На симуляторе push-уведомления не работают - тестируйте на реальном устройстве

**Ошибка сборки в Xcode**
- Попробуйте: `cd ios && pod install && cd ..`
- Очистите кэш: `cd ios && pod deintegrate && pod install && cd ..`

## 📚 Полезные ссылки

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)

## ✅ Checklist

Перед деплоем убедитесь:

- [ ] Firebase проект создан
- [ ] `google-services.json` добавлен в `android/app/`
- [ ] `GoogleService-Info.plist` добавлен в Xcode проект
- [ ] iOS capabilities настроены (Push Notifications, Background Modes)
- [ ] Тестовое уведомление успешно получено
- [ ] FCM токен отправляется на backend (если есть)
- [ ] Конфигурационные файлы добавлены в `.gitignore`

---

**Готово!** 🎉 Push-уведомления настроены и готовы к использованию.

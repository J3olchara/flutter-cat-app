# Кототиндер Про

Мобильное приложение для знакомства с породами кошек.

## Реализованные фичи

### ДЗ-1
- Свайпы котиков влево/вправо
- Лайки и дизлайки с счетчиком
- Детальная информация о породах
- Список всех пород с поиском
- Обработка ошибок
- Push-уведомления

### ДЗ-2 (скриншоты в папке screenshots/hw2)
- Онбординг с анимациями (3 шага)
- Firebase Authentication (регистрация/вход)
- Firebase Analytics (события)
- Clean Architecture (Data/Domain/Presentation)
- Unit-тесты (14 тестов)
- Widget-тесты (16 тестов)
- CI/CD на GitHub Actions

## Технологии

- Flutter 3.38.4
- Dart 3.10.3
- Firebase (Auth, Analytics, Messaging)
- Provider (state management)
- Dio (HTTP клиент)
- TheCatAPI
- Mockito (тестирование)

## Структура

```
lib/
├── core/
│   ├── analytics/
│   └── di/
├── features/
│   ├── auth/
│   ├── onboarding/
│   └── cats/
└── services/
```

## Запуск

```bash
flutter pub get
flutter run
```

## Тестирование

```bash
flutter test
```

## Сборка APK

```bash
flutter build apk --release
```

APK находится в `build/app/outputs/flutter-apk/app-release.apk`

## Настройка Firebase

1. Создайте проект в Firebase Console
2. Включите Authentication (Email/Password)
3. Включите Analytics
4. Скачайте конфигурационные файлы:
   - `google-services.json` → `android/app/`
   - `GoogleService-Info.plist` → `ios/Runner/`

## API ключ TheCatAPI

Опционально: зарегистрируйтесь на thecatapi.com и добавьте ключ в:
`lib/features/cats/data/datasources/cat_remote_datasource.dart`

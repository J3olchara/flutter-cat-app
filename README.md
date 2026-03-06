# 🐱 Кототиндер Про

Мобильное приложение для знакомства с породами кошек в стиле Tinder. Листайте карточки котиков, лайкайте понравившихся, изучайте информацию о породах!

[![Flutter CI/CD](https://github.com/YOUR_USERNAME/flutter/actions/workflows/flutter.yml/badge.svg)](https://github.com/YOUR_USERNAME/flutter/actions/workflows/flutter.yml)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.24.0-blue.svg)](https://flutter.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📱 Скриншоты

*Скриншоты будут добавлены после сборки приложения*

## ⬇️ Скачать APK

Последняя версия приложения доступна в [Releases](https://github.com/YOUR_USERNAME/flutter/releases)

## ✨ Реализованные фичи

### ДЗ-1: Базовый функционал
- ✅ **Свайпы котиков** - пролистывайте карточки влево/вправо
- ✅ **Лайки и дизлайки** - кнопки и жесты для оценки котиков
- ✅ **Счетчик лайков** - отслеживание понравившихся котиков
- ✅ **Детальная информация** - подробные сведения о породе при клике
- ✅ **Список всех пород** - просмотр каталога с поиском
- ✅ **Красивый UI** - современный Material Design 3
- ✅ **Обработка ошибок** - корректные диалоги при проблемах с сетью
- ✅ **Кеширование изображений** - быстрая загрузка картинок
- ✅ **Push-уведомления** - Firebase Cloud Messaging

### ДЗ-2: Продвинутые возможности

#### 🎯 Функциональные требования
- ✅ **Онбординг** 
  - Горизонтально пролистываемый сценарий
  - 3 информативных шага о ключевых возможностях
  - Анимации котиков при перелистывании
  - Появляется только при первом запуске

- ✅ **Регистрация и вход**
  - Firebase Authentication (email/password)
  - Валидация полей с понятными сообщениями об ошибках
  - Сохранение состояния авторизации
  - Красивые формы с переключением видимости пароля

#### 🏗️ Архитектура
- ✅ **Clean Architecture**
  - Разделение на слои: Data / Domain / Presentation
  - Бизнес-логика вынесена в Use Cases
  - Репозитории с абстракциями
  - Dependency Injection через DI Container

#### 🧪 Тестирование
- ✅ **Unit-тесты** (14 тестов)
  - Тестирование `SignInUseCase` (валидация, успех, ошибки)
  - Тестирование `SignUpUseCase` (валидация паролей, успех, ошибки)
  - Использование моков через Mockito

- ✅ **Widget-тесты** (16 тестов)
  - Тестирование `LoginScreen` (валидация, UI, интеракции)
  - Тестирование `SignUpScreen` (валидация, UI, интеракции)
  - Проверка состояний загрузки

#### 🚀 DevOps
- ✅ **CI/CD на GitHub Actions**
  - Автоматический запуск на push/PR
  - Проверка форматирования (`dart format`)
  - Статический анализ (`flutter analyze`)
  - Запуск всех тестов
  - Сборка APK на main ветке
  - Пайплайн падает при ошибках

#### 📊 Аналитика
- ✅ **Firebase Analytics**
  - Логирование входа (`login_success`, `login_failure`)
  - Логирование регистрации (`signup_success`, `signup_failure`)
  - Завершение онбординга (`onboarding_completed`)
  - Лайки котиков (`cat_liked`)
  - Просмотр пород (`breed_viewed`)

## 🛠️ Технологии

### Основные
- **Flutter 3.24.0** - фреймворк для кросс-платформенной разработки
- **Dart 3.10.3** - язык программирования

### Архитектура и паттерны
- **Clean Architecture** - разделение на слои (Data/Domain/Presentation)
- **Provider** - state management
- **Dependency Injection** - ручная DI через Injection Container

### Firebase
- **Firebase Core** - инициализация Firebase
- **Firebase Auth** - аутентификация пользователей
- **Firebase Analytics** - аналитика событий
- **Firebase Messaging** - push-уведомления

### Сеть и данные
- **Dio** - HTTP клиент для API запросов
- **TheCatAPI** - API для получения информации о породах
- **Shared Preferences** - локальное хранение данных

### UI и UX
- **Material Design 3** - современные UI компоненты
- **Cached Network Image** - кеширование изображений
- **Flutter Card Swiper** - swipe-интерфейс для карточек

### Тестирование
- **flutter_test** - фреймворк для тестирования
- **Mockito** - создание моков для unit-тестов
- **Build Runner** - генерация кода для моков

### DevOps
- **GitHub Actions** - CI/CD пайплайн
- **Flutter Lints** - статический анализ кода

## 📁 Структура проекта

```
lib/
├── core/                       # Общие утилиты
│   ├── analytics/              # Сервис аналитики
│   └── di/                     # Dependency Injection
├── features/
│   ├── auth/                   # Авторизация
│   │   ├── data/               # Репозитории, источники данных
│   │   ├── domain/             # Entities, use cases, интерфейсы
│   │   └── presentation/       # UI, провайдеры, виджеты
│   ├── onboarding/             # Онбординг
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── cats/                   # Основной функционал
│       ├── data/               # API, локальное хранилище
│       ├── domain/             # Бизнес-логика
│       └── presentation/       # Экраны и виджеты
├── services/                   # Сервисы (Firebase Messaging, Lifecycle)
└── main.dart                   # Точка входа

test/
└── features/
    └── auth/
        ├── domain/usecases/    # Unit-тесты
        └── presentation/       # Widget-тесты
```

## 🚀 Быстрый старт

### Предварительные требования
- Flutter SDK 3.24.0 или выше
- Dart SDK 3.10.3 или выше
- Android Studio / VS Code
- Firebase проект (для функций авторизации и аналитики)

### Установка

1. Клонируйте репозиторий:
```bash
git clone https://github.com/YOUR_USERNAME/flutter.git
cd flutter
```

2. Установите зависимости:
```bash
flutter pub get
```

3. Настройте Firebase:
   - Создайте проект в [Firebase Console](https://console.firebase.google.com/)
   - Скачайте `google-services.json` (Android) и `GoogleService-Info.plist` (iOS)
   - Поместите файлы в соответствующие папки
   - Включите Authentication (Email/Password) и Analytics

4. (Опционально) Добавьте API ключ TheCatAPI:
   - Зарегистрируйтесь на [thecatapi.com](https://thecatapi.com)
   - Откройте `lib/features/cats/data/datasources/cat_remote_datasource.dart`
   - Замените `static const String? apiKey = null;` на ваш ключ

### Запуск

```bash
flutter run
```

### Тестирование

Запуск всех тестов:
```bash
flutter test
```

Запуск с покрытием:
```bash
flutter test --coverage
```

Запуск только unit-тестов:
```bash
flutter test test/features/auth/domain/
```

### Сборка APK

Release сборка:
```bash
flutter build apk --release
```

APK будет находиться в `build/app/outputs/flutter-apk/app-release.apk`

## 📊 Статистика кода

- **30 тестов** (14 unit + 16 widget)
- **Clean Architecture** с разделением на слои
- **Покрытие тестами** ключевой бизнес-логики
- **CI/CD** с автоматическими проверками

## 🎯 Чек-лист выполнения ДЗ-2

### Базовый минимум
- [x] Актуальные скриншоты приложения
- [x] Актуальный APK (релизная сборка)
- [x] Обновленное README с описанием и фичами
- [x] Ссылка на скачивание APK
- [x] Чистый код без bang-операторов
- [x] API-ключи не захардкожены
- [x] Обработка всех исключений

### Функциональные требования
- [x] Онбординг при первом запуске
- [x] Горизонтальный пролистываемый сценарий
- [x] Анимации котиков при перелистывании
- [x] Регистрация и вход через Firebase
- [x] Валидация полей
- [x] Сохранение состояния авторизации

### Технические требования
- [x] Clean Architecture (Data/Domain/Presentation)
- [x] Бизнес-логика в Use Cases
- [x] Dependency Injection
- [x] Unit-тесты (минимум 2)
- [x] Widget-тесты (минимум 2)

### Продвинутые требования
- [x] CI/CD на GitHub Actions
- [x] flutter analyze
- [x] flutter test
- [x] dart format
- [x] Firebase Analytics с событиями

## 📝 Лицензия

MIT License

## 👨‍💻 Автор

Arseniy Zhukov

## 🙏 Благодарности

- [TheCatAPI](https://thecatapi.com) - за предоставление API
- [Firebase](https://firebase.google.com) - за backend сервисы
- Flutter Team - за отличный фреймворк

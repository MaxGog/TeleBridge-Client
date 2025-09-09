# TeleBridge Client - Telegram Client на Flutter

TeleBridge Client - Flutter-клиент для Telegram Bot API с Material Design 3

## 📋 Текущая функциональность

- ✅ Добавление аккаунтов ботов по токену
- ✅ Управление папками чатов
- ✅ Список чатов с организацией по папкам
- ✅ Просмотр и отправка сообщений
- ✅ Поддержка вложений (изображения, документы, аудио)
- ✅ Настройки темы (светлая/тёмная/системная)
- ✅ Управление уведомлениями
- ✅ Material Design 3 интерфейс

## 🚀 Что нужно доделать для полной реализации

### 1. Интеграция с Telegram Bot API ✅
- [ ] Реальная валидация токенов через `getMe` endpoint
- [ ] Получение реальных чатов и сообщений
- [ ] Отправка сообщений через API
- [ ] Загрузка и отправка медиафайлов

### 2. Работа с медиафайлами 📁
- [ ] Интеграция с `image_picker` для выбора фото
- [ ] Поддержка `file_picker` для документов
- [ ] Реальная загрузка файлов на сервер Telegram
- [ ] Кэширование медиафайлов

### 3. Уведомления 🔔
- [ ] Интеграция с `flutter_local_notifications`
- [ ] Настройка каналов уведомлений
- [ ] Обработка входящих сообщений в фоне

### 4. Безопасность и хранение 🔒
- [ ] Шифрованное хранение токенов (`flutter_secure_storage`)
- [ ] Безопасное управление сессиями
- [ ] Миграция данных между версиями

### 5. Дополнительные функции ⚡
- [ ] Поиск по чатам и сообщениям
- [ ] Голосовые сообщения
- [ ] Статусы онлайн/оффлайн
- [ ] Ответы и пересылка сообщений
- [ ] Удаление и редактирование сообщений

### 6. Производительность и оптимизация 🚀
- [ ] Пагинация сообщений
- [ ] Ленивая загрузка изображений
- [ ] Оптимизация перестроения виджетов
- [ ] Кэширование данных

## 📁 Структура проекта

```
lib/
├── main.dart                      # Точка входа приложения
│
├── core/                          # Ядро приложения
│   ├── constants/                 # Константы и перечисления
│   ├── errors/                    # Обработка ошибок
│   ├── network/                   # Сетевая логика
│   └── utils/                     # Вспомогательные утилиты
│
├── data/                          # Уровень данных
│   ├── datasources/               # Источники данных
│   │   ├── local/                 # Локальное хранилище
│   │   └── remote/                # Удаленные API
│   ├── models/                    # Модели данных
│   │   ├── account.dart           # Модель аккаунта
│   │   ├── message.dart           # Модель сообщения
│   │   ├── chat.dart              # Модель чата
│   │   ├── attachment.dart        # Модель вложения
│   │   └── chat_folder.dart       # Модель папки чатов
│   └── repositories/              # Репозитории
│
├── domain/                        # Бизнес-логика
│   ├── entities/                  # Сущности
│   ├── repositories/              # Интерфейсы репозиториев
│   └── usecases/                  # Use cases
│
├── presentation/                  # UI уровень
│   ├── cubits/                    # Состояние (Cubit/Bloc)
│   │   ├── chat_cubit.dart        # Состояние чатов
│   │   ├── message_cubit.dart     # Состояние сообщений
│   │   ├── account_cubit.dart     # Состояние аккаунтов
│   │   └── settings_cubit.dart    # Состояние настроек
│   │
│   ├── screens/                   # Экраны приложения
│   │   ├── chat_list_screen.dart  # Список чатов
│   │   ├── chat_screen.dart       # Экран чата
│   │   ├── add_account_screen.dart# Добавление аккаунта
│   │   ├── settings_screen.dart   # Настройки
│   │   └── folder_management_screen.dart # Управление папками
│   │
│   ├── widgets/                   # Переиспользуемые виджеты
│   │   ├── message_bubble.dart    # Пузырь сообщения
│   │   ├── chat_list_item.dart    # Элемент списка чатов
│   │   ├── attachment_picker.dart # Выбор вложений
│   │   └── custom_app_bar.dart    # Кастомный AppBar
│   │
│   └── theme/                     # Тема приложения
│       ├── app_theme.dart         # Настройки темы
│       └── color_scheme.dart      # Цветовая схема
│
└── di/                            # Dependency Injection
    └── injector.dart              # Инициализация зависимостей

test/                              # Тесты
├── unit/                          # Юнит-тесты
├── widget/                        # Виджет-тесты
└── integration/                   # Интеграционные тесты

assets/
├── images/                        # Изображения
├── icons/                         # Иконки
└── translations/                  # Локализации
```

## 🛠️ Технологический стек

- **Flutter 3.0+** - Основной фреймворк
- **Dart 3.0+** - Язык программирования
- **HTTP** - Для работы с Telegram API
- **Provider/Bloc** - State management
- **Shared Preferences** - Локальное хранилище
- **Flutter Secure Storage** - Безопасное хранение
- **Image Picker** - Выбор изображений
- **File Picker** - Выбор файлов
- **Cached Network Image** - Кэширование изображений

### Настройка Telegram Bot API
1. Создайте бота через @BotFather
2. Получите API токен
3. Добавьте токен в настройки приложения

## 📱 Поддерживаемые платформы

- ✅ Android 9.0+
- ✅ iOS 13.0+
- ✅ Web

## 🚀 Процесс разработки

### Текущий статус
- [x] Базовый UI и навигация
- [x] Модели данных
- [x] Mock-реализация чатов
- [ ] Интеграция с реальным Telegram API
- [x] Уведомления
- [x] Безопасное хранение

### Приоритетные задачи
1. Интеграция с Telegram Bot API
2. Реальная отправка/получение сообщений
3. Загрузка медиафайлов
4. Система уведомлений
5. Безопасное хранение токенов

## 🔒 Безопасность

- Токены хранятся в зашифрованном виде
- Все сетевые запросы через HTTPS
- Валидация входящих данных
- Регулярное обновление зависимостей

## 📊 Производительность

- Ленивая загрузка списков
- Кэширование изображений
- Оптимизация перестроения виджетов
- Фоновая обработка данных

## 🤝 Участие в разработке

1. Форкните репозиторий
2. Создайте feature branch
3. Commit ваши изменения
4. Push в branch
5. Создайте Pull Request

## 📄 Лицензия

MIT License - смотрите файл LICENSE для деталей.

## 📞 Поддержка

Если у вас есть вопросы или предложения:
- Создайте Issue в репозитории
- Напишите на email: max.gog2005@outlook.com
- Telegram: @MaxGog

---

**Примечание**: Это приложение в активной разработке. Некоторые функции могут быть не полностью реализованы или содержать ошибки.

# 🚀 Полное руководство по запуску проекта

### 📋 Предварительные требования

#### Для всех платформ:
- **Flutter SDK 3.0+** (рекомендуется 3.13.0+)
- **Dart 3.0+**
- **Git**
- **IDE**: Android Studio, VS Code или IntelliJ IDEA

#### Для Android:
- **Java JDK 11+**
- **Android SDK** (API 33+)
- **Android Studio** с установленными:
  - Android SDK Command-line Tools
  - Android SDK Build-Tools
  - Android Emulator

#### Для iOS:
- **Mac computer** с macOS 12.0+
- **Xcode 14.0+**
- **CocoaPods 1.11.0+**

#### Для Web:
- **Chrome browser** для разработки
- **Web development tools**

---

## 🔧 Шаг 1: Установка Flutter

### Windows:
```bash
# Скачайте Flutter SDK
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.13.0-stable.zip

# Разархивируйте в C:\src\flutter
Expand-Archive flutter_windows_3.13.0-stable.zip -DestinationPath C:\src

# Добавьте в PATH
setx PATH "%PATH%;C:\src\flutter\bin"

# Установите Android Studio
# Скачайте с: https://developer.android.com/studio
```

### macOS:
```bash
# Установка через Homebrew
brew install --cask flutter

# Или ручная установка
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Установите Xcode из App Store
```

### Linux (Ubuntu/Debian):
```bash
# Установка зависимостей
sudo apt-get update
sudo apt-get install curl file git unzip xz-utils zip libglu1-mesa

# Скачайте Flutter
cd ~
git clone https://github.com/flutter/flutter.git -b stable

# Добавьте в PATH
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
```

---

## 🔍 Шаг 2: Проверка установки

```bash
# Проверьте установку Flutter
flutter doctor

# Ожидаемый вывод:
[✓] Flutter (Channel stable, 3.13.0, on macOS 13.5.2 22G91 darwin-arm64, locale ru-RU)
[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.2)
[✓] Xcode - develop for iOS and macOS (Xcode 14.3.1)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2022.2)
[✓] VS Code (version 1.82.2)
[✓] Connected device (2 available)
[✓] Network resources
```

Если есть проблемы, выполните:
```bash
flutter doctor --android-licenses
# Примите все лицензии
```

---

## 📥 Шаг 3: Клонирование и настройка проекта

```bash
# Клонируйте репозиторий
git clone <your-repository-url>
cd materialgram-client

# Установите зависимости
flutter pub get

# Проверьте конфигурацию
flutter analyze

# Запустите тесты
flutter test
```

---

## 🤖 Шаг 4: Запуск на Android

### Настройка Android окружения:

1. **Откройте Android Studio**
2. **Установите SDK Tools:**
   - File → Settings → Appearance & Behavior → System Settings → Android SDK
   - SDK Tools tab → установите:
     - Android SDK Command-line Tools
     - Android SDK Build-Tools 33.0.0+
     - Android Emulator
     - Android SDK Platform-Tools

3. **Создайте эмулятор:**
   - Tools → Device Manager → Create Device
   - Выберите устройство (рекомендуется Pixel 5)
   - Выберите систему (API 33, Android 13)
   - Завершите настройку

### Запуск на эмуляторе:

```bash
# Запустите эмулятор
flutter emulators --launch <emulator-id>

# Или через Android Studio:
# Tools → Device Manager → запустите эмулятор

# Запустите приложение
flutter run
```

### Запуск на физическом устройстве:

1. **Включите Developer Options:**
   - Настройки → О телефоне → нажмите 7 раз на "Номер сборки"

2. **Включите USB Debugging:**
   - Настройки → Для разработчиков → USB-отладка

3. **Подключите устройство:**
```bash
# Проверьте подключенные устройства
flutter devices

# Запустите на устройстве
flutter run -d <device-id>
```

---

## 🍎 Шаг 5: Запуск на iOS

### Настройка iOS окружения:

1. **Установите Xcode** из App Store
2. **Установите CocoaPods:**
```bash
sudo gem install cocoapods
pod setup
```

3. **Настройте подписывание кода:**
```bash
cd ios
pod install
cd ..
```

### Запуск на симуляторе:

```bash
# Откройте симулятор
open -a Simulator

# Или через терминал
flutter emulators --launch apple_ios_simulator

# Запустите приложение
flutter run
```

### Запуск на физическом iOS устройстве:

1. **Подключите iPhone по USB**
2. **Разрешите доверие компьютеру** на телефоне
3. **Настройте подписывание в Xcode:**
```bash
open ios/Runner.xcworkspace
```

В Xcode:
- Выберите Runner project
- Target Runner → Signing & Capabilities
- Выберите вашу Team (требуется Apple Developer Account)
- Убедитесь что Bundle Identifier уникален

```bash
# Запустите на устройстве
flutter run -d <device-id>
```

---

## 🌐 Шаг 6: Запуск для Web

```bash
# Включите web поддержку
flutter config --enable-web

# Запустите для web
flutter run -d chrome

# Или соберите для production
flutter build web
```

---

## 🛠️ Шаг 7: Настройка Telegram Bot API

### Получение токена бота:

1. **Откройте Telegram** и найдите @BotFather
2. **Создайте нового бота:**
   - `/newbot`
   - Введите имя бота
   - Введите username бота
   - Сохраните полученный токен

3. **Настройте права бота:**
   - `/setprivacy` → отключите для тестирования
   - `/setcommands` → настройте команды

### Настройка приложения:

Создайте файл `lib/core/config/api_config.dart`:
```dart
class ApiConfig {
  static const String telegramApiUrl = 'https://api.telegram.org/bot';
  static const int apiTimeout = 30; // seconds
  static const int maxRetries = 3;
}
```

---

## 🔧 Шаг 8: Решение частых проблем

### Проблема: "Gradle build failed"
```bash
# Решение:
flutter clean
rm -rf android/app/build
flutter pub get
cd android && ./gradlew clean && cd ..
```

### Проблема: "CocoaPods not installed"
```bash
# Решение:
sudo gem install cocoapods
pod repo update
cd ios && pod install && cd ..
```

### Проблема: "Missing Android SDK"
```bash
# Решение:
# Откройте Android Studio → SDK Manager
# Установите Android SDK Platform 33
# Установите Android SDK Build-Tools 33.0.0
```

### Проблема: "No devices available"
```bash
# Решение:
# Для Android: запустите эмулятор через Android Studio
# Для iOS: откройте Simulator через Xcode
# Или подключите физическое устройство
```

### Проблема: "Certificate verify failed"
```bash
# Решение:
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

---

## 📱 Шаг 9: Сборка production версий

### Android APK:
```bash
flutter build apk --release --target-platform android-arm64

# Или App Bundle для Google Play:
flutter build appbundle --release
```

### iOS Archive:
```bash
flutter build ios --release --no-codesign

# Затем откройте Xcode:
open ios/Runner.xcworkspace
# Product → Archive → Distribute App
```

### Web Build:
```bash
flutter build web --release --web-renderer html
```

---

## 🧪 Шаг 10: Тестирование приложения

### Unit тесты:
```bash
flutter test test/unit/
```

### Widget тесты:
```bash
flutter test test/widget/
```

### Integration тесты:
```bash
flutter test test/integration/
```

### Запуск всех тестов:
```bash
flutter test
```

---

## 📊 Шаг 11: Анализ и отладка

### Анализ кода:
```bash
flutter analyze
```

### Проверка производительности:
```bash
flutter run --profile
```

### Отладка:
```bash
flutter run --debug
# Откройте DevTools: flutter devtools
```

---

## 🎯 Готово!

Ваше приложение должно запуститься успешно. Если возникли проблемы:

1. Проверьте `flutter doctor`
2. Убедитесь что все зависимости установлены
3. Проверьте подключение к интернету
4. Убедитесь что порты не заняты

Для дополнительной помощи посетите:
- [Flutter Documentation](https://flutter.dev/docs)
- [Telegram Bot API](https://core.telegram.org/bots/api)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)

---

**Примечание**: Первый запуск может занять несколько минут из-за загрузки зависимостей и компиляции кода.
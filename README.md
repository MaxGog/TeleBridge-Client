# Telegram Client на Flutter
Простой Telegram клиент с базовыми функциями: список чатов, отправка сообщений и медиафайлов.

## 📋 Функциональность

- ✅ Список чатов с аватарами
- ✅ Просмотр сообщений в чате
- ✅ Отправка текстовых сообщений
- ✅ Поддержка медиафайлов (изображения)
- ✅ Индикаторы непрочитанных сообщений
- ✅ Время последнего сообщения
- ✅ Разделение входящих/исходящих сообщений

## 🚀 Запуск приложения

### Предварительные требования

1. **Flutter SDK** - версия 3.0 или выше
2. **Android Studio** или **Xcode** (для iOS)
3. **Эмулятор/симулятор** или физическое устройство

### Установка Flutter

Если Flutter не установлен:

#### Для Windows:
```bash
# Скачайте Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable

# Добавьте в PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Проверьте установку
flutter doctor
```

#### Для macOS:
```bash
# Установка через Homebrew
brew install --cask flutter

# Или вручную
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Проверьте установку
flutter doctor
```

### Шаг 1: Клонирование репозитория

```bash
git clone <ваш-репозиторий>
cd telegram-flutter-client
```

### Шаг 2: Установка зависимостей

```bash
flutter pub get
```

### Шаг 3: Запуск на Android

#### Вариант A: Запуск на эмуляторе

1. Откройте Android Studio
2. Создайте эмулятор через AVD Manager
3. Запустите эмулятор
4. Выполните команду:

```bash
flutter run
```

#### Вариант B: Запуск на физическом устройстве

1. Включите **USB Debugging** на телефоне:
   - Настройки → О телефоне → нажмите 7 раз на "Номер сборки"
   - Настройки → Для разработчиков → USB-отладка
2. Подключите телефон по USB
3. Выполните:

```bash
flutter devices
flutter run -d <ваше-устройство>
```

### Шаг 4: Запуск на iOS

#### Предварительные требования для iOS:

1. **Mac computer** с macOS
2. **Xcode** 14 или выше
3. **CocoaPods** (устанавливается автоматически с Flutter)

#### Настройка iOS:

1. Откройте терминал в папке проекта:
```bash
cd ios
pod install
cd ..
```

2. Откройте Xcode workspace:
```bash
open ios/Runner.xcworkspace
```

3. В Xcode:
   - Выберите команду разработки в Signing & Capabilities
   - Убедитесь, что Bundle Identifier уникален

#### Запуск на iOS симуляторе:

```bash
# Посмотреть доступные симуляторы
flutter emulators --launch apple_ios_simulator

# Или запустить конкретный симулятор
flutter run -d iPhone\ 15
```

#### Запуск на физическом iOS устройстве:

1. Подключите iPhone по USB
2. Разрешите отладку на телефоне
3. Выполните:

```bash
flutter run -d <your-iphone-id>
```

### Шаг 5: Сборка приложения

#### Сборка APK для Android:

```bash
flutter build apk --release
```

#### Сборка App Bundle для Google Play:

```bash
flutter build appbundle --release
```

#### Сборка для iOS:

```bash
flutter build ios --release
```

## 🛠️ Troubleshooting (Решение проблем)

### Частые проблемы на Android:

**Проблема**: `Gradle build failed`
**Решение**: 
```bash
flutter clean
flutter pub get
```

**Проблема**: `Minimum supported Gradle version is X.X`
**Решение**: Обновите Gradle в `android/build.gradle`

### Частые проблемы на iOS:

**Проблема**: `Signing for Runner requires a development team`
**Решение**: 
- Откройте `ios/Runner.xcworkspace` в Xcode
- Выберите team в Signing & Capabilities

**Проблема**: `CocoaPods not installed`
**Решение**:
```bash
sudo gem install cocoapods
pod setup
```

### Общие проблемы:

**Проблема**: `Waiting for another flutter command to release the startup lock`
**Решение**:
```bash
rm flutter/bin/cache/lockfile
```

**Проблема**: Эмулятор не запускается
**Решение**: Перезапустите эмулятор через Android Studio AVD Manager

## 📱 Тестирование приложения

### Тестовые данные

Приложение использует mock-данные:
- 2 тестовых чата
- Примеры сообщений
- Заглушки для изображений

### Функции для тестирования:

1. **Тап по чату** - переход в диалог
2. **Ввод текста** в поле ввода + отправка
3. **Просмотр истории** сообщений
4. **Свайпы** и навигация

## 🔧 Настройка окружения

Проверьте окружение командой:
```bash
flutter doctor
```

Убедитесь, что вывод показывает:
- ✅ Flutter (Channel stable, version)
- ✅ Android toolchain (для Android)
- ✅ Xcode (для iOS)
- ✅ Chrome (для web)
- ✅ Android Studio/VS Code

## 📁 Структура проекта

```
lib/
├── main.dart              # Точка входа
├── core/                 # Основная логика
├── data/                 # Данные и модели
├── presentation/         # UI компоненты
└── utils/               # Вспомогательные утилиты
```

## ⚠️ Важные замечания

1. **Это демо-версия** без реального Telegram API
2. Для production нужно интегрировать TDLib
3. Данные сохраняются только в памяти
4. Нет поддержки push-уведомлений

## 📞 Поддержка

Если возникли проблемы с запуском:

1. Проверьте `flutter doctor`
2. Убедитесь, что эмулятор/устройство доступны
3. Попробуйте `flutter clean && flutter pub get`

## 🎯 Следующие шаги

После успешного запуска можно:
1. Интегрировать настоящий TDLib
2. Добавить аутентификацию
3. Реализовать реальные чаты
4. Добавить уведомления
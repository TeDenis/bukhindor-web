# Скрипты для запуска мобильного приложения

Этот каталог содержит скрипты для удобного запуска Flutter приложения на мобильных платформах и Docker.

## 📋 Предварительные требования

### Для всех платформ:
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)

### Для Docker:
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### Для Android:
- [Android Studio](https://developer.android.com/studio)
- [Android SDK](https://developer.android.com/studio#command-tools)
- Android Virtual Device (AVD) - создается через Android Studio

### Для iOS (только macOS):
- [Xcode](https://developer.apple.com/xcode/)
- iOS Simulator (устанавливается с Xcode)

## 🚀 Использование скриптов

### 1. Установка зависимостей

```bash
./scripts/install_dependencies.sh
```

Этот скрипт выполняет:
- Проверку наличия Flutter
- Очистку кэша проекта
- Установку зависимостей (`flutter pub get`)
- Генерацию кода (`build_runner`)
- Создание splash screen

### 2. Docker пересборка

```bash
# Обычная пересборка
./scripts/docker-rebuild.sh

# Пересборка с очисткой кэша
./scripts/docker-rebuild.sh --no-cache
```

Скрипт решает проблемы с кэшированием Docker:
- Останавливает существующий контейнер
- Удаляет старый образ
- Принудительно пересобирает контейнер
- Запускает новый контейнер
- Показывает статус и логи

### 3. Запуск на Android

```bash
./scripts/run_android.sh
```

Скрипт:
- Проверяет наличие Android SDK
- Ищет доступные Android устройства
- Автоматически запускает эмулятор, если нет подключенных устройств
- Запускает приложение

### 4. Запуск на iOS

```bash
./scripts/run_ios.sh
```

Скрипт:
- Проверяет, что вы на macOS
- Проверяет наличие Xcode
- Ищет доступные iOS симуляторы
- Автоматически запускает симулятор, если нет подключенных устройств
- Запускает приложение

### 5. Универсальный запуск

```bash
# Автоматический выбор платформы
./scripts/run_mobile.sh

# Явное указание платформы
./scripts/run_mobile.sh android
./scripts/run_mobile.sh ios
```

## 🔧 Настройка эмуляторов

### Android AVD
1. Откройте Android Studio
2. Перейдите в Tools → AVD Manager
3. Создайте новый Virtual Device
4. Выберите устройство (например, Pixel 4)
5. Выберите образ системы (например, API 33)

### iOS Simulator
1. Откройте Xcode
2. Перейдите в Window → Devices and Simulators
3. На вкладке Simulators нажмите "+"
4. Выберите устройство (например, iPhone 14)
5. Выберите версию iOS

## 🐛 Устранение неполадок

### Проблемы с Android:
- **"Android SDK не найден"**: Установите Android Studio и Android SDK
- **"Нет доступных AVD"**: Создайте AVD через Android Studio
- **Эмулятор не запускается**: Проверьте, что включена виртуализация в BIOS

### Проблемы с iOS:
- **"Xcode не найден"**: Установите Xcode из App Store
- **"Нет доступных симуляторов"**: Установите симуляторы через Xcode
- **Ошибки сборки**: Выполните `flutter clean` и переустановите зависимости

### Общие проблемы:
- **"Flutter не найден"**: Добавьте Flutter в PATH
- **Ошибки зависимостей**: Выполните `./scripts/install_dependencies.sh`
- **Проблемы с кэшем**: Выполните `flutter clean`

## 📱 Подключение физических устройств

### Android:
1. Включите режим разработчика на устройстве
2. Включите USB отладку
3. Подключите устройство по USB
4. Разрешите отладку на устройстве

### iOS:
1. Подключите iPhone по USB
2. Доверьтесь компьютеру на iPhone
3. В Xcode добавьте устройство в список разработчиков

## 🎯 Быстрый старт

```bash
# Первый запуск
./scripts/install_dependencies.sh
./scripts/run_mobile.sh

# Последующие запуски
./scripts/run_mobile.sh android  # для Android
./scripts/run_mobile.sh ios      # для iOS
``` 
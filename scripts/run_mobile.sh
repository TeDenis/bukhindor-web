#!/bin/bash

# Универсальный скрипт для запуска Flutter приложения на мобильных платформах
# Использование: ./scripts/run_mobile.sh [android|ios|auto]

set -e  # Остановка при ошибке

# Определение платформы
PLATFORM=${1:-"auto"}

echo "📱 Универсальный запуск мобильного приложения..."

# Проверка наличия Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter не найден. Установите Flutter: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "📋 Доступные устройства:"
flutter devices

# Функция для автоматического выбора платформы
auto_select_platform() {
    echo "🤖 Проверка Android..."
    android_available=$(flutter devices | grep -E "(android|Android)" || true)
    
    echo "🍎 Проверка iOS..."
    ios_available=$(flutter devices | grep -E "(ios|iOS)" || true)
    
    if [ -n "$android_available" ]; then
        echo "✅ Android доступен"
        PLATFORM="android"
    elif [ -n "$ios_available" ]; then
        echo "✅ iOS доступен"
        PLATFORM="ios"
    else
        echo "❌ Нет доступных мобильных устройств"
        echo "Запустите эмулятор или подключите устройство"
        exit 1
    fi
}

# Выбор платформы
case $PLATFORM in
    "android"|"Android"|"ANDROID")
        echo "🤖 Запуск на Android..."
        ./scripts/run_android.sh
        ;;
    "ios"|"iOS"|"IOS")
        echo "🍎 Запуск на iOS..."
        ./scripts/run_ios.sh
        ;;
    "auto"|"")
        echo "🔄 Автоматический выбор платформы..."
        auto_select_platform
        echo "🎯 Выбрана платформа: $PLATFORM"
        if [ "$PLATFORM" = "android" ]; then
            ./scripts/run_android.sh
        else
            ./scripts/run_ios.sh
        fi
        ;;
    *)
        echo "❌ Неизвестная платформа: $PLATFORM"
        echo "Доступные опции: android, ios, auto"
        exit 1
        ;;
esac

echo "✅ Приложение успешно запущено!" 
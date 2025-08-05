#!/bin/bash

# Скрипт для запуска Flutter приложения на Android эмуляторе
# Использование: ./scripts/run_android.sh

set -e  # Остановка при ошибке

echo "🤖 Запуск приложения на Android..."

# Проверка наличия Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter не найден. Установите Flutter: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Проверка наличия Android SDK
if ! command -v adb &> /dev/null; then
    echo "❌ Android SDK не найден. Установите Android Studio и Android SDK"
    exit 1
fi

echo "📱 Поиск доступных Android устройств..."
flutter devices

echo "🔍 Проверка подключенных устройств..."
adb devices

# Функция для запуска эмулятора
start_emulator() {
    echo "🚀 Запуск Android эмулятора..."
    
    # Поиск доступных AVD
    available_avds=$(emulator -list-avds)
    
    if [ -z "$available_avds" ]; then
        echo "❌ Нет доступных Android Virtual Devices (AVD)"
        echo "Создайте AVD через Android Studio: Tools -> AVD Manager"
        exit 1
    fi
    
    # Выбор первого доступного AVD
    first_avd=$(echo "$available_avds" | head -n 1)
    echo "📱 Запуск эмулятора: $first_avd"
    
    # Запуск эмулятора в фоне
    emulator -avd "$first_avd" &
    emulator_pid=$!
    
    echo "⏳ Ожидание запуска эмулятора..."
    sleep 10
    
    # Ожидание готовности эмулятора
    while ! adb shell getprop sys.boot_completed 2>/dev/null | grep -q "1"; do
        echo "⏳ Эмулятор загружается..."
        sleep 5
    done
    
    echo "✅ Эмулятор готов!"
}

# Проверка, есть ли уже запущенные Android устройства
android_devices=$(flutter devices | grep -E "(android|Android)" || true)

if [ -z "$android_devices" ]; then
    echo "📱 Android устройства не найдены, запускаем эмулятор..."
    start_emulator
else
    echo "✅ Android устройство уже доступно"
fi

echo "🔧 Сборка и запуск приложения..."
flutter run -d android

echo "✅ Приложение запущено на Android!" 
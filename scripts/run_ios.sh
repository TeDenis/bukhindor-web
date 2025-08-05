#!/bin/bash

# Скрипт для запуска Flutter приложения на iOS симуляторе
# Использование: ./scripts/run_ios.sh

set -e  # Остановка при ошибке

echo "🍎 Запуск приложения на iOS..."

# Проверка операционной системы
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ iOS симулятор доступен только на macOS"
    exit 1
fi

# Проверка наличия Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter не найден. Установите Flutter: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Проверка наличия Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode не найден. Установите Xcode из App Store"
    exit 1
fi

echo "📱 Поиск доступных iOS устройств..."
flutter devices

# Функция для запуска iOS симулятора
start_simulator() {
    echo "🚀 Запуск iOS симулятора..."
    
    # Поиск доступных симуляторов
    available_simulators=$(xcrun simctl list devices available | grep "iPhone" | head -5)
    
    if [ -z "$available_simulators" ]; then
        echo "❌ Нет доступных iOS симуляторов"
        echo "Установите симуляторы через Xcode: Window -> Devices and Simulators"
        exit 1
    fi
    
    # Выбор первого доступного iPhone симулятора
    first_simulator=$(echo "$available_simulators" | head -n 1 | sed -E 's/.*\(([^)]+)\)/\1/')
    
    if [ -z "$first_simulator" ]; then
        echo "❌ Не удалось найти доступный симулятор"
        exit 1
    fi
    
    echo "📱 Запуск симулятора: $first_simulator"
    
    # Запуск симулятора
    xcrun simctl boot "$first_simulator" 2>/dev/null || true
    open -a Simulator
    
    echo "⏳ Ожидание запуска симулятора..."
    sleep 5
    
    # Ожидание готовности симулятора
    while ! xcrun simctl list devices | grep "$first_simulator" | grep -q "Booted"; do
        echo "⏳ Симулятор загружается..."
        sleep 3
    done
    
    echo "✅ Симулятор готов!"
}

# Проверка, есть ли уже запущенные iOS устройства
ios_devices=$(flutter devices | grep -E "(ios|iOS)" || true)

if [ -z "$ios_devices" ]; then
    echo "📱 iOS устройства не найдены, запускаем симулятор..."
    start_simulator
else
    echo "✅ iOS устройство уже доступно"
fi

echo "🔧 Сборка и запуск приложения..."
flutter run -d ios

echo "✅ Приложение запущено на iOS!" 
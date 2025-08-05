#!/bin/bash

# Скрипт для установки зависимостей Flutter проекта
# Использование: ./scripts/install_dependencies.sh

set -e  # Остановка при ошибке

echo "🚀 Установка зависимостей для Flutter проекта..."

# Проверка наличия Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter не найден. Установите Flutter: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "📋 Проверка версии Flutter..."
flutter --version

echo "🧹 Очистка кэша..."
flutter clean

echo "📦 Получение зависимостей..."
flutter pub get

echo "🔧 Генерация кода..."
flutter packages pub run build_runner build --delete-conflicting-outputs

echo "🎨 Генерация splash screen..."
flutter packages pub run flutter_native_splash:create

echo "✅ Зависимости успешно установлены!"
echo ""
echo "📱 Доступные устройства:"
flutter devices

echo ""
echo "🎯 Следующие шаги:"
echo "  - Для запуска на Android: ./scripts/run_android.sh"
echo "  - Для запуска на iOS: ./scripts/run_ios.sh" 
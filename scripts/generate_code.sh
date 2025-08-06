#!/bin/bash

# Скрипт для генерации кода с помощью build_runner

echo "🧹 Очистка предыдущих сгенерированных файлов..."
flutter clean

echo "📦 Получение зависимостей..."
flutter pub get

echo "🔨 Генерация кода с помощью build_runner..."
dart run build_runner build --delete-conflicting-outputs

echo "✅ Генерация кода завершена!"
echo "📁 Сгенерированные файлы:"
find . -name "*.freezed.dart" -o -name "*.g.dart" | head -10 
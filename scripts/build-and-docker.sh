#!/bin/bash
set -e

echo "🚀 Локальная сборка Flutter и создание Docker образа..."

# Генерация кода
echo "📝 Генерация кода..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Сборка Flutter web
echo "🔨 Сборка Flutter web..."
flutter build web --release

# Сборка Docker образа
echo "🐳 Сборка Docker образа..."
docker build -f Dockerfile.simple -t bukhindor-web:latest .

echo "✅ Сборка завершена!"
echo "🎉 Запуск контейнера:"
echo "   docker run -p 8080:80 bukhindor-web:latest" 
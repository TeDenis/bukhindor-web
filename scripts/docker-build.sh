#!/bin/bash
set -e

echo "🚀 Сборка и запуск Flutter web приложения в Docker..."
git pull
# Остановка существующего контейнера
echo "📦 Остановка существующего контейнера..."
docker-compose down

# Сборка нового образа
echo "🔨 Сборка Docker образа..."
docker-compose build --no-cache

# Запуск контейнера
echo "▶️  Запуск контейнера..."
docker-compose up -d

# Проверка статуса
echo "✅ Проверка статуса контейнера..."
docker-compose ps

echo "🎉 Приложение запущено на http://localhost:8080"
echo "📋 Логи: docker-compose logs -f"
echo "🛑 Остановка: docker-compose down" 
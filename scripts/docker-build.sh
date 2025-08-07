#!/bin/bash
set -e

echo "🚀 Сборка и запуск Flutter web приложения в Docker..."

# Остановка существующего контейнера
echo "📦 Остановка существующего контейнера..."
docker-compose down

# Сборка нового образа с улучшенными опциями
echo "🔨 Сборка Docker образа с улучшенными настройками..."
docker-compose build --no-cache --progress=plain

# Запуск контейнера
echo "▶️  Запуск контейнера..."
docker-compose up -d

# Проверка статуса
echo "✅ Проверка статуса контейнера..."
docker-compose ps

echo "🎉 Приложение запущено на http://localhost:8080"
echo "📋 Логи: docker-compose logs -f"
echo "🛑 Остановка: docker-compose down"
echo ""
echo "💡 Если возникли проблемы, попробуйте:"
echo "   ./scripts/docker-build-debug.sh" 
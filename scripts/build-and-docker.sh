#!/bin/bash
set -e

echo "🚀 Локальная сборка Flutter и создание Docker образа..."

# Генерация кода
echo "📝 Генерация кода..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Сборка Flutter web
echo "🔨 Сборка Flutter web..."

APP_VERSION=${APP_VERSION:-$(grep '^version:' pubspec.yaml | awk '{print $2}')}
BUILD_NUMBER=${BUILD_NUMBER:-1}
BUILD_DATE=${BUILD_DATE:-$(date -u +%Y-%m-%dT%H:%M:%SZ)}
BUILD_COMMIT=${BUILD_COMMIT:-$(git rev-parse --short HEAD 2>/dev/null || echo unknown)}
BUILD_BRANCH=${BUILD_BRANCH:-$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo main)}
ENVIRONMENT=${ENVIRONMENT:-production}
API_BASE_URL=${API_BASE_URL:-}

flutter build web --release \
  --dart-define=APP_VERSION=${APP_VERSION} \
  --dart-define=BUILD_NUMBER=${BUILD_NUMBER} \
  --dart-define=BUILD_DATE=${BUILD_DATE} \
  --dart-define=BUILD_COMMIT=${BUILD_COMMIT} \
  --dart-define=BUILD_BRANCH=${BUILD_BRANCH} \
  --dart-define=ENVIRONMENT=${ENVIRONMENT} \
  --dart-define=API_BASE_URL=${API_BASE_URL}

# Сборка Docker образа
echo "🐳 Сборка Docker образа..."
docker build -f Dockerfile \
  --build-arg APP_VERSION=${APP_VERSION} \
  --build-arg BUILD_NUMBER=${BUILD_NUMBER} \
  --build-arg BUILD_DATE=${BUILD_DATE} \
  --build-arg BUILD_COMMIT=${BUILD_COMMIT} \
  --build-arg BUILD_BRANCH=${BUILD_BRANCH} \
  --build-arg ENVIRONMENT=${ENVIRONMENT} \
  --build-arg API_BASE_URL=${API_BASE_URL} \
  -t bukhindor-web:latest .

echo "✅ Сборка завершена!"
echo "🎉 Запуск контейнера:"
echo "   docker run -p 8080:80 bukhindor-web:latest" 
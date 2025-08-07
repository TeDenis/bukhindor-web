#!/bin/bash
set -e

echo "🚀 CI/CD Deploy Script для Bukhindor Web"

# Функция логирования
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Проверка наличия Docker
if ! command -v docker &> /dev/null; then
    log "❌ Docker не установлен!"
    exit 1
fi

# Остановка существующих контейнеров
log "📦 Остановка существующих контейнеров..."
docker-compose down || true

# Выбор стратегии сборки
if [ "$1" = "optimized" ]; then
    log "🔧 Используем оптимизированный Dockerfile..."
    
    # Сборка с оптимизированным Dockerfile
    docker build \
        --no-cache \
        --progress=plain \
        -f Dockerfile.optimized \
        -t bukhindor-web:latest \
        .
    
    log "▶️  Запуск контейнера..."
    docker run -d -p 8080:80 --name bukhindor-web bukhindor-web:latest
    
elif [ "$1" = "local" ]; then
    log "🏠 Локальная сборка + простой Docker..."
    
    # Локальная сборка Flutter
    flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=false
    
    # Простой nginx контейнер
    docker run -d \
        -p 8080:80 \
        -v "$(pwd)/build/web:/usr/share/nginx/html:ro" \
        -v "$(pwd)/nginx.conf:/etc/nginx/nginx.conf:ro" \
        --name bukhindor-web \
        nginx:alpine
        
else
    log "🐳 Стандартная сборка через docker-compose..."
    docker-compose up --build -d
fi

# Проверка статуса
log "✅ Проверка статуса..."
sleep 5

if docker ps | grep -q bukhindor-web; then
    log "🎉 Приложение успешно запущено!"
    log "🌐 URL: http://localhost:8080"
    
    # Проверка доступности
    if curl -f http://localhost:8080 >/dev/null 2>&1; then
        log "✅ Сервис отвечает на запросы"
    else
        log "⚠️  Сервис запущен, но не отвечает (возможно, еще инициализируется)"
    fi
else
    log "❌ Ошибка запуска контейнера"
    log "📋 Логи:"
    docker logs bukhindor-web || true
    exit 1
fi

log "📋 Полезные команды:"
log "   Логи: docker logs -f bukhindor-web"
log "   Остановка: docker stop bukhindor-web && docker rm bukhindor-web"
log "   Статус: docker ps | grep bukhindor-web"
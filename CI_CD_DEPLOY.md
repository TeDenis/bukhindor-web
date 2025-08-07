# CI/CD Deployment Guide

## 🚨 Проблемы с текущей сборкой

Возможные проблемы и их решения:

### 1. "Operation was canceled"
- Долгая генерация кода (36+ секунд)
- Timeout в CI/CD системах
- Медленное клонирование Flutter репозитория

### 2. "SDK version solving failed"
- Несовместимость версий Dart SDK
- Проект требует Dart >=3.8.0, но старые версии Flutter содержат Dart 3.2.x
- **Решение**: Используем Flutter 3.24.5+ (содержит Dart 3.5.0+)

## ✅ Решения

### Вариант 1: Оптимизированная сборка (Рекомендуется)

```bash
# На сервере
git pull
./scripts/ci-deploy.sh optimized
```

**Преимущества:**
- Использует готовый Flutter образ `cirrusci/flutter:3.16.9`
- Пропускает генерацию кода (использует сгенерированные файлы из репозитория)
- Быстрая сборка (2-3 минуты вместо 10+)

### Вариант 2: Локальная сборка + Docker

```bash
# На сервере (требует установленный Flutter)
git pull
./scripts/ci-deploy.sh local
```

**Преимущества:**
- Самый быстрый способ
- Минимальный Docker образ
- Сборка Flutter вне контейнера

### Вариант 3: Стандартная сборка

```bash
# Только если первые два не работают
git pull
./scripts/ci-deploy.sh
```

## 🛠 Настройка CI/CD Pipeline

### GitHub Actions Example

```yaml
name: Deploy to Test Server

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - name: Deploy to server
      uses: appleboy/ssh-action@v1.2.2
      with:
        host: ${{ secrets.HOST }}
        username: ${{ secrets.USERNAME }}
        key: ${{ secrets.SSH_KEY }}
        script: |
          cd /path/to/bukhindor-web
          git pull
          ./scripts/ci-deploy.sh optimized
```

### Manual Deploy on Server

```bash
# Клонирование проекта (первый раз)
git clone https://github.com/TeDenis/bukhindor-web.git
cd bukhindor-web

# Обновление и деплой
git pull
./scripts/ci-deploy.sh optimized

# Проверка статуса
curl http://localhost:8080
docker ps | grep bukhindor-web
```

## 🔧 Отладка проблем

### Если сборка все еще падает

1. **Проверьте логи:**
```bash
docker logs bukhindor-web
docker-compose logs -f
```

2. **Очистите Docker кэш:**
```bash
docker system prune -a
./scripts/ci-deploy.sh optimized
```

3. **Используйте локальную сборку:**
```bash
./scripts/ci-deploy.sh local
```

### Общие проблемы

| Проблема | Решение |
|----------|---------|
| `Operation was canceled` | Используйте `optimized` вариант |
| `No space left on device` | `docker system prune -a` |
| `Port already in use` | `docker stop bukhindor-web` |
| `Flutter not found` | Используйте `optimized` вместо `local` |

## 📋 Требования к серверу

### Минимальные требования
- **RAM**: 2GB+ (рекомендуется 4GB)
- **Docker**: 20.10+
- **docker-compose**: 1.29+
- **Свободное место**: 2GB+

### Для локальной сборки (вариант 2)
- **Flutter SDK**: 3.16.9+
- **Dart SDK**: 3.0+

## 🎯 Результат

После успешного деплоя:
- **URL**: `http://server-ip:8080`
- **Проверка**: `curl http://localhost:8080`
- **Логи**: `docker logs -f bukhindor-web`

## 🆘 Поддержка

Если проблемы продолжаются:
1. Создайте issue с полными логами
2. Укажите версию Docker и ОС
3. Приложите вывод `docker system info`
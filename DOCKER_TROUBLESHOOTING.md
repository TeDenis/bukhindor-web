# Docker Troubleshooting Guide

## Проблема: Segmentation Fault в Flutter

Если вы видите ошибки типа:
```
===== CRASH =====
si_signo=Segmentation fault(11), si_code=1, si_addr=0x808080808080809f
```

### Решение 1: Использование обновленного Dockerfile

Основной Dockerfile был обновлен для решения проблемы:
- Обновлена версия Flutter до 3.16.9
- Добавлены дополнительные зависимости
- Улучшен процесс сборки

### Решение 2: Альтернативный Dockerfile

Если проблема сохраняется, используйте `Dockerfile.alternative`:

```bash
# Переименуйте файлы
mv Dockerfile Dockerfile.old
mv Dockerfile.alternative Dockerfile

# Пересоберите образ
./scripts/docker-build.sh
```

### Решение 3: Отладочная сборка

Используйте скрипт отладки для получения подробной информации:

```bash
./scripts/docker-build-debug.sh
```

### Решение 4: Очистка кэша

Полная очистка Docker кэша:

```bash
# Остановите все контейнеры
docker-compose down

# Удалите все образы
docker system prune -a

# Пересоберите
./scripts/docker-build.sh
```

### Решение 5: Использование локальной сборки

Если Docker продолжает вызывать проблемы, соберите локально:

```bash
# Установите Flutter локально
flutter build web --release

# Запустите через nginx
docker run -d -p 8080:80 -v $(pwd)/build/web:/usr/share/nginx/html nginx:alpine
```

## Частые проблемы

### 1. Недостаточно памяти
Увеличьте лимиты Docker:
- Docker Desktop: Settings → Resources → Memory (рекомендуется 4GB+)

### 2. Проблемы с сетью
```bash
# Очистите DNS кэш
docker system prune -f
```

### 3. Проблемы с правами доступа
```bash
# Проверьте права на файлы
chmod +x scripts/*.sh
```

## Логи и отладка

### Просмотр логов сборки
```bash
docker-compose logs -f
```

### Просмотр логов контейнера
```bash
docker logs bukhindor-web
```

### Интерактивная отладка
```bash
# Запустите контейнер в интерактивном режиме
docker run -it --rm bukhindor-web:latest /bin/sh
```

## Контакты

Если проблема не решается, создайте issue с:
1. Полным логом ошибки
2. Версией Docker
3. Операционной системой
4. Шагами для воспроизведения 
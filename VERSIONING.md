# Руководство по версионированию Bukhindor Web

## Обзор

Этот документ описывает процесс версионирования приложения Bukhindor Web и содержит инструкции по обновлению версий.

## Структура версионирования

### Семантическое версионирование (SemVer)

Мы используем семантическое версионирование в формате `MAJOR.MINOR.PATCH`:

- **MAJOR** - несовместимые изменения API
- **MINOR** - новая функциональность с обратной совместимостью
- **PATCH** - исправления ошибок с обратной совместимостью

### Примеры версий

```
1.0.0 - Первый стабильный релиз
1.0.1 - Исправление ошибок
1.1.0 - Новая функциональность
1.1.1 - Исправление ошибок
2.0.0 - Крупные изменения (несовместимые)
```

## Файлы для обновления

### 1. pubspec.yaml

```yaml
name: bukhindor_web
description: "A new Flutter project."
publish_to: 'none'
version: 1.0.0+1  # ← Обновить здесь
```

### 2. lib/core/constants/app_constants.dart

```dart
class AppConstants {
  // Version Info
  static const String appVersion = '1.0.0';        // ← Обновить
  static const String buildNumber = '1';           // ← Обновить
  static const String buildDate = '2024-12-19';    // ← Обновить
  static const String buildCommit = 'a1b2c3d';     // ← Обновить
  static const String buildBranch = 'main';        // ← Обновить
  
  // Release Info
  static const String releaseNotes = '''
🎉 Первый релиз Bukhindor!

✨ Новые возможности:
• Система аутентификации с анимированными карточками
• Красивые анимации жидкости с пузырьками
• Адаптивный дизайн для всех устройств
• Восстановление пароля
• Современный UI с градиентами

🔧 Технические улучшения:
• Clean Architecture с BLoC
• Flutter Web оптимизация
• Docker контейнеризация
• Responsive дизайн

🐛 Исправления:
• Плавные анимации без рывков
• Улучшенная производительность
• Оптимизированная навигация
''';  // ← Обновить заметки о релизе
}
```

## Процесс обновления версии

### Шаг 1: Подготовка

1. Убедитесь, что все изменения закоммичены
2. Создайте новую ветку для релиза: `git checkout -b release/v1.0.1`

### Шаг 2: Обновление версии

1. **Обновите pubspec.yaml:**
   ```bash
   # Для patch версии (1.0.0 → 1.0.1)
   sed -i '' 's/version: 1.0.0+1/version: 1.0.1+2/' pubspec.yaml
   
   # Для minor версии (1.0.0 → 1.1.0)
   sed -i '' 's/version: 1.0.0+1/version: 1.1.0+1/' pubspec.yaml
   
   # Для major версии (1.0.0 → 2.0.0)
   sed -i '' 's/version: 1.0.0+1/version: 2.0.0+1/' pubspec.yaml
   ```

2. **Обновите app_constants.dart:**
   ```dart
   // Обновите версию
   static const String appVersion = '1.0.1';
   
   // Обновите номер сборки
   static const String buildNumber = '2';
   
   // Обновите дату сборки
   static const String buildDate = '2024-12-20';
   
   // Обновите коммит (получите текущий хеш)
   static const String buildCommit = 'b2c3d4e';
   
   // Обновите заметки о релизе
   static const String releaseNotes = '''
🎉 Релиз 1.0.1

🐛 Исправления:
• Исправлена ошибка в анимации карточек
• Улучшена производительность на мобильных устройствах
• Исправлена валидация email

🔧 Технические улучшения:
• Оптимизирована загрузка шрифтов
• Улучшена обработка ошибок
''';
   ```

### Шаг 3: Получение информации о коммите

```bash
# Получить короткий хеш текущего коммита
git rev-parse --short HEAD

# Получить название текущей ветки
git branch --show-current

# Получить текущую дату в нужном формате
date +%Y-%m-%d
```

### Шаг 4: Тестирование

1. Запустите приложение: `flutter run -d chrome`
2. Проверьте страницу версии: перейдите на `/version`
3. Убедитесь, что все данные отображаются корректно

### Шаг 5: Коммит и тег

```bash
# Добавьте изменения
git add .

# Создайте коммит
git commit -m "chore: bump version to 1.0.1"

# Создайте тег
git tag -a v1.0.1 -m "Release version 1.0.1"

# Отправьте изменения
git push origin release/v1.0.1
git push origin v1.0.1
```

### Шаг 6: Создание релиза

1. Перейдите на GitHub в репозиторий
2. Создайте новый релиз на основе тега
3. Добавьте описание изменений
4. Прикрепите собранные файлы (если нужно)

## Автоматизация

### Скрипт для обновления версии

Создайте файл `scripts/bump_version.sh`:

```bash
#!/bin/bash

# Проверка аргументов
if [ $# -ne 1 ]; then
    echo "Использование: $0 <version>"
    echo "Пример: $0 1.0.1"
    exit 1
fi

NEW_VERSION=$1
CURRENT_DATE=$(date +%Y-%m-%d)
CURRENT_COMMIT=$(git rev-parse --short HEAD)
CURRENT_BRANCH=$(git branch --show-current)

echo "Обновление версии до $NEW_VERSION..."

# Обновление pubspec.yaml
sed -i '' "s/version: [0-9.]*+[0-9]*/version: $NEW_VERSION+1/" pubspec.yaml

# Обновление app_constants.dart
sed -i '' "s/static const String appVersion = '[0-9.]*';/static const String appVersion = '$NEW_VERSION';/" lib/core/constants/app_constants.dart
sed -i '' "s/static const String buildDate = '[0-9-]*';/static const String buildDate = '$CURRENT_DATE';/" lib/core/constants/app_constants.dart
sed -i '' "s/static const String buildCommit = '[a-f0-9]*';/static const String buildCommit = '$CURRENT_COMMIT';/" lib/core/constants/app_constants.dart
sed -i '' "s/static const String buildBranch = '[a-zA-Z0-9_-]*';/static const String buildBranch = '$CURRENT_BRANCH';/" lib/core/constants/app_constants.dart

echo "Версия обновлена до $NEW_VERSION"
echo "Дата: $CURRENT_DATE"
echo "Коммит: $CURRENT_COMMIT"
echo "Ветка: $CURRENT_BRANCH"
```

Сделайте скрипт исполняемым:
```bash
chmod +x scripts/bump_version.sh
```

Использование:
```bash
./scripts/bump_version.sh 1.0.1
```

## Проверка версии

### Через приложение

1. Запустите приложение
2. Перейдите на `/version`
3. Проверьте отображение всех данных о версии

### Через командную строку

```bash
# Проверить версию в pubspec.yaml
grep "version:" pubspec.yaml

# Проверить версию в константах
grep "appVersion" lib/core/constants/app_constants.dart
```

## Рекомендации

### Для patch версий (1.0.0 → 1.0.1)
- Исправления ошибок
- Улучшения производительности
- Обновления зависимостей

### Для minor версий (1.0.0 → 1.1.0)
- Новая функциональность
- Улучшения UI/UX
- Новые компоненты

### Для major версий (1.0.0 → 2.0.0)
- Крупные изменения архитектуры
- Несовместимые изменения API
- Полная переработка функциональности

## История версий

| Версия | Дата | Описание |
|--------|------|----------|
| 1.0.0 | 2024-12-19 | Первый релиз с системой аутентификации |
| 1.0.1 | 2024-12-20 | Исправления и улучшения |

## Полезные команды

```bash
# Получить текущую версию
grep "version:" pubspec.yaml

# Получить хеш коммита
git rev-parse --short HEAD

# Получить название ветки
git branch --show-current

# Создать тег
git tag -a v1.0.1 -m "Release version 1.0.1"

# Отправить тег
git push origin v1.0.1

# Удалить тег (если нужно)
git tag -d v1.0.1
git push origin :refs/tags/v1.0.1
``` 
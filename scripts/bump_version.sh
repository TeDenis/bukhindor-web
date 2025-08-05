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
echo "Дата: $CURRENT_DATE"
echo "Коммит: $CURRENT_COMMIT"
echo "Ветка: $CURRENT_BRANCH"
echo ""

# Обновление pubspec.yaml
echo "Обновление pubspec.yaml..."
sed -i '' "s/version: [0-9.]*+[0-9]*/version: $NEW_VERSION+1/" pubspec.yaml

# Обновление app_constants.dart
echo "Обновление app_constants.dart..."
sed -i '' "s/static const String appVersion = '[0-9.]*';/static const String appVersion = '$NEW_VERSION';/" lib/core/constants/app_constants.dart
sed -i '' "s/static const String buildDate = '[0-9-]*';/static const String buildDate = '$CURRENT_DATE';/" lib/core/constants/app_constants.dart
sed -i '' "s/static const String buildCommit = '[a-f0-9]*';/static const String buildCommit = '$CURRENT_COMMIT';/" lib/core/constants/app_constants.dart
sed -i '' "s/static const String buildBranch = '[a-zA-Z0-9_-]*';/static const String buildBranch = '$CURRENT_BRANCH';/" lib/core/constants/app_constants.dart

echo ""
echo "✅ Версия успешно обновлена до $NEW_VERSION"
echo ""
echo "Следующие шаги:"
echo "1. Проверьте изменения: git diff"
echo "2. Добавьте изменения: git add ."
echo "3. Создайте коммит: git commit -m \"chore: bump version to $NEW_VERSION\""
echo "4. Создайте тег: git tag -a v$NEW_VERSION -m \"Release version $NEW_VERSION\""
echo "5. Отправьте изменения: git push origin $CURRENT_BRANCH && git push origin v$NEW_VERSION" 
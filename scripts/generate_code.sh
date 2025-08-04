#!/bin/bash

# Скрипт для генерации кода с помощью build_runner
# Использование: ./scripts/generate_code.sh

echo "🚀 Генерация кода с помощью build_runner..."

# Очистка предыдущих сгенерированных файлов
echo "🧹 Очистка предыдущих файлов..."
flutter packages pub run build_runner clean

# Генерация кода
echo "⚙️ Генерация нового кода..."
flutter packages pub run build_runner build --delete-conflicting-outputs

echo "✅ Генерация кода завершена!"
echo ""
echo "📝 Сгенерированные файлы:"
echo "- *.freezed.dart - Freezed классы"
echo "- *.g.dart - JSON сериализация"
echo "- *.mocks.dart - Mock классы (если используется mockito)" 
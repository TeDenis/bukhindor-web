# Bukhindor Web

Flutter веб-приложение с системой авторизации, современными анимациями и Docker поддержкой.

## 🚀 Возможности

- ✅ **Аутентификация**: Вход и регистрация с валидацией форм
- ✅ **Современный UI**: Material Design 3 с liquid glass эффектами 
- ✅ **Анимации**: Beer animation на splash, owl logo, плавные переходы
- ✅ **Адаптивный дизайн**: Работает на всех размерах экранов
- ✅ **Темы**: Поддержка светлой и темной темы
- ✅ **Архитектура**: Clean Architecture с BLoC pattern
- ✅ **Docker**: Готовая конфигурация для продакшена
- ✅ **Навигация**: GoRouter с защищенными маршрутами

## 📋 Требования

- Flutter SDK 3.2.3 или выше
- Dart SDK 3.0.0 или выше
- Docker (для продакшена)

## 🛠️ Быстрый старт

### Разработка
```bash
# Клонирование и установка
git clone <repository-url>
cd bukhindor-web
flutter pub get

# Генерация кода (если изменяли модели)
./scripts/generate_code.sh

# Запуск
flutter run -d chrome
```

### Продакшен (Docker)
```bash
# Автоматическая сборка и запуск
./scripts/docker-build.sh

# Или вручную
docker-compose up --build

# Приложение доступно на http://localhost:8080
```

### Генерация кода
```bash
# Автоматическая генерация всех файлов
./scripts/generate_code.sh

# Или вручную
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

## 📁 Архитектура

### Структура проекта
```
lib/
├── core/                           # Общие компоненты
│   ├── config/                     # Конфигурация приложения
│   ├── constants/                  # Константы
│   ├── router/                     # Навигация
│   ├── theme/                      # Темы
│   ├── utils/                      # Утилиты и анимации
│   └── widgets/                    # Переиспользуемые виджеты
├── features/                       # Модули по функциональности
│   ├── auth/                       # Аутентификация
│   │   ├── data/repositories/      # Источники данных
│   │   ├── domain/entities/        # Бизнес-модели
│   │   └── presentation/           # UI компоненты
│   ├── home/                       # Главная страница
│   └── splash/                     # Загрузочный экран
└── main.dart                       # Точка входа
```

### Ключевые паттерны
- **Clean Architecture**: Разделение на presentation, domain, data слои
- **BLoC Pattern**: Управление состоянием приложения
- **Repository Pattern**: Абстракция доступа к данным
- **Dependency Injection**: Через Provider

## 🎨 UI/UX Особенности

### Анимации
- **Splash Screen**: Анимация пивной пены с owl logo
- **Liquid Glass**: Эффекты стеклянных контейнеров
- **Page Transitions**: Плавные переходы между экранами
- **Loading States**: Анимированные состояния загрузки

### Дизайн система
- **Шрифт**: Comfortaa (300-700 weights)
- **Цвета**: Material Design 3 палитра
- **Компоненты**: Кастомные AuthTextField, AuthButton
- **Адаптивность**: Responsive layout для всех экранов

## 🔧 Технологии

### Frontend
- **Flutter 3.2.3+**: UI фреймворк
- **Dart 3.0.0+**: Язык программирования
- **Material Design 3**: Дизайн система

### State Management
- **flutter_bloc**: BLoC/Cubit паттерн
- **freezed**: Immutable data classes
- **flutter_hooks**: React-style hooks

### Дополнительно
- **go_router**: Декларативная навигация
- **flutter_svg**: SVG поддержка
- **cached_network_image**: Кэширование изображений

### Docker & Production
- **nginx:alpine**: Web server
- **Multi-stage build**: Оптимизированная сборка
- **CSP policies**: Безопасность для WebAssembly
- **Gzip compression**: Сжатие статических файлов

## 🚀 Deployment

### Docker конфигурация
```yaml
# docker-compose.yml
services:
  bukhindor-web:
    build: .
    ports:
      - "8080:5000"
    restart: unless-stopped
```

### Nginx особенности
- Поддержка Flutter web роутинга
- CSP политики для CanvasKit WebAssembly
- Кэширование статических файлов
- Gzip сжатие

### Команды
```bash
# Сборка
docker-compose build --no-cache

# Запуск
docker-compose up -d

# Логи
docker-compose logs -f

# Остановка
docker-compose down
```

## 📊 Memory Bank

Подробная документация проекта находится в папке `memory-bank/`:

- **projectbrief.md**: Цели и требования проекта
- **productContext.md**: Пользовательские проблемы и решения
- **systemPatterns.md**: Архитектурные паттерны
- **techContext.md**: Технический стек и зависимости
- **activeContext.md**: Текущее состояние и фокус
- **progress.md**: Статус разработки

## 🎯 Текущий статус

### ✅ Готово
- [x] Полная архитектура приложения
- [x] Система аутентификации с mock данными
- [x] Все анимации и UI компоненты
- [x] Docker конфигурация для продакшена
- [x] Адаптивный дизайн
- [x] Навигация и роутинг

### 🔄 В разработке
- [ ] Firebase интеграция
- [ ] Unit и widget тесты
- [ ] Performance оптимизация

### 📋 Планируется
- [ ] Социальная авторизация
- [ ] Профиль пользователя
- [ ] Уведомления
- [ ] Analytics интеграция

## 🤝 Разработка

### Команды разработчика
```bash
# Генерация кода
./scripts/generate_code.sh

# Линтинг
flutter analyze

# Форматирование
dart format .

# Тесты
flutter test
```

### Добавление новых features
1. Создать папку в `lib/features/`
2. Следовать структуре: data/domain/presentation
3. Добавить routes в `app_router.dart`
4. Зарегистрировать BLoC в `main.dart`

## 📞 Поддержка

- **Issues**: Создавайте issues в репозитории
- **Documentation**: См. папку `memory-bank/`
- **Examples**: Изучайте существующий код

---

**Создано с ❤️ используя Flutter, BLoC и Docker**
# Technical Context: Bukhindor Web

## Технологический стек

### Frontend Framework
- **Flutter 3.2.3+**: UI фреймворк
- **Dart 3.0.0+**: Язык программирования
- **Material Design 3**: Дизайн система

### State Management
- **flutter_bloc ^8.1.3**: BLoC/Cubit паттерн
- **freezed_annotation ^2.4.1**: Immutable classes
- **flutter_hooks ^0.20.3**: React-style hooks

### Navigation & Routing
- **go_router ^12.1.3**: Декларативная навигация

### UI & Assets
- **flutter_svg ^2.0.9**: SVG support
- **cached_network_image ^3.3.0**: Image caching
- **Comfortaa Font**: Кастомный шрифт (300-700 weights)

### Development Tools
- **build_runner ^2.4.7**: Code generation
- **freezed ^2.4.6**: Data class generation
- **json_serializable ^6.7.1**: JSON serialization
- **flutter_lints ^3.0.0**: Code analysis

### Native Features
- **flutter_native_splash ^2.3.7**: Native splash screen

### Docker & Deployment
- **nginx:alpine**: Web server для продакшена
- **dart:stable**: Build container
- **docker-compose**: Оркестрация

## Структура зависимостей

### Core Dependencies
```yaml
dependencies:
  flutter: sdk
  flutter_bloc: ^8.1.3
  go_router: ^12.1.3
  flutter_hooks: ^0.20.3
```

### Dev Dependencies
```yaml
dev_dependencies:
  flutter_test: sdk
  build_runner: ^2.4.7
  freezed: ^2.4.6
  flutter_native_splash: ^2.3.7
```

## Конфигурация среды

### Development
- `flutter run -d chrome`: Локальная разработка
- Hot reload & hot restart support
- Debug режим с подробными ошибками

### Production
- `flutter build web --release`: Продакшен сборка
- Docker контейнер с nginx
- Порт 5000 (внешний 8080)
- Gzip compression
- Static file caching

### Build Configuration
- **Target**: Web only
- **Renderer**: HTML (по умолчанию)
- **Web resources**: Оптимизированы для production

## Technical Constraints
- Только веб-платформа
- Без Firebase интеграции (mock data)
- CSP policy для WebAssembly support
- Modern browser requirements
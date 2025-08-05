# System Patterns: Bukhindor Web

## Архитектурные решения

### Clean Architecture
```
Presentation Layer (UI) → Business Logic (BLoC) → Data Layer (Repositories)
```

### Структура модулей
- **core/**: Общие компоненты, конфигурация, утилиты
- **features/**: Модули по функциональности (auth, home, splash)
- Каждый feature имеет: data/, domain/, presentation/

### Паттерны управления состоянием
- **BLoC Pattern**: Для complex state management
- **Simple BLoC**: Для auth без domain layer
- **Provider**: Для dependency injection

## Ключевые технические решения

### Анимации
- **AnimationController**: Для complex animations
- **Tween**: Для smooth transitions
- **AnimationUtils**: Централизованные анимации
- **Стандартные тайминги**: 300ms, 600ms, 1200ms
- **КРИТИЧЕСКОЕ ПРАВИЛО**: Непрерывное время для бесконечных анимаций
- **Волны**: `DateTime.now().millisecondsSinceEpoch / 1000.0 * waveSpeed * 2 * pi`
- **Пузырьки**: Хаотичное появление, лопание на 5% высоты экрана

### Навигация
- **GoRouter**: Декларативная навигация
- **App Router**: Централизованная конфигурация маршрутов
- **Auth Guard**: Защита маршрутов

### UI Компоненты
- **LiquidGlassContainer**: Кастомный container с эффектами
- **BackgroundAnimation**: Анимированный фон
- **AuthTextField**: Валидируемые поля ввода
- **AuthButton**: Кнопки с loading состояниями

### Конфигурация
- **AppTheme**: Централизованные темы
- **AppConstants**: Константы приложения
- **AnimationConfig**: Настройки анимаций

## Компонентные взаимодействия

### Auth Flow
```
LoginPage → AuthBloc → AuthRepository → Mock Data
     ↓
HomePage ← Router ← AuthState ← AuthBloc
```

### Animation System
```
AnimationUtils → Controllers → Widgets → UI Effects
```

### Theme System
```
AppTheme → MaterialApp → Pages → Consistent Styling
```

## ОБЯЗАТЕЛЬНЫЕ УСЛОВИЯ ДЛЯ АНИМАЦИЙ

### Бесконечная волна (ОБЯЗАТЕЛЬНО)
```dart
// ПРАВИЛЬНО - никаких циклов:
final currentTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
final waveSpeed = 0.5;
final offset = currentTime * waveSpeed * 2 * pi;

// НЕПРАВИЛЬНО - создает рывки:
final offset = animation * 2 * pi; // animation.value от 0 до 1
```

### Хаотичные пузырьки (ОБЯЗАТЕЛЬНО)
```dart
// Параметры пузырьков:
size: 4.0 + _random.nextDouble() * 6.0, // 4-10px
opacity: 0.7 + _random.nextDouble() * 0.3, // 0.7-1.0
x: 20.0 + _random.nextDouble() * (screenWidth - 40.0), // вся ширина
popHeight: size.height * 0.05, // лопание на 5% от верха
```

### Удаление пузырьков (ОБЯЗАТЕЛЬНО)
```dart
// Удаляем после лопания:
return bubble.y < -50 || (bubble.y <= popHeight && popProgress >= 2 * pi);
```
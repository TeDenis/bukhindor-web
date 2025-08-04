# Используем официальный образ Flutter для сборки
FROM dart:stable AS build

# Устанавливаем Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:$PATH"

# Копируем pubspec файлы
COPY pubspec.* ./

# Получаем зависимости
RUN flutter pub get

# Копируем исходный код
COPY . .

# Собираем web приложение для продакшена
RUN flutter build web --release --web-renderer html

# Используем nginx для раздачи статических файлов
FROM nginx:alpine

# Копируем собранные файлы из предыдущего этапа
COPY --from=build /build/web /usr/share/nginx/html

# Копируем конфигурацию nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Открываем порт 5000
EXPOSE 5000

# Запускаем nginx
CMD ["nginx", "-g", "daemon off;"] 
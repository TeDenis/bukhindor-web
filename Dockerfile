# Используем официальный образ Flutter для сборки
FROM dart:stable AS build

# Устанавливаем Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:$PATH"

# Создаем пользователя для Flutter
RUN useradd -m -s /bin/bash flutter
RUN chown -R flutter:flutter /flutter

# Создаем рабочую директорию
WORKDIR /app
RUN chown -R flutter:flutter /app

# Копируем pubspec файлы
COPY --chown=flutter:flutter pubspec.* ./

# Получаем зависимости
USER flutter
RUN flutter pub get

# Копируем исходный код (после получения зависимостей для лучшего кэширования)
COPY --chown=flutter:flutter . .

# Принудительно обновляем зависимости и собираем web приложение для продакшена
RUN flutter clean && flutter pub get && flutter build web --release

# Используем nginx для раздачи статических файлов
FROM nginx:alpine

# Копируем собранные файлы из предыдущего этапа
COPY --from=build /app/build/web /usr/share/nginx/html

# Копируем конфигурацию nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Открываем порт 5000
EXPOSE 5000

# Запускаем nginx
CMD ["nginx", "-g", "daemon off;"]
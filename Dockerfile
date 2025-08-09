# Use official Flutter image for more stable builds
FROM dart:stable AS build-env

# Install Flutter (stable channel)
RUN git clone -b stable https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/.pub-cache/bin:${PATH}"

# Pre-download Flutter artifacts
RUN flutter --version && flutter precache --web

# Set working directory
WORKDIR /app

# Copy pubspec files first for better caching
COPY pubspec.* ./

# Get dependencies
RUN flutter pub get

# Copy source code
COPY . .

# Ensure deps resolved for the full project context (harmless if unchanged)
RUN flutter pub get

# Generate code
RUN dart run build_runner build --delete-conflicting-outputs

# Build web app with compile-time defines (can be overridden at build time)
ARG APP_VERSION=1.0.2
ARG BUILD_NUMBER=1
ARG BUILD_DATE
ARG BUILD_COMMIT
ARG BUILD_BRANCH=main
ARG ENVIRONMENT=production
ARG API_BASE_URL=

RUN flutter build web --release \
  --dart-define=APP_VERSION=${APP_VERSION} \
  --dart-define=BUILD_NUMBER=${BUILD_NUMBER} \
  --dart-define=BUILD_DATE=${BUILD_DATE} \
  --dart-define=BUILD_COMMIT=${BUILD_COMMIT} \
  --dart-define=BUILD_BRANCH=${BUILD_BRANCH} \
  --dart-define=ENVIRONMENT=${ENVIRONMENT} \
  --dart-define=API_BASE_URL=${API_BASE_URL}

# Use nginx to serve the app
FROM nginx:1.25.2-alpine

# Copy built app
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Ensure PWA manifest and custom loading icon are present (Flutter may not copy custom files in web/)
RUN mkdir -p /usr/share/nginx/html/icons
COPY web/manifest.json /usr/share/nginx/html/manifest.json
COPY web/icons/load.svg /usr/share/nginx/html/icons/load.svg

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"] 
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

# Build web app
RUN flutter build web --release

# Use nginx to serve the app
FROM nginx:1.25.2-alpine

# Copy built app
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"] 
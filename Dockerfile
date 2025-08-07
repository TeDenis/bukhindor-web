# Use official Flutter image for more stable builds
FROM dart:stable AS build-env

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:${PATH}"

# Pre-download Flutter artifacts
RUN flutter precache --web

# Set working directory
WORKDIR /app

# Copy pubspec file first for better caching
COPY pubspec.yaml ./

# Get dependencies
RUN flutter pub get

# Copy source code
COPY . .

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
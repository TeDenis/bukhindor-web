# Stage 1: Build the Flutter web application
FROM ubuntu:latest AS build-env

# Install dependencies for Flutter build
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    libglu1-mesa \
    fonts-droid-fallback \
    lib32stdc++6 \
    python3

# Clone Flutter SDK and set up environment
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable Flutter web support and build the application
WORKDIR /app
COPY . /app/
RUN flutter config --enable-web
RUN flutter build web --release

# Stage 2: Serve the built application with Nginx
FROM nginx:alpine

# Copy the built Flutter web assets from the build stage
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Expose port 80 for web traffic
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

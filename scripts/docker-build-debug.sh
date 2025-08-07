#!/bin/bash

# Docker build script with debug options
set -e

echo "Building Docker image with debug options..."

# Build with no cache and progress output
docker build \
    --no-cache \
    --progress=plain \
    --build-arg FLUTTER_VERSION=3.16.9 \
    -t bukhindor-web:latest \
    .

echo "Build completed successfully!"
echo "To run the container:"
echo "docker run -p 8080:80 bukhindor-web:latest" 
#!/bin/bash

# Build and Push GLITCH Docker Image to Docker Hub
set -e

# Configuration
DOCKERHUB_USERNAME="jahidularafat"
IMAGE_NAME="glitch"
TAG=${1:-"latest"}
FULL_IMAGE_NAME="${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${TAG}"

echo "🚀 Building and pushing GLITCH Docker image..."
echo "📦 Image: ${FULL_IMAGE_NAME}"

# Ensure we're in the correct directory
if [ ! -f "pyproject.toml" ]; then
    echo "❌ Error: pyproject.toml not found. Please run this script from the GLITCH directory."
    exit 1
fi

# Build the Docker image
echo "🔨 Building Docker image (this may take a few minutes)..."
docker build -t ${FULL_IMAGE_NAME} .

# Tag with additional versions
if [ "$TAG" != "latest" ]; then
    docker tag ${FULL_IMAGE_NAME} ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest
    echo "🏷️  Tagged as latest"
fi

# Tag with v1.0.1
docker tag ${FULL_IMAGE_NAME} ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:v1.0.1
echo "🏷️  Tagged as v1.0.1"

echo "✅ Image built successfully!"

# Test the image
echo "🧪 Testing the Docker image..."
if docker run --rm ${FULL_IMAGE_NAME} --help > /dev/null 2>&1; then
    echo "✅ Docker image test passed!"
else
    echo "❌ Docker image test failed!"
    exit 1
fi

# Login to Docker Hub (you should already be logged in)
echo "🔐 Checking Docker Hub login..."
docker info | grep Username || docker login

# Push the images
echo "⬆️  Pushing images to Docker Hub..."
docker push ${FULL_IMAGE_NAME}

if [ "$TAG" != "latest" ]; then
    docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest
fi

docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:v1.0.1

echo ""
echo "🎉 Successfully pushed to Docker Hub!"
echo "📋 Available images:"
echo "   - docker pull ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest"
echo "   - docker pull ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:v1.0.1"
if [ "$TAG" != "latest" ]; then
    echo "   - docker pull ${FULL_IMAGE_NAME}"
fi

echo ""
echo "💡 Usage examples:"
echo "   docker run --rm ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest --help"
echo "   docker run --rm -v \$(pwd):/workspace ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest --tech ansible --csv /workspace"

# Clean up build artifacts
echo "🧹 Cleaning up..."
docker system prune -f
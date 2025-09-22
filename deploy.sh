#!/bin/bash

# Build and Deploy GLITCH Docker Image
# Usage: ./build-deploy.sh [your-dockerhub-username] [tag]

set -e

# Configuration
DOCKERHUB_USERNAME=${1:-"your-dockerhub-username"}
IMAGE_NAME="glitch"
TAG=${2:-"latest"}
FULL_IMAGE_NAME="${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${TAG}"

echo "Building GLITCH Docker image..."
echo "Image: ${FULL_IMAGE_NAME}"

# Check if requirements.txt exists, if not create it
if [ ! -f "requirements.txt" ]; then
    echo "Creating requirements.txt..."
    cat > requirements.txt << EOF
# GLITCH Dependencies - Compatible versions
numpy==1.24.3
pandas==2.0.3
setuptools>=65.0.0
wheel>=0.38.0
PyYAML>=6.0
tqdm>=4.64.0
pytest>=7.0.0
black>=22.0.0
EOF
fi

# Build the Docker image with no cache to ensure fresh build
echo "Building Docker image (this may take a few minutes)..."
docker build --no-cache -t ${FULL_IMAGE_NAME} .

# Tag with additional version if specified
if [ "$TAG" != "latest" ]; then
    docker tag ${FULL_IMAGE_NAME} ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest
fi

echo "Image built successfully!"

# Test the image
echo "Testing the Docker image..."
if docker run --rm ${FULL_IMAGE_NAME} --help > /dev/null 2>&1; then
    echo "✅ Docker image test passed!"
else
    echo "❌ Docker image test failed!"
    exit 1
fi

# Ask for confirmation before pushing
read -p "Do you want to push the image to Docker Hub? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Logging in to Docker Hub..."
    docker login

    echo "Pushing image to Docker Hub..."
    docker push ${FULL_IMAGE_NAME}

    if [ "$TAG" != "latest" ]; then
        docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest
    fi

    echo "✅ Image pushed successfully!"
    echo "You can now pull it using: docker pull ${FULL_IMAGE_NAME}"
else
    echo "Image not pushed. You can push it later using:"
    echo "docker push ${FULL_IMAGE_NAME}"
fi

echo ""
echo "Usage examples:"
echo "docker run --rm ${FULL_IMAGE_NAME} --help"
echo "docker run --rm -v \$(pwd):/workspace ${FULL_IMAGE_NAME} --tech ansible --csv /workspace"

# Clean up build artifacts
echo "Cleaning up..."
docker system prune -f
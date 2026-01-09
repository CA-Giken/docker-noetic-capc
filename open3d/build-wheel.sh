#!/bin/bash
set -e

echo "=========================================="
echo "Building Open3D 0.13.0 wheel for ARM64"
echo "=========================================="

# Create output directory
mkdir -p ./wheels

# Build the image
echo "Building Docker image..."
docker buildx build \
    --platform linux/arm64 \
    -f Dockerfile \
    -t open3d-builder:arm64 \
    --load \
    .

# Run container and extract wheel
echo "Extracting wheel file..."
CONTAINER_ID=$(docker create --platform linux/arm64 open3d-builder:arm64)
docker cp ${CONTAINER_ID}:/output/. ./wheels/
docker rm ${CONTAINER_ID}

echo ""
echo "=========================================="
echo "Build complete!"
echo "=========================================="
echo "Wheel file location:"
ls -lh ./wheels/*.whl
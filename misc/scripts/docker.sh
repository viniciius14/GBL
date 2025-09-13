#!/bin/bash
set -e

IMAGE_NAME="gecko_image"
CONTAINER_NAME="gecko_container"

DOCKERFILE_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")/../docker")"
DOCKERFILE="$DOCKERFILE_DIR/Dockerfile"

PROJECT_ROOT="$(realpath "$DOCKERFILE_DIR/../..")"
IMAGE_EXISTS=$(docker image inspect "$IMAGE_NAME" >/dev/null 2>&1 && echo yes || echo no)


# X11 socket sharing
XSOCK="/tmp/.X11-unix"
XAUTH="$HOME/.Xauthority"

# Print info
echo ""
echo "=================================================================="
echo " SETTING UP DOCKER ENVIRONMENT AND TOOLS TO BUILD THE BOOTLOADER  "
echo "=================================================================="
echo "IMAGE NAME           ======>  $IMAGE_NAME"
echo "CONTAINER NAME       ======>  $CONTAINER_NAME"
echo "DOCKER DIR           ======>  $DOCKERFILE_DIR"
echo "PROJECT ROOT         ======>  $PROJECT_ROOT"
echo "=================================================================="

if ! command -v docker &> /dev/null; then
    echo "Docker is not installed."
    echo "Please install Docker before proceeding."
    echo "https://docs.docker.com/get-docker/"
    return
fi

# Allow X11 access for Docker
xhost +local:docker > /dev/null

# Build and run the image
docker build -f "$DOCKERFILE" -t $IMAGE_NAME "$PROJECT_ROOT"

docker run -it --rm \
    --name $CONTAINER_NAME \
    -e DISPLAY=$DISPLAY \
    -v $XSOCK:$XSOCK \
    -v $XAUTH:$XAUTH \
    -e XAUTHORITY=$XAUTH \
    --device /dev/kvm \
    --cap-add=NET_ADMIN \
    --security-opt seccomp=unconfined \
    --privileged \
    -v "$PROJECT_ROOT":/GBL \
    $IMAGE_NAME

#!/bin/bash

IMAGE_NAME="gecko_image"
CONTAINER_NAME="gecko_container"

DOCKERFILE_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")/../docker")"
DOCKERFILE="$DOCKERFILE_DIR/Dockerfile"

PROJECT_ROOT="$(realpath "$DOCKERFILE_DIR/../..")"

IMAGE_EXISTS=$(docker image inspect "$IMAGE_NAME" >/dev/null 2>&1 && echo yes || echo no)
IMAGE_TIME=$(docker image inspect "$IMAGE_NAME" -f '{{.Created}}' 2>/dev/null | xargs -I{} date -d {} +%s || echo 0)
FILE_TIME=$(date -r "$DOCKERFILE" +%s)

DOCKER_ROOT="/home"

# X11 socket sharing
XSOCK="/tmp/.X11-unix"
XAUTH="$HOME/.Xauthority"

# Print info
echo ""
echo "=================================================================="
echo "   SETTING UP DOCKER ENVIROMENT AND TOOLS TO BUILD THE BOOTLOADER   "
echo "=================================================================="
echo "IMAGE NAME           ======>  $IMAGE_NAME"
echo "CONTAINER NAME       ======>  $CONTAINER_NAME"
echo "DOCKER DIR           ======>  $DOCKERFILE_DIR"
echo "PROJECT ROOT         ======>  $PROJECT_ROOT"
echo "IMAGE TIME           ======>  $(date -d "@$IMAGE_TIME" "+%Y-%m-%d %H:%M:%S")"
echo "FILE TIME            ======>  $(date -d "@$FILE_TIME" "+%Y-%m-%d %H:%M:%S")"
echo "DOCKER PROJECT DIR   ======>  $DOCKER_ROOT"
echo "=================================================================="
echo ""

# Docker instalation stuff
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed."
    echo "Please install Docker before proceeding."
    echo "https://docs.docker.com/get-docker/"
    return
fi

# Allow X11 access for Docker
xhost +local:docker > /dev/null

# Build image
if [[ "$IMAGE_EXISTS" == "no" || "$FILE_TIME" -gt "$IMAGE_TIME" ]]; then
    SPACER_SZ=68
    change='CHANGE DETECTED! REBUILDING '$IMAGE_NAME'...'
    printf "%$(((SPACER_SZ-${#change})/2))s%s\n" "" "$change"
    echo "=================================================================="
    echo ""
    echo "If it's the first time you're running this it'll take a bit!"
    echo ""
    docker build -t $IMAGE_NAME "$DOCKERFILE_DIR"

else
    echo "IMAGE '$IMAGE_NAME' IS UP TO DATE."
    echo "=================================================================="
fi

docker run -it --rm \
    --name $CONTAINER_NAME \
    -e DISPLAY=$DISPLAY \
    -v $XSOCK:$XSOCK \
    -v $XAUTH:$XAUTH \
    -e XAUTHORITY=$XAUTH \
    -v "$PROJECT_ROOT":$DOCKER_ROOT \
    --device /dev/kvm \
    --cap-add=NET_ADMIN \
    --security-opt seccomp=unconfined \
    --privileged \
    $IMAGE_NAME

#!/bin/bash
# A script to build and run the Gecko development environment in Docker.
set -euo pipefail

## ----------------- CONFIGURATION ----------------- ##
readonly IMAGE_NAME="gecko_image"
readonly CONTAINER_NAME="gecko_container"
readonly DOCKER_PROJECT_ROOT="/home" # Project mount point inside the container

## ----------------- SCRIPT CONSTANTS ----------------- ##
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
readonly PROJECT_ROOT="$(realpath "$SCRIPT_DIR/../..")"
readonly DOCKERFILE_DIR="$PROJECT_ROOT/misc/docker"

## ----------------- FUNCTIONS ----------------- ##

# Prints how to use the script.
usage() {
    cat <<EOF
Usage: $(basename "$0") --gui [x11|vnc|auto]

Manages the Docker build and run process for the project.

Options:
  --gui <mode>  Specify the GUI mode.
                - x11:  Forwards the host's X11 socket.
                - vnc:  Uses a VNC server within the container.
  -h, --help    Show this help message.
EOF
                # - auto: (Future) Automatically detects if X11 is available, otherwise falls back. # TODO
    exit 1
}

# Checks for required dependencies like Docker.
check_dependencies() {
    if ! command -v docker &>/dev/null; then
        echo "Error: Docker is not installed."
        echo "Installation guide: https://docs.docker.com/engine/install/"
        exit 1
    fi
}

# TODO
resolve_gui_mode() {
    local gui_choice="$1"
    echo "$gui_choice"
}

build_image_if_needed() {
    local image_name="$1"
    local dockerfile_path="$2"

    local image_exists
    image_exists=$(docker image inspect "$image_name" >/dev/null 2>&1 && echo "yes" || echo "no")

    local file_time
    file_time=$(date -r "$dockerfile_path" +%s)

    local image_time=0
    if [[ "$image_exists" == "yes" ]]; then
        image_time=$(docker image inspect "$image_name" -f '{{.Created}}' | xargs -I{} date -d {} +%s)
    fi

    echo ""
    echo "=================================================================="
    echo "   SETTING UP DOCKER ENVIROMENT AND TOOLS TO BUILD THE SOFTWARE   "
    echo "=================================================================="
    echo "IMAGE NAME           ======>  $IMAGE_NAME"
    echo "CONTAINER NAME       ======>  $CONTAINER_NAME"
    echo "DOCKER DIR           ======>  $DOCKERFILE_DIR"
    echo "PROJECT ROOT         ======>  $PROJECT_ROOT"
    echo "=================================================================="

    if [[ "$image_exists" == "no" || "$file_time" -gt "$image_time" ]]; then
        echo "Change detected or image not found. Rebuilding..."
        docker build -t "$image_name" --file "$dockerfile_path" "$DOCKERFILE_DIR"
        echo "Build complete."
    else
        echo "Image is up to date."
    fi
    echo "=================================================================="
}

# Runs the container with the appropriate settings for the chosen GUI mode.
run_container() {
    local gui_mode="$1"

    # Common options for all run commands
    local docker_run_opts=(
        -it --rm
        --name "$CONTAINER_NAME"
        -v "$PROJECT_ROOT:$DOCKER_PROJECT_ROOT"
        --device /dev/kvm
        --cap-add=NET_ADMIN
        --security-opt seccomp=unconfined
        --privileged
    )

    echo "Starting container with $gui_mode support..."

    case "$gui_mode" in
        "x11")
            # Prepare X11 forwarding
            local xsock="/tmp/.X11-unix"
            local xauth="$HOME/.Xauthority"
            touch "$xauth" # Ensure the file exists
            xhost +local:docker >/dev/null

            docker run "${docker_run_opts[@]}" \
                -e DISPLAY \
                -e XAUTHORITY="$xauth" \
                -v "$xsock:$xsock" \
                -v "$xauth:$xauth" \
                "$IMAGE_NAME"
            ;;
        "vnc")
            echo "VNC mode is not yet fully implemented."
            # Add VNC-specific 'docker run' options here, e.g., port mapping
            # docker run "${docker_run_opts[@]}" -p 5901:5901 "$IMAGE_NAME"
            ;;
        *)
            echo "Error: Invalid GUI mode '$gui_mode' provided to run_container." >&2
            exit 1
            ;;
    esac
}

## ----------------- MAIN EXECUTION ----------------- ##

main() {
    # 1. Parse Command-Line Arguments
    if [[ $# -eq 0 ]]; then
        usage
    fi

    local user_gui_choice=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --gui)
                user_gui_choice=$(echo "$2" | tr '[:upper:]' '[:lower:]') # Normalize to lowercase
                shift 2
                ;;
            -h|--help)
                usage
                ;;
            *)
                echo "Unknown option: $1"
                usage
                ;;
        esac
    done

    if [[ -z "$user_gui_choice" || ! "$user_gui_choice" =~ ^(x11|vnc|auto)$ ]]; then
        echo "Error: Invalid or missing value for --gui."
        usage
    fi

    # 2. Check Prerequisites
    check_dependencies

    # 3. Determine Final GUI Mode (handles 'auto')
    local gui_mode
    gui_mode=$(resolve_gui_mode "$user_gui_choice")

    # 4. Determine the Correct Dockerfile
    local dockerfile_name="Dockerfile.${gui_mode,,}" # e.g., Dockerfile.x11
    local dockerfile_path="$DOCKERFILE_DIR/$dockerfile_name"

    if [[ ! -f "$dockerfile_path" ]]; then
        echo "Error: Required Dockerfile does not exist at: $dockerfile_path" >&2
        exit 1
    fi

    # 5. Build Image if Necessary
    build_image_if_needed "$IMAGE_NAME" "$dockerfile_path"

    # 6. Run the Container
    run_container "$gui_mode"
}

# Run the main function, passing all command-line arguments to it
main "$@"

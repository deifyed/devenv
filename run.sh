#!/bin/bash

VERBOSE=1
BUILD_LOCALLY=0
VERSION="latest"
FLAGS="-it --rm"

# Print verbose output
v() {
    if [[ $VERBOSE -eq 1 ]]; then
        echo "$@"
    fi
}

# Print usage
usage() {
    v "Usage: $0 [-h] [-b] [-s] [-w <directory>] [-v <version>]"
    v "Flags:"
    v "  -h Show this help message"
    v "  -b Build local image"
    v "  -s Mount ~/.ssh directory"
    v "  -v <version> Version of the official image to use"
    v "  -w <directory> Mount a directory"
}

while getopts ":hbsvw:" option; do
    case $option in
        h) usage; exit 0 ;;
        b) BUILD_LOCALLY=1 ;;
        s)
            ABS_PATH="${HOME}/.ssh"
            FLAGS="$FLAGS --mount=type=bind,source=${ABS_PATH},target=/home/dev/.ssh"
            ;;
        v) VERSION="$OPTARG" ;;
        w)
            ABS_PATH="$(cd "$(dirname -- "$OPTARG")" >/dev/null; pwd -P)/$(basename -- "$OPTARG")"
            FLAGS="$FLAGS --mount=type=bind,source=${ABS_PATH},destination=/home/dev/work"
            ;;
        \?) usage && exit 1 ;;
    esac
done

if [[ $BUILD_LOCALLY -eq 1 ]]; then
    v "Using locally built image"

    docker run ${FLAGS} $(docker build -q .)

    exit 0
fi

v "Using official image version ${VERSION}"

docker run ${FLAGS} ghcr.io/deifyed/devenv:${VERSION}

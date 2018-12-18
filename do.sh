#!/bin/sh

# Utility script
# To avoid errors, check your changes with https://www.shellcheck.net/

#set -eu

if [ "$OSTYPE" == "msys" ]; then
	export WINPTY=winpty
fi
export PROJECT_DIR="${PWD}"
export PROJECT_NAME="$(basename "${PROJECT_DIR}")"

export AWS_CREDENTIALS_DIR="${HOME}/.aws"

export BUILDER_DOCKERFILE_PATH="${PROJECT_DIR}/packer"
export BUILDER_IMAGE_VERSION=$(grep "version" <  "${BUILDER_DOCKERFILE_PATH}/Dockerfile" | grep -oe "[0-9]\+[.][0-9]\+[.][0-9]\+")
export BUILDER_IMAGE_ID="${PROJECT_NAME}-builder:${BUILDER_IMAGE_VERSION}"

export PACKER_DIR="${PROJECT_DIR}/packer"
export PACKER_FILE="packer.json"
export PACKER_WRAPPER="/var/local/packer/scripts/run-packer.sh"

case $1 in
  build)
    export PACKER_CMD="build"
    $WINPTY docker run --rm -it --mount "type=bind,source=${PROJECT_DIR},destination=/var/local" --mount "type=bind,source=${AWS_CREDENTIALS_DIR},destination=/root/.aws,readonly" "${BUILDER_IMAGE_ID}" "${PACKER_WRAPPER}" "${PACKER_CMD}" "./${PACKER_FILE}"
    ;;
  info)
    echo "Project        | Repository name       | ${PROJECT_NAME}"
    echo "Project        | Host directory        | ${PROJECT_DIR}"
    echo "Docker builder | Current image ID      | ${BUILDER_IMAGE_ID}"
    echo "Docker builder | Current image version | ${BUILDER_IMAGE_VERSION}"
    echo "Packer         | Build directory       | ${PACKER_DIR}"
    echo "Packer         | Template file         | ${PACKER_FILE}"
    echo "AWS            | Credentials directory | ${AWS_CREDENTIALS_DIR}"
    ;;
  setup)
    $WINPTY docker build "${BUILDER_DOCKERFILE_PATH}/" -t "${BUILDER_IMAGE_ID}"
    ;;
  shell)
    $WINPTY docker run --rm -it --mount "type=bind,source=${PROJECT_DIR},destination=/var/local" --mount "type=bind,source=${AWS_CREDENTIALS_DIR},destination=/root/.aws,readonly" "${BUILDER_IMAGE_ID}" /bin/sh
    ;;
  *)
    echo "$1 is not a valid command"
    ;;
esac


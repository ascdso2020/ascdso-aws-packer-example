#!/bin/sh

# Utility script
# To avoid errors, check your changes with https://www.shellcheck.net/

set -eu

PROJECT_DIR="${PWD}"
PROJECT_NAME="$(basename "${PROJECT_DIR}")"

AWS_CREDENTIALS_DIR="${HOME}/.aws"

BUILDER_DOCKERFILE_PATH="${PROJECT_DIR}/packer"
BUILDER_IMAGE_VERSION=$(grep "version" <  "${BUILDER_DOCKERFILE_PATH}/Dockerfile" | grep -oe "[0-9]\+[.][0-9]\+[.][0-9]\+")
BUILDER_IMAGE_ID="${PROJECT_NAME}-builder:${BUILDER_IMAGE_VERSION}"

PACKER_DIR="${PROJECT_DIR}/packer"
PACKER_FILE="packer.json"
PACKER_WRAPPER="/var/local/packer/scripts/run-packer.sh"

case $1 in
  build)
    PACKER_CMD="build"
    docker run --rm -it --mount "type=bind,source=${PROJECT_DIR},destination=/var/local" --mount "type=bind,source=${AWS_CREDENTIALS_DIR},destination=/root/.aws,readonly" "${BUILDER_IMAGE_ID}" "${PACKER_WRAPPER}" "${PACKER_CMD}" "./${PACKER_FILE}"
    ;;
  info)
    echo "Project: Repository name: ${PROJECT_NAME}"
    echo "AWS: Credentials directory: ${AWS_CREDENTIALS_DIR}"
    echo "Docker builder: Current image ID: ${BUILDER_IMAGE_ID}"
    echo "Docker builder: Current image version: ${BUILDER_IMAGE_VERSION}"
    echo "Packer: Build directory: ${PACKER_DIR}"
    echo "Packer: Config file: ${PACKER_FILE}"
    ;;
  setup)
    docker build "${BUILDER_DOCKERFILE_PATH}/" -t "${BUILDER_IMAGE_ID}"
    ;;
  shell)
    docker run --rm -it --mount "type=bind,source=${PROJECT_DIR},destination=/var/local" --mount "type=bind,source=${AWS_CREDENTIALS_DIR},destination=/root/.aws,readonly" "${BUILDER_IMAGE_ID}" /bin/sh
    ;;
  *)
    echo "$1 is not a valid command"
    ;;
esac


#!/bin/sh

PACKER_AMI_IMAGE="ami-09693313102a30b2c"
PACKER_AWS_REGION="eu-west-1"

PROJECT_NAME=`basename ${PWD}`
BUILDER_DOCKERFILE_PATH="${PWD}/packer"
BUILDER_IMAGE_VERSION=`cat ${BUILDER_DOCKERFILE_PATH}/Dockerfile | grep "version" | grep -oe "[0-9]\+[.][0-9]\+[.][0-9]\+"`
BUILDER_IMAGE_ID="$PROJECT_NAME-builder:$BUILDER_IMAGE_VERSION"

case $1 in
  build)
    docker run --rm -it --mount "type=bind,source=${PWD},destination=/var/local" --mount "type=bind,source=${HOME}/.aws,destination=/root/.aws,readonly" $BUILDER_IMAGE_ID /var/local/packer/scripts/run-packer.sh build ./packer.json
    ;;
  info)
    echo "Project name: ${PROJECT_NAME}"
    echo "Docker builder image ID: ${BUILDER_IMAGE_ID}"
    ;;
  setup)
    docker build ${BUILDER_DOCKERFILE_PATH}/ -t $BUILDER_IMAGE_ID
    ;;
  shell)
    docker run --rm -it --mount "type=bind,source=${PWD},destination=/var/local" --mount "type=bind,source=${HOME}/.aws,destination=/root/.aws,readonly" $BUILDER_IMAGE_ID /bin/sh
    ;;
  *)
    echo "$1 is not a valid command"
    ;;
esac


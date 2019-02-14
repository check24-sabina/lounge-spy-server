#!/bin/sh

. ./build/docker/docker_image_version.sh

REGISTRY="nexus.intern.bu.check24.de:8888/docker/"
IMAGE_NAME="${IMAGE_NAME:-lounge-spy-server}"
CONTAINER_NAME="${IMAGE_NAME}-test"
IMAGE="${REGISTRY}${IMAGE_NAME}:${VERSION}"
PORT=${PORT:-15600}

echo --- build started with:
echo --- IMAGE_VERSION: ${VERSION}
echo --- IMAGE: ${IMAGE}
echo --- DOCKER_REGISTRY_NAME: ${REGISTRY}
echo --- CONTAINER_NAME: ${CONTAINER_NAME}
echo --- PORT: ${PORT}

docker build -f Dockerfile --build-arg PORT=${PORT} -t ${IMAGE} .
BUILD_RESULT=$?
if [ ${BUILD_RESULT} -ne 0 ]; then
  echo "Docker build was failed ${BUILD_RESULT}"
  exit ${BUILD_RESULT}
fi

echo --- Saving test reports into ./reports
mkdir -p ./reports

docker run --name ${CONTAINER_NAME}         \
  -u root                                   \
  -v "$(pwd)/reports":/app/reports          \
  $IMAGE sh -c "cp /app/jest.json /app/eslint.json /app/reports"

docker rm -f ${CONTAINER_NAME}

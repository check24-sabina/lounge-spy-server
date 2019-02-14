. ./build/docker/docker_image_version.sh

REGISTRY="nexus.intern.bu.check24.de:8888/docker/"
IMAGE_NAME="lounge-spy-server"
CONTAINER_NAME=${IMAGE_NAME}
INTERNAL_PORT=15600
EXTERNAL_PORT=${1:-15600}

CONTAINER_ID=$(docker ps -a -q -f name=${CONTAINER_NAME})

if [ -n "${CONTAINER_ID}" ]; then
  echo "--- Stop and remove container ${CONTAINER_NAME} ..."
  docker rm -f ${CONTAINER_ID}
fi

docker run -d -p ${EXTERNAL_PORT}:${INTERNAL_PORT} \
           --name ${CONTAINER_NAME}                \
           --restart=always                        \
           -e NODE_ENV=production                  \
           -e PORT=${INTERNAL_PORT}                \
           ${REGISTRY}${IMAGE_NAME}:${VERSION}

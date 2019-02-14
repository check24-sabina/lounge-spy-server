FROM node:9-alpine as build

MAINTAINER BU-DEV <bu-dev@check24.de>

RUN apk add --update tzdata git

ENV TZ=Europe/Berlin

RUN ln -snf /usr/share/zoneinfo/Europe/Berlin /etc/localtime && echo "Europe/Berlin" > /etc/timezone

RUN mkdir /app

WORKDIR /app

RUN yarn install

ADD . /app

RUN yarn run doc

RUN NODE_ENV=test sh ./ci-build.sh; exit 0

RUN yarn install --production && rm -rf coverage

# Create the production version without dev-dependencies
FROM node:9-alpine

ARG PORT=0

ENV DOCKER_USER=node

RUN apk add --update tzdata git

ENV TZ=Europe/Berlin

RUN ln -snf /usr/share/zoneinfo/Europe/Berlin /etc/localtime && echo "Europe/Berlin" > /etc/timezone

RUN mkdir /app

COPY --from=build /app /app

USER ${DOCKER_USER}

WORKDIR /app

EXPOSE $PORT

CMD [ "node", "sources/server.js" ]


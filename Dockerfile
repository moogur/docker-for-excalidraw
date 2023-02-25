# Set versions
ARG NODE_VERSION=14-alpine
ARG NGINX_VERSION=1.23.3-alpine-slim

# First stage to build
FROM node:${NODE_VERSION} AS build

ENV NODE_ENV=production
WORKDIR /opt/node_app

RUN apk add --no-cache git && \
    git clone https://github.com/excalidraw/excalidraw ./ && \
    yarn --ignore-optional --network-timeout 600000 && \
    yarn build:app:docker

# Second stage to run
FROM nginx:${NGINX_VERSION}

COPY --from=build /opt/node_app/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1

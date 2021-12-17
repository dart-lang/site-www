FROM ruby:3-slim-bullseye as base

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=US/Pacific
RUN apt update && apt install -yq --no-install-recommends \
      build-essential \
      ca-certificates \
      curl \
      git \
      make \
      unzip \
      vim-nox \
    && rm -rf /var/lib/apt/lists/*

RUN echo "alias lla='ls -lAhG --color=auto'" >> ~/.bashrc
WORKDIR /root


# ============== DART ==============
# See https://github.com/dart-lang/dart-docker
# See https://github.com/dart-lang/setup-dart/blob/main/setup.sh
FROM base as dart
ARG DART_VERSION=latest
ARG DART_CHANNEL=stable
ENV DART_VERSION=$DART_VERSION
ENV DART_CHANNEL=$DART_CHANNEL
ENV DART_SDK=/usr/lib/dart
ENV PATH=$DART_SDK/bin:$PATH
RUN set -eu; \
    case "$(dpkg --print-architecture)_${DART_CHANNEL}" in \
      amd64_stable) \
        DART_SHA256="0f45dcaa53b4090b69b277b885ea9a4cb3a41589c9119113e1b978ad55ce335f"; \
        SDK_ARCH="x64";; \
      arm64_stable) \
        DART_SHA256="8836c294234352cc53e8aea4a1ce0442ebbb769a536ce7f309579da5020a2395"; \
        SDK_ARCH="arm64";; \
      amd64_beta) \
        DART_SHA256="b758aefce016c0dfdc8b4e2941c88e0a5c0d29339c4432abd58fab4ef076d2dc"; \
        SDK_ARCH="x64";; \
      arm64_beta) \
        DART_SHA256="1427731141075364bc2f6b2c89c3db28e781048b05149ab8d336ab213382aea6"; \
        SDK_ARCH="arm64";; \
      amd64_dev) \
        DART_SHA256="12f1f7bc8b7d47fdaab5db420ff5640f1f2f0ad37eae7586e291d4b410aef528"; \
        SDK_ARCH="x64";; \
      arm64_dev) \
        DART_SHA256="90fdcadbd1065c26a198aabebde53460ab83cf900c8363d51ccc263cddd51ab8"; \
        SDK_ARCH="arm64";; \
    esac; \
    SDK="dartsdk-linux-${SDK_ARCH}-release.zip"; \
    BASEURL="https://storage.googleapis.com/dart-archive/channels"; \
    URL="$BASEURL/$DART_CHANNEL/release/$DART_VERSION/sdk/$SDK"; \
    curl -fsSLO "$URL"; \
    echo "$DART_SHA256 *$SDK" | sha256sum --check --status --strict - || (\
        echo "Dart zip failed checksum, please review version and update sha if everything looks good" && \
        rm "$SDK" && \
        exit 1 \
    ); \
    unzip "$SDK" > /dev/null && mv dart-sdk "$DART_SDK" && rm "$SDK";


# ============== DART-TESTS ==============
from dart as dart-tests
WORKDIR /app
COPY ./ ./
RUN dart pub get
ENV BASE_DIR=/app
ENV TOOL_DIR=$BASE_DIR/tool
RUN $TOOL_DIR/test.sh


# ============== NODEJS INSTALL ==============
FROM dart as node
RUN set -eu; \
    NODE_PPA="node_ppa.sh"; \
    NODE_SHA256=4ba781bb650a918fd05aae57b092852eb411ea2984c88e9d1afae089f428a9b1; \
    curl -fsSL https://deb.nodesource.com/setup_lts.x -o "$NODE_PPA"; \
    echo "$NODE_SHA256 $NODE_PPA" | sha256sum --check --status --strict - || (\
        echo "Node setup failed checksum, please review setup script and update the sha if everything looks good" && \
        rm "$NODE_PPA" && \
        exit 1 \
    ); \
    echo "Adding nodesource PPA" && sh "$NODE_PPA" && rm "$NODE_PPA"; \
    apt-get update -q && apt-get install -yq --no-install-recommends \
      nodejs \
    && rm -rf /var/lib/apt/lists/*
# Ensure latest NPM
RUN npm install -g npm


# ============== DEV/JEKYLL SETUP ==============
FROM node as dev
WORKDIR /app

ENV JEKYLL_ENV=development
COPY Gemfile ./
RUN gem update --system && gem install bundler
RUN BUNDLE_WITHOUT="test production" bundle install --jobs=4 --retry=2

ENV NODE_ENV=development
COPY package.json ./
RUN npm install -g firebase-tools concurrently linkinator
RUN npm install

COPY ./ ./

# Get root packages after full copy
# See https://registry.hub.docker.com/r/google/dart/
RUN dart pub get

# Let's not play "which dir is this"
ENV BASE_DIR=/app
ENV TOOL_DIR=$BASE_DIR/tool

# Jekyl and Firebase ports
EXPOSE 4002
EXPOSE 5000

# re-enable defult in case we want to test packages
ENV DEBIAN_FRONTEND=dialog


# ============== BUILD PROD JEKYLL SITE ==============
FROM node AS build
WORKDIR /app

ENV JEKYLL_ENV=production
COPY Gemfile Gemfile.lock ./
RUN BUNDLE_WITHOUT="test development" bundle install --jobs=4 --retry=2 --quiet

ENV NODE_ENV=production
COPY package.json package-lock.json ./
RUN npm install

COPY ./ ./

# Get root packages
RUN dart pub get

ENV BASE_DIR=/app
ENV TOOL_DIR=$BASE_DIR/tool

ARG BUILD_CONFIGS=_config.yml
ENV BUILD_CONFIGS=$BUILD_CONFIGS
RUN printf "User-agent: *\nAllow: /" >> src/robots.txt
RUN bundle exec jekyll build --config $BUILD_CONFIGS


# ============== TEST BUILT JEKYLL SITE ==============
FROM build as build-tests
RUN npm install -g firebase-tools concurrently linkinator
RUN npm run checklinks


# ============== DEPLOY to FIREBASE ==============
FROM build-tests as deploy
ARG FIREBASE_TOKEN
ENV FIREBASE_TOKEN=$FIREBASE_TOKEN
RUN [[ -z $FIREBASE_TOKEN ]] && echo "FIREBASE_TOKEN is required!"
RUN make deploy-ci

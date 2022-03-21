FROM ruby:3-slim-bullseye as base

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=US/Pacific
RUN apt update && apt install -yq --no-install-recommends \
      build-essential \
      ca-certificates \
      curl \
      git \
      lsof \
      make \
      unzip \
      vim-nox \
    && rm -rf /var/lib/apt/lists/*

RUN echo "alias lla='ls -lAhG --color=auto'" >> ~/.bashrc
WORKDIR /root


# google-chrome-stable


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
        DART_SHA256="3cc63a0c21500bc5eb9671733843dcc20040b39fdc02f35defcf7af59f88d459"; \
        SDK_ARCH="x64";; \
      arm64_stable) \
        DART_SHA256="de9d1c528367f83bbd192bd565af5b7d9d48f76f79baa4c0e4cf64723e3fb8be"; \
        SDK_ARCH="arm64";; \
      amd64_beta) \
        DART_SHA256="edca0fe2afb7cb2a5d6c1ebc65cc9cf92db50940cad452de8ff0040272fe4444"; \
        SDK_ARCH="x64";; \
      arm64_beta) \
        DART_SHA256="4bb7866c4fdda23e3d9603b27b3c669376b3740b7b9eca2feb8e9ccbc1673bb8"; \
        SDK_ARCH="arm64";; \
      amd64_dev) \
        DART_SHA256="f5eeea0a4409b00812811707a28197de2d01dc51621d262e27fc3b237f13ad81"; \
        SDK_ARCH="x64";; \
      arm64_dev) \
        DART_SHA256="7df44514eb98f044bc0c070e24b3965821191809eff00e855379903f0f89c9cb"; \
        SDK_ARCH="arm64";; \
    esac; \
    SDK="dartsdk-linux-${SDK_ARCH}-release.zip"; \
    BASEURL="https://storage.googleapis.com/dart-archive/channels"; \
    URL="$BASEURL/$DART_CHANNEL/release/$DART_VERSION/sdk/$SDK"; \
    curl -fsSLO "$URL"; \
    echo "$DART_SHA256 *$SDK" | sha256sum --check --status --strict - || (\
        echo -e "\n\nDART CHECKSUM FAILED! Run 'make fetch-sums' for updated values.\n\n" && \
        rm "$SDK" && \
        exit 1 \
    ); \
    unzip "$SDK" > /dev/null && mv dart-sdk "$DART_SDK" && rm "$SDK";
ENV PUB_CACHE="${HOME}/.pub-cache"
RUN dart --disable-analytics
RUN echo -e "Successfully installed Dart SDK:" && dart --version


# ============== DART-TESTS ==============
from dart as dart-tests
WORKDIR /app
COPY ./ ./
RUN dart pub get
ENV BASE_DIR=/app
ENV TOOL_DIR=$BASE_DIR/tool
CMD ["./tool/test.sh"]


# ============== NODEJS INSTALL ==============
FROM dart as node
RUN set -eu; \
    NODE_PPA="node_ppa.sh"; \
    NODE_SHA256=05dc283d949b7cdd58f37385e310973c2aaa52e0f8cda08a93a5e4812d225338; \
    curl -fsSL https://deb.nodesource.com/setup_lts.x -o "$NODE_PPA"; \
    echo "$NODE_SHA256 $NODE_PPA" | sha256sum --check --status --strict - || (\
        echo -e "\n\nNODE CHECKSUM FAILED! Run tool/fetch-node-ppa-sum.sh for updated values.\n\n" && \
        rm "$NODE_PPA" && \
        exit 1 \
    ); \
    sh "$NODE_PPA" && rm "$NODE_PPA"; \
    apt-get update -q && apt-get install -yq --no-install-recommends \
      nodejs \
    && rm -rf /var/lib/apt/lists/*
# Ensure latest NPM
RUN npm install -g npm


# ============== DEV/JEKYLL SETUP ==============
FROM node as dev
WORKDIR /app

ENV JEKYLL_ENV=development
COPY Gemfile Gemfile.lock ./
RUN gem update --system && gem install bundler
RUN BUNDLE_WITHOUT="test production" bundle install --jobs=4 --retry=2

ENV NODE_ENV=development
COPY package.json package-lock.json ./
RUN npm install -g firebase-tools
RUN npm install

COPY ./ ./

# Get root packages after full copy
# See https://registry.hub.docker.com/r/google/dart/
RUN dart pub get

# Let's not play "which dir is this"
ENV BASE_DIR=/app
ENV TOOL_DIR=$BASE_DIR/tool

# Jekyl
EXPOSE 4000
EXPOSE 35729

# Firebase emulator port
# Airplay runs on :5000 by default now
EXPOSE 5500 

# re-enable defult in case we want to test packages
ENV DEBIAN_FRONTEND=dialog


# ============== FIREBASE EMULATE ==============
FROM dev as emulate
RUN bundle exec jekyll build --config _config.yml,_config_test.yml
CMD ["make", "emulate"]

# ============== TEST JEKYLL SITE ==============
FROM dev as checklinks
RUN bundle exec jekyll build --config _config.yml,_config_test.yml
CMD ["npm", "run", "checklinks"]


# ============== BUILD PROD JEKYLL SITE ==============
FROM node AS build
WORKDIR /app

ENV JEKYLL_ENV=production
COPY Gemfile Gemfile.lock ./
RUN gem update --system && gem install bundler
RUN BUNDLE_WITHOUT="test development" bundle install --jobs=4 --retry=2 --quiet

ENV NODE_ENV=production
COPY package.json package-lock.json ./
RUN npm install

COPY ./ ./

RUN dart pub get

ENV BASE_DIR=/app
ENV TOOL_DIR=$BASE_DIR/tool

ARG BUILD_CONFIGS=_config.yml
ENV BUILD_CONFIGS=$BUILD_CONFIGS
RUN bundle exec jekyll build --config $BUILD_CONFIGS


# ============== DEPLOY to FIREBASE ==============
FROM build as deploy
RUN npm install -g firebase-tools
ARG FIREBASE_TOKEN
ENV FIREBASE_TOKEN=$FIREBASE_TOKEN
ARG FIREBASE_PROJECT=default
ENV FIREBASE_PROJECT=$FIREBASE_PROJECT
RUN [[ -z "$FIREBASE_TOKEN" ]] && echo "FIREBASE_TOKEN is required for container deploy!"
RUN make deploy-ci

FROM ruby:3.2-slim-bullseye@sha256:d8e5caa21b5ebc425828af1eb43a678afceaca80681cac26b457063a18488e10 as base

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
        DART_SHA256="0fdff25e6acba3d6094155a7e341634f8de3477e86c2fda4ad47232c1adf704f"; \
        SDK_ARCH="x64";; \
      arm64_stable) \
        DART_SHA256="6913b7c0b3b78bc141d372cd473da21771e57372b1ab45c977ce1550c8ff0b9c"; \
        SDK_ARCH="arm64";; \
      amd64_beta) \
        DART_SHA256="02c21fd46d0be0ea4d184406a8c8446205129db0e19b8feff6a3ab06a127f83f"; \
        SDK_ARCH="x64";; \
      arm64_beta) \
        DART_SHA256="4253dae7dfaca493c844e25ba42a504f93ac69174d3b9a2a808068125f245508"; \
        SDK_ARCH="arm64";; \
      amd64_dev) \
        DART_SHA256="e697e3bee1469482ed2b781085febc3c75f043886c21138ab738d09ab56b1c4d"; \
        SDK_ARCH="x64";; \
      arm64_dev) \
        DART_SHA256="197b31f24c171e88c2454b9e750671a7c4f7a72875cf9482dc7444bb159781ea"; \
        SDK_ARCH="arm64";; \
    esac; \
    SDK="dartsdk-linux-${SDK_ARCH}-release.zip"; \
    BASEURL="https://storage.googleapis.com/dart-archive/channels"; \
    URL="$BASEURL/$DART_CHANNEL/release/$DART_VERSION/sdk/$SDK"; \
    curl -fsSLO "$URL"; \
#    TODO(parlough): Re-enable when moving back to stable
#    echo "$DART_SHA256 *$SDK" | sha256sum --check --status --strict - || (\
#        echo -e "\n\nDART CHECKSUM FAILED! Run 'make fetch-sums' for updated values.\n\n" && \
#        rm "$SDK" && \
#        exit 1 \
#    ); \
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
    NODE_SHA256=9f6707e20789ff7c1d39a11ed3be09039bf44e85f2082329cb27ae4c45541c81; \
    curl -fsSL https://deb.nodesource.com/setup_lts.x -o "$NODE_PPA"; \
#    TODO(parlough): Re-enable when moving back to stable
#    echo "$NODE_SHA256 $NODE_PPA" | sha256sum --check --status --strict - || (\
#        echo -e "\n\nNODE CHECKSUM FAILED! Run tool/fetch-node-ppa-sum.sh for updated values.\n\n" && \
#        rm "$NODE_PPA" && \
#        exit 1 \
#    ); \
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
RUN npm install -g firebase-tools@11.26.0
RUN npm install

COPY ./ ./

# Ensure packages are still up-to-date if anything has changed
# RUN dart pub get --offline
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
RUN npm install -g firebase-tools@11.26.0
ARG FIREBASE_TOKEN
ENV FIREBASE_TOKEN=$FIREBASE_TOKEN
ARG FIREBASE_PROJECT=default
ENV FIREBASE_PROJECT=$FIREBASE_PROJECT
RUN [[ -z "$FIREBASE_TOKEN" ]] && echo "FIREBASE_TOKEN is required for container deploy!"
RUN make deploy-ci

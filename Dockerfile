FROM debian:bookworm-slim@sha256:b55e2651b71408015f8068dd74e1d04404a8fa607dd2cfe284b4824c11f4d9bd as base

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=US/Pacific
RUN apt update && apt install -yq --no-install-recommends \
      build-essential \
      ca-certificates \
      curl \
      git \
      gnupg \
      lsof \
      make \
      unzip \
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
      # BEGIN dart-sha
      amd64_stable) \
        DART_SHA256="4342ba274a4e9f8057079cf9de43b1c7bdb002016ad538313e8ebe942b61bba8"; \
        SDK_ARCH="x64";; \
      arm64_stable) \
        DART_SHA256="0f0e19c276c99fa3efd6428ea4bef1502f742f2a1f9772959637eec775c10ba0"; \
        SDK_ARCH="arm64";; \
      amd64_beta) \
        DART_SHA256="345fc18e2c2ab39db94fa9da34afb7d2f6bc7dff35cba66fc30429a68b4b52c4"; \
        SDK_ARCH="x64";; \
      arm64_beta) \
        DART_SHA256="f2592ee85cab72c74b20e0f138f3acc023e9dc0e04e6aede25dd97ed78311873"; \
        SDK_ARCH="arm64";; \
      amd64_dev) \
        DART_SHA256="b1f3c2088579400a2174d4f586f5827ba0703313e75c71d0c102307e3222a463"; \
        SDK_ARCH="x64";; \
      arm64_dev) \
        DART_SHA256="4b6b33bb90292c703f672add93d6503701e8ab13727ecfa77d8f3e7467453bc0"; \
        SDK_ARCH="arm64";; \
      # END dart-sha
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

RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update -yq \
    && apt-get install nodejs -yq \
    && npm install -g npm # Ensure latest npm


# ============== DEV/11TY SETUP ==============
FROM node as dev
WORKDIR /app

ENV NODE_ENV=development
COPY package.json package-lock.json ./
RUN npm install

COPY ./ ./

# Ensure packages are still up-to-date if anything has changed
# RUN dart pub get --offline
RUN dart pub get

# Let's not play "which dir is this"
ENV BASE_DIR=/app
ENV TOOL_DIR=$BASE_DIR/tool

# 11ty
EXPOSE 4000
EXPOSE 8080
EXPOSE 35729

# Firebase emulator port
# Airplay runs on :5000 by default now
EXPOSE 5500

# re-enable defult in case we want to test packages
ENV DEBIAN_FRONTEND=dialog


# ============== FIREBASE EMULATE ==============
FROM dev as emulate

RUN npm run build
CMD ["make", "emulate"]


# ============== BUILD PROD JEKYLL SITE ==============
FROM node AS build
WORKDIR /app

ENV PRODUCTION=true
COPY package.json package-lock.json ./
RUN npm install

COPY ./ ./

ENV BASE_DIR=/app
ENV TOOL_DIR=$BASE_DIR/tool
ENV NODE_ENV=production

RUN npm run build


# ============== DEPLOY to FIREBASE ==============
FROM build as deploy

ARG FIREBASE_TOKEN
ENV FIREBASE_TOKEN=$FIREBASE_TOKEN
ARG FIREBASE_PROJECT=default
ENV FIREBASE_PROJECT=$FIREBASE_PROJECT
RUN [[ -z "$FIREBASE_TOKEN" ]] && echo "FIREBASE_TOKEN is required for container deploy!"
RUN make deploy-ci

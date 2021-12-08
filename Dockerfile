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


# ============== NODEJS ==============

FROM base as node
RUN set -eux; \
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


# ============== DART ==============

FROM node as dart
ARG DART_VERSION=2.14.4
ARG DART_CHANNEL=stable
ENV DART_VERSION=$DART_VERSION
ENV DART_CHANNEL=$DART_CHANNEL
ENV DART_SDK=/usr/lib/dart
ENV PATH=$DART_SDK/bin:$PATH
RUN set -eux; \
    case "$(dpkg --print-architecture)" in \
      amd64) \
        DART_SHA256=49b6a98008ef546cb9c221461529d6c02cf2474bff098e0dc7e4ff1ef0f8a289; \
        SDK_ARCH="x64";; \
      arm64) \
        DART_SHA256=0477fae6fcff58fec18d912537f13d647fa0e137fce23401eea73102dce62351; \
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
    unzip "$SDK" && mv dart-sdk "$DART_SDK" && rm "$SDK";


# ============== DEV ==============

FROM dart as dev
WORKDIR /app

ENV JEKYLL_ENV=development
COPY Gemfile ./
RUN gem update --system && gem install bundler
RUN BUNDLE_WITHOUT="test production" bundle install --jobs=4 --retry=2

ENV NODE_ENV=development
COPY package.json ./
RUN npm install -g npm firebase-tools superstatic linkinator
RUN npm install

COPY ./ ./

# Let's not play which dir is this
ENV BASE_DIR=/app
ENV TOOL_DIR=$BASE_DIR/tool

# Get root packages
RUN dart pub get

# Jekyl & Firebase ports
# EXPOSE 35729
EXPOSE 4002
EXPOSE 5500

# re-enable defult in case we want to test packages
ENV DEBIAN_FRONTEND=dialog


# ============== BUILD ==============

FROM dart AS build
WORKDIR /app

ENV JEKYLL_ENV=production
COPY Gemfile Gemfile.lock ./
RUN BUNDLE_WITHOUT="test development" bundle install --jobs=4 --retry=2 --quiet

ENV NODE_ENV=production
COPY package.json package-lock.json ./
RUN npm install

COPY ./ ./

# Let's not play which dir is this
ENV BASE_DIR=/app
ENV TOOL_DIR=$BASE_DIR/tool

# Get root packages
RUN dart pub get

ARG BUILD_CONFIGS=_config.yml
ENV BUILD_CONFIGS=$BUILD_CONFIGS
RUN echo "User-agent: *" > src/robots.txt && echo "Allow: /" >> src/robots.txt
RUN bundle exec jekyll build --config $BUILD_CONFIGS


# ============== TEST ==============

FROM build as test
RUN echo ">>> __TEST__ <<<"
# RUN tool/test.sh --target $TEST_TARGET_CHANNEL --check-links --null-safety


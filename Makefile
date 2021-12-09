#!/usr/bin/make -f
-include .env


all: clean up down debug shell serve test-build test-run setup \
	serve emulate stage test build-image build deploy deploy-ci

.PHONY: all
.DEFAULT_GOAL := up

# NOTE all vars can be overridden by a .env file
BUILD_COMMIT := $(shell git rev-parse --short HEAD)
BUILD_CONFIGS ?= _config.yml
BUILD_NAME ?= dart_dev_build
BUILD_TAG ?= dart-dev
BUILD_TARGET ?= build
DART_CHANNEL ?= stable
DART_VERSION ?= latest
FIREBASE_ALIAS ?= default
FIREBASE_CHANNEL ?= stage
FIREBASE_EMULATOR_PORT ?= 5500
JEKYLL_SITE_HOST ?= 0.0.0.0
JEKYLL_SITE_PORT ?= 4002

# Clean up caches, build files, etc
clean:
	rm -rf _site .jekyll* src/.jekyll* *.log tmp .dart_tool

# Start local dev container/server
up:
	docker compose up site

# Bring down the local dev container/server
down:
	-docker compose down site

# Run the dev container and enter shell for debugging
run:
	docker compose run --rm site bash

# Enter the shell of the running container from `make up`
exec:
	-docker compose exec site bash

# Build the dev container from scratch.
# # Runs packages installs a second time for both Gems and NPM to 
# # overcome inconsistent bugs with missing packages at runtime.
setup:
	make clean
	-docker compose down
	-docker rmi ${BUILD_TAG}:local
	docker compose build site

# Serve the Jekyll site with livereload and incremental builds
serve:
	bundle exec jekyll serve \
		--host ${JEKYLL_SITE_HOST} \
		--port ${JEKYLL_SITE_PORT} \
		--config _config.yml,_config_dev.yml \
		--livereload \
		--incremental \
		--trace

# Test hosting locally with Firebase emulator
emulate:
	npx firebase emulators:start --only hosting --project ${FIREBASE_ALIAS}

# Deploy to Firebase via a staging channel
# Usage: `make stage [FIREBASE_CHANNEL=<name>]`
stage:
	make build BUILD_CONFIGS=_config.yml,_config_stage.yml
	npx firebase use ${FIREBASE_ALIAS}
	npx firebase hosting:channel:deploy ${FIREBASE_CHANNEL}

# Run all tests inside a built container
test:
	DOCKER_BUILDKIT=1 docker build \
		-t ${BUILD_TAG}:${BUILD_COMMIT} \
		--no-cache \
		--target test \
		--build-arg FIREBASE_ALIAS=${FIREBASE_ALIAS} \
		--build-arg DART_VERSION=${DART_VERSION} \
		--build-arg DART_CHANNEL=${DART_CHANNEL} .

# Build docker image with optional target
# Usage: `make build-image [BUILD_CONFIGS=<config1,[config2,]>]`
build-image:
	DOCKER_BUILDKIT=1 docker build \
		-t ${BUILD_TAG}:${BUILD_COMMIT} \
		--no-cache \
		--target ${BUILD_TARGET} \
		--build-arg DART_VERSION=${DART_VERSION} \
		--build-arg DART_CHANNEL=${DART_CHANNEL} \
		--build-arg BUILD_CONFIGS=${BUILD_CONFIGS} .

# Build the Jekyll site via Docker and copy built site to local
build:
	make clean
	make build-image
	docker run --rm -d --name ${BUILD_NAME} -t ${BUILD_TAG}:${BUILD_COMMIT}
	docker cp ${BUILD_NAME}:/app/_site _site
	docker stop ${BUILD_NAME}
	docker rmi -f ${BUILD_TAG}:${BUILD_COMMIT}

# Deploy locally
deploy:
	npx firebase use ${FIREBASE_ALIAS}
	npx firebase deploy -m ${BUILD_COMMIT} --only hosting

# Deploy to Firebase hosting on CI/CD
# Requires that a `FIREBASE_TOKEN` is set in ENV
deploy-ci:
	npx firebase use ${FIREBASE_ALIAS}
	npx firebase deploy -m ${BUILD_COMMIT} \
		--only hosting \
		--non-interactive \
		--token ${FIREBASE_TOKEN} \
		--project ${FIREBASE_ALIAS} \
		--debug

# Fetch SDK sums for current Dart SDKs by arch
fetch-sdk-sums:
	./tool/fetch-dart-sdk-sums.sh \
		--version ${DART_VERSION} \
		--channel ${DART_CHANNEL}

# Test the dev container with pure docker
test-build:
	docker build -t ${BUILD_TAG}:stable \
		--no-cache --target=dart-tests .
	docker build -t ${BUILD_TAG}:beta \
		--no-cache --target=dart-tests --build-arg DART_CHANNEL=beta .
	docker build -t ${BUILD_TAG}:dev \
		--no-cache --target=dart-tests --build-arg DART_CHANNEL=dev .

# Test stable run with volume
test-run:
	docker run --rm -it -v ${PWD}:/app ${BUILD_TAG}:stable bash
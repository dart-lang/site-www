#!/usr/bin/make -f
-include .env


all: clean up down debug shell serve test-build test-run setup \
	serve emulate stage test build-image build deploy deploy-ci \
	fetch-sums test-builds test-run

.PHONY: all
.DEFAULT_GOAL := up

# NOTE all vars can be overridden by using a local .env file
BUILD_COMMIT := $(shell git rev-parse --short HEAD)
BUILD_CONFIGS ?= _config.yml
BUILD_NAME ?= dart_dev_build
BUILD_TAG ?= dart-dev
BUILD_TARGET ?= build
DART_CHANNEL ?= stable
DART_VERSION ?= latest
FIREBASE_PROJECT ?= default
FIREBASE_CHANNEL ?= dart
JEKYLL_SITE_HOST ?= 0.0.0.0
JEKYLL_SITE_PORT ?= 4000

# Here so Docker Compose does not complain, add any env 
# overrides to this file. Blank is okay, it's ignored.
# For example, add a FIREBASE_PROJECT if staging
.env:
	touch $@

# Clean up caches, build files, etc
clean:
	rm -rf _site **/.jekyll*  *.log tmp .dart_tool

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

# Reset, build dev container from scratch
setup:
	make clean
	-docker compose down
	-docker rmi ${BUILD_TAG}:${DART_CHANNEL}
	docker compose build --no-cache site \
	 --build-arg DART_VERSION=${DART_VERSION} \
	 --build-arg DART_CHANNEL=${DART_CHANNEL}

# Serve the Jekyll site with livereload and incremental builds
serve:
	bundle exec jekyll serve \
		--host ${JEKYLL_SITE_HOST} \
		--port ${JEKYLL_SITE_PORT} \
		--config _config.yml,_config_dev.yml \
		--livereload \
		--incremental \
		--trace

# Run all tests inside a built container
test:
	DOCKER_BUILDKIT=1 docker build \
		-t dart-tests:${DART_CHANNEL} \
		--target dart-tests \
		--build-arg DART_VERSION=${DART_VERSION} \
		--build-arg DART_CHANNEL=${DART_CHANNEL} .
	docker run --rm -v ${PWD}:/app dart-tests:${DART_CHANNEL}

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

# Overwrite robots.txt with production version
write-prod-robots:
	@echo "User-agent: *\nDisallow:\n\nSitemap: https://dart.dev/sitemap.xml" \
    		> _site/robots.txt

# Deploy locally
deploy:
ifeq ("${FIREBASE_PROJECT}", "default")
	make write-prod-robots
endif
	npx firebase deploy -m ${BUILD_COMMIT} \
		--only hosting \
		--project ${FIREBASE_PROJECT}

# Deploy to Firebase hosting on CI/CD
# Requires that a `FIREBASE_TOKEN` is set in ENV
deploy-ci:
ifeq ("${FIREBASE_PROJECT}", "default")
	make write-prod-robots
endif
	npx firebase deploy -m ${BUILD_COMMIT} \
		--only hosting \
		--project ${FIREBASE_PROJECT} \
		--token ${FIREBASE_TOKEN} \
		--debug

# Deploy to Firebase via a staging channel
# Usage: `make stage [FIREBASE_CHANNEL=<name>]`
stage:
	npx firebase hosting:channel:deploy ${FIREBASE_CHANNEL} \
		--project ${FIREBASE_PROJECT}

# Test hosting locally with Firebase emulator
emulate:
	npx firebase emulators:start \
		--only hosting \
		--project ${FIREBASE_PROJECT}



################## UTILS ##################

# Fetch SDK sums for current Dart SDKs by arch
# This outputs a bash case format to be copied to Dockerfile
fetch-sums:
	tool/fetch-dart-sdk-sums.sh \
		--version ${DART_VERSION} \
		--channel ${DART_CHANNEL}

# Test the dev container with pure docker
test-builds:
	docker build -t ${BUILD_TAG}:stable \
		--no-cache --target=dart-tests .
	docker build -t ${BUILD_TAG}:beta \
		--no-cache --target=dart-tests --build-arg DART_CHANNEL=beta .
	docker build -t ${BUILD_TAG}:dev \
		--no-cache --target=dart-tests --build-arg DART_CHANNEL=dev .

# Test stable run with volume
TEST_CHANNEL =? stable
test-run:
	docker run --rm -it -v ${PWD}:/app ${BUILD_TAG}:${TEST_CHANNEL} bash

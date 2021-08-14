#!/usr/bin/env bash
set -euo pipefail

docker build -t ecr-docker-push:latest $(dirname ${BASH_SOURCE[0]})
docker run --rm -v $HOME/.aws:/root/.aws -v /var/run/docker.sock:/var/run/docker.sock -t ecr-docker-push:latest $@
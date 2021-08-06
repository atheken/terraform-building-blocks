#!/usr/bin/env bash
set -eou pipefail

docker build -t $@ .

# External terraform scripts must return a valid json object.
echo '{}'
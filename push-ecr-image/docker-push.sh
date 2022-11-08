#!/usr/bin/env bash
set -euo pipefail

image=$1
registry_url=$2
password=$3
docker tag $image $registry_url/$image

docker login --username AWS --password $password $registry_url
docker push $registry_url/$image
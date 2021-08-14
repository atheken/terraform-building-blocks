#!/usr/bin/env bash
set -euo pipefail

result=$(docker images $1 --format '{ "ImageID": "{{.ID}}" }')
echo -n ${result:-'{ "ImageID": "null" }'}
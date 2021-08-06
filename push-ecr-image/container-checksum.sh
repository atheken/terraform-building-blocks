#!/usr/bin/env bash
set -euo pipefail

docker images $1 --format '{ "ImageID": "{{.ID}}" }'
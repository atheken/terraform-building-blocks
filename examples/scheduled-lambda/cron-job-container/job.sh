#!/usr/bin/env bash
set -euo pipefail

# the function handler here is called by the bootstrap script (which runs in a loop.)
function apply {
  echo '{ "status" : 0, "message" : "Lambda executed successfully!"}'
}
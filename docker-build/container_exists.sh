#!/usr/bin/env bash

image=$1
result=$(docker images $image --format '{{.Tag}}' | wc -l) 

# External terraform scripts must return a valid json object.
echo '{ "matching_images" :"'$result'"}'
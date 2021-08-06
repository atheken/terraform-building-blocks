#!/usr/bin/env bash
set -euo pipefail

image=$1
registry_url=$2
assume_role_arn=${3:-''}
assume_role_session_name=${4:-'terraform-push-docker'}

docker tag $image $registry_url/$image

if [[ ! -z $assume_role_arn ]]; then

  temp_role=$(aws sts assume-role \
       --role-arn $assume_role_arn \
       --role-session-name $assume_role_session_name)
       
  export AWS_ACCESS_KEY_ID=$(echo $temp_role | jq -r .Credentials.AccessKeyId)
  export AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq -r .Credentials.SecretAccessKey)
  export AWS_SESSION_TOKEN=$(echo $temp_role | jq -r .Credentials.SessionToken)
  
fi

docker logout $registry_url
aws ecr get-login-password | docker login --username AWS --password-stdin $registry_url
docker push $registry_url/$image
docker logout $registry_url
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

repo_name=$(echo $1 | sed -E 's#([^:]+):[^:]+#\1#')
image_tag=$(echo $image | sed -E 's#[^:]+:([^:]+)#\1#')

lookup_result=$(aws ecr describe-images --repository-name=$repo_name --image-ids=imageTag=$image_tag 2> /dev/null)

if [[ $? == 0 ]] ; then
  echo "Image exists, no need to push."
else
  aws ecr get-login-password | docker login --username AWS --password-stdin $registry_url
  docker push $registry_url/$image
fi
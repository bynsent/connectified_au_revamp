#! /bin/bash

# ./build.sh release - creates a release image tag
# ./build.sh - creates a development image tag
# az acr login --name acrwebsites
release_tag=$1
container_registry_host="acrwebsites.azurecr.io"
repo_name="connectified-au"

DAY=$(date -d "$D" '+%d')
MONTH=$(date -d "$D" '+%m')
YEAR=$(date -d "$D" '+%Y')

IMAGE_TAG=$YEAR.$MONTH.$DAY.$(mktemp -u XXXXXXXXXX)

if [ $release_tag = "release" ]; then
    IMAGE_TAG=$YEAR.$MONTH.$DAY
fi

echo "Image Tag Generated $IMAGE_TAG"

docker build . --platform linux/amd64 -t $container_registry_host/$repo_name:$IMAGE_TAG

container_id=$(docker run  -it --rm -d $container_registry_host/$repo_name:$IMAGE_TAG)
echo "Container ID Generated $container_id"

docker commit $container_id $container_registry_host/$repo_name:$IMAGE_TAG
docker push $container_registry_host/$repo_name:$IMAGE_TAG

# docker build . --platform linux/amd64 -t acrwebsites.azurecr.io/connectified-ph:1235
# docker push acrwebsites.azurecr.io/connectified-ph:1235

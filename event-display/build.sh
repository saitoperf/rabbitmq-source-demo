#!/bin/bash

set -e

if [ "$1" = '' ]; then
    echo Usage 
    echo '    ./build.sh [registry]'
    echo ex
    echo '    ./build.sh docker.io/shiron228/event-display:latest'
    exit 1
fi

docker build -t $1 .
docker push $1
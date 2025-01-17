#!/usr/bin/env bash

set -o errexit -o nounset -o errtrace -o pipefail -x

if [[ "${IMAGE_NAME}" == "" ]]; then
    echo "Must set IMAGE_NAME environment variable. Exiting."
    exit 1
fi

# We want nginx to shutdown gracefully. It should get the SIGQUIT signal.
LOGFILE=$(mktemp)
ID=$(docker run --rm -d $IMAGE_NAME)
docker attach $ID 2> $LOGFILE &
sleep 5
docker stop $ID 
grep "SIGQUIT" $LOGFILE
grep "gracefully shutting down" $LOGFILE 

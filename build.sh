#!/bin/bash
DIR=$(dirname $(readlink -f $0))
IMAGE_NAME=$1

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

while [ -z ${SERVER_VERSION} ] || [ 0 -eq ${#SERVER_VERSION} ] || [[ ! -d ${DIR}/server/${SERVER_VERSION} ]]; do
    echo ""
    echo "Evailable server versions:"
    ls -l server | awk '{print $9}'
    echo ""
    echo "Please enter version (see above):"
    read SERVER_VERSION
done

mount --bind ${DIR}/server/${SERVER_VERSION} ${DIR}/docker/server

[[ -z ${IMAGE_NAME} ]] && IMAGE_NAME=$(echo ${SERVER_VERSION} | sed 's/\W/-/g' | tr '[:upper:]' '[:lower:]')

cd docker
docker build -t ${IMAGE_NAME} .
cd -

umount -f ${DIR}/docker/server

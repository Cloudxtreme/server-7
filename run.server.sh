#!/bin/bash
SERVER_NAME="mcserver"
SERVER_PORT="25565"
BACKUP_INTERVAL="360" # Every 6 h
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

while [[ $# > 1 ]]
do
key="$1"
case ${key} in
    -d|--data)
    DATA_DIR="$2"
    shift # past argument
    ;;
    -n|--name)
    SERVER_NAME="$2"
    shift # past argument
    ;;
    -i|--image)
    CONTAINER_IMAGE="$2"
    shift # past argument
    ;;
    -p|--port)
    SERVER_PORT="$2"
    shift # past argument
    ;;
    -c|--cpu-count)
    MC_CPU_COUNT="$2"
    shift # past argument
    ;;
    -im|--init-memory)
    MC_MAX_MEMORY="$2"
    shift # past argument
    ;;
    -mm|--max-memory)
    MC_INIT_MEMORY="$2"
    shift # past argument
    ;;
    --blazer-account)
    BACKBLAZE_ACCOUNT_ID="$2"
    ;;
    --blazer-key)
    BACKBLAZE_APP_KEY="$2"
    ;;
    --blazer-bucket)
    BACKBLAZE_BUCKET="$2"
    ;;
    --backup-interval)
    BACKUP_INTERVAL="$2"
    ;;
    *)
    # unknown option
    ;;
esac
shift # past argument or value
done

function usage {
    echo "$0 "
}

if [[ -z ${DATA_DIR} ]]; then
    echo "Data dir path can't be empty string"
    exit
fi

if [[ -z ${SERVER_NAME} ]]; then
    echo "Server name can't be empty string"
    exit
fi

mkdir -p ${DATA_DIR}/mcbackup
mkdir -p ${DATA_DIR}/worlds
mkdir -p ${DATA_DIR}/mods
mkdir -p ${DATA_DIR}/plugins
mkdir -p ${DATA_DIR}/logs
mkdir -p ${DATA_DIR}/config
mkdir -p ${DATA_DIR}/config-server
mkdir -p ${DATA_DIR}/logs

MC_HOME=/home/minecraft
SERVER_HOME=/home/minecraft/server

docker run -d --restart=always \
--name=${SERVER_NAME} \
-e MC_CPU_COUNT=${MC_CPU_COUNT} \
-e MC_INIT_MEMORY=${MC_INIT_MEMORY} \
-e MC_MAX_MEMORY=${MC_MAX_MEMORY} \
-e BACKUP_INTERVAL=${BACKUP_INTERVAL} \
-e BACKBLAZE_ACCOUNT_ID=${BACKBLAZE_ACCOUNT_ID} \
-e BACKBLAZE_APP_KEY=${BACKBLAZE_APP_KEY} \
-e BACKBLAZE_BUCKET=${BACKBLAZE_BUCKET} \
-v ${DATA_DIR}/mcbackup:${MC_HOME}/mcbackup \
-v ${DATA_DIR}/worlds:${SERVER_HOME}/worlds \
-v ${DATA_DIR}/mods:${SERVER_HOME}/mods \
-v ${DATA_DIR}/plugins:${SERVER_HOME}/plugins \
-v ${DATA_DIR}/logs:${SERVER_HOME}/logs \
-v ${DATA_DIR}/config:${SERVER_HOME}/config \
-v ${DATA_DIR}/config-server:${SERVER_HOME}/config-server \
-p ${SERVER_PORT}:25565 \
${CONTAINER_IMAGE}
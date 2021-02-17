#!/bin/bash

cli_args=$1
all_imgs=all
redis_img="./docker-compose-redis.yaml"
postgres_img="./docker-compose.yaml"
mongo_img="./docker-compose-mongodb.yaml"

declare -a images=($redis_img $postgres_img $mongo_img)

## something that can be added
## if there are already running containers should they be rebuilt
## echo "Valid args: (--build/-b|--run/-r)"

if [ ! -z "${cli_args}" ]; then
    case $cli_args in
        all)
            docker-compose -f $redis_img -f $postgres_img -f $mongo_img up -d
            echo "All selected"
            ;;
        redis)
            docker-compose -f $redis_img up -d
            echo "Run redis"
            ;;
        postgres)
            docker-compose -f $postgres_img up -d
            echo "Run postgres"
            ;;
        mongodb)
            docker-compose -f $mongo_img up -d
            echo "Run mongoDB"
            ;;
        *)
            echo "Valid args: (all|redis|postgres|mongodb)"
            exit 1
    esac
else
    echo "Requires one of the valid arguments"
    echo "Valid args: (all|redis|postgres|mongodb)"
    exit 1
fi

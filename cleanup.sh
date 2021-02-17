#!/bin/bash

cleanup_arg=$1
cleanup_default=yes

postgres_db=postgres/database
redis_db=redis/database
mongo_db=mongo/database

postgres_img=postgres-default
redis_img=redis-default
mongo_img=mongodb-default

declare -a db_cleanup=("${postgres_db}" "${redis_db}" "${mongo_db}")
declare -a imgs_cleanup=("${postgres_img}" "${redis_img}" "${mongo_img}")

function cleanup_dirs() {
for i in "${db_cleanup[@]}"
do
    full_path="${PWD}/${i}"
    if [ -d "${full_path}" ]
    then
        echo "Found dir: $full_path, cleaning up now."
        sudo rm -rf $full_path
    fi
done
}

## this should be refactored into cleaning up
## all the files that should not be here, not just root directories
function cleanup_root_dirs() {

    mongo_path="${PWD}/mongo"
    redis_path="${PWD}/redis"

    sudo rm -rf $mongo_path $redis_path
}

for img in "${imgs_cleanup[@]}"
do
    echo "Found docker container name: ${img}"
    docker kill ${img}
    docker rm ${img}
done

if [ -z "${cleanup_arg}" ]; then
    if [[ "${cleanup_default}" == "yes" ]]; then
        (cleanup_dirs)
    fi
elif [[ "${cleanup_arg}" == "yes" ]]; then
    (cleanup_dirs)
elif [[ "${cleanup_arg}" == "full" ]]; then
    (cleanup_dirs)
    # add the function to cleanup other type of files
fi

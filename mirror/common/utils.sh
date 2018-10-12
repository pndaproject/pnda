#!/bin/bash

function robust_curl {
    FIELDS=($1)
    FILE=${FIELDS[0]}
    if [[ ! -z ${FIELDS[1]} ]]; then
        USE_COOKIE="-b ${FIELDS[1]}"
    fi
    ATTEMPT=0
    RETRY=3
    echo ${FILE}
    until [[ ${ATTEMPT} -ge ${RETRY} ]]
    do
        curl $USE_COOKIE -sS -LOJf ${FILE} && break
        ATTEMPT=$[${ATTEMPT}+1]
        sleep 10
    done

    if [[ ${ATTEMPT} -ge ${RETRY} ]]; then
        echo "Failed to download ${FILE} after ${RETRY} retries"
        exit -1
    fi
}

#!/bin/bash
#
# This script supports:
#
#   Build to specific PNDA version
#       Pass "PNDA" as first parameter
#       Pass platform-salt branch or tag as second parameter (e.g. release/3.2)
#   Build specific upstream version
#       Pass "UPSTREAM" as first parameter
#       Pass upstream branch or tag as second parameter (e.g. 1.2.3.4)

MODE=${1}
ARG=${2}
./build-flink.sh ${MODE} ${ARG} CDH
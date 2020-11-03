#!/usr/bin/env bash
STARTD=${PWD}
SELFD=$(cd $(dirname ${0}) >/dev/null 2>&1; pwd)
SELF=$(basename ${0})
SELFN=$(basename ${SELFD})
SELFU=${SELF%.*}
SELFZ=${SELFD}/${SELF}
NOW=$(date +%Y%m%dt%H%M%S)
UNQ=${NOW}.${RANDOM}
LOGD=${SELFD}/${SELFU}.${UNQ}
LOG=${LOGD}/${SELFU}.log

TEST=${TEST:+echo}

mkdir -p ${LOGD} >/dev/null 2>&1
[ -w ${LOGD} ] || exit ${LINENO}
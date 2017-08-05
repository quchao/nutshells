#!/bin/sh
set -eo pipefail

# constants
readonly ARGS="$@"

# funcs
throw_error() {
    echo -e "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: \n${1:-Unknown Error}" >&2
    exit 1
}

parse_cmd() {
    # debug
    #echo $FUNCNAME $@

    local _CMD=$1

    [[ -n ${_CMD} && -x ${_CMD} ]] \
        || throw_error "Please specify a program to run."

    shift
    local _ARGS="$@"

    # run as specified user
    exec su-exec \
        "${RUN_AS_USER}" \
        "${_CMD}" \
        ${_ARGS}
}

main() {
    # env check
    [[ -n ${RUN_AS_USER} ]] \
        || throw_error "This script is only compatible with project nutshells images,\ndon't try to run it out straight."

    parse_cmd ${ARGS}
}
main

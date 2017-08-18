#!/bin/sh
set -eo pipefail

# constants
readonly ARGS="$@"

# funcs
throw_exception() {
    local _LEVEL="${1:-INFO}"
    shift
    echo -e "\n[${_LEVEL}]\n$(date +'%Y-%m-%dT%H:%M:%S%z')\n$*" >&2
}

info() {
    throw_exception 'INFO' "$*"
}

warning() {
    throw_exception 'WARNING' "$*"
}

error() {
    throw_exception 'ERROR' "$*"
}

fatal() {
    throw_exception 'FATAL' "$*"
    exit 1
}

parse_cmd() {
    # debug
    #info "${FUNCNAME}" "$*"

    local _CMD="$1"

    [[ -n ${_CMD} && -x ${_CMD} ]] \
        || fatal 'Please specify a program to run.'

    shift
    local _ARGS="$@"

    # run as specified user
    exec su-exec \
        "${RUN_AS_USER}" \
        "${_CMD}" \
        ${_ARGS}
}

cleanup() {
    info 'Entrypoint Script ended.'
}

main() {
    # env check
    [[ -n ${RUN_AS_USER} ]] \
        || throw_error "This script is only compatible with project nutshells images,\ndon't try to run it out straight."

    parse_cmd ${ARGS}
}

trap cleanup EXIT
main

#!/bin/sh
# ruby-cli-app
# A wrapper script for invoking ruby-cli-app with docker
# Put this script in $PATH as `ruby-cli-app`

PROGNAME="$(basename $0)"
VERSION="v0.0.1"

# Helper functions for guards
error(){
    error_code=$1
    echo "ERROR: $2" >&2
    echo "($PROGNAME wrapper version: $VERSION, error code: $error_code )" >&2
    exit $1
}
check_cmd_in_path(){
    cmd=$1
    which $cmd > /dev/null 2>&1 || error 1 "$cmd not found!"
}

# Guards (checks for dependencies)
check_cmd_in_path docker
check_cmd_in_path docker-machine
docker-machine active > /dev/null 2>&1 || error 2 "No active docker-machine VM found."

# Set up mounted volumes, environment, and run our containerized command
docker run \
  --interactive --tty --rm \
  --volume "$PWD":/wd \
  --workdir /wd \
  "atomicobject/ruby-cli-app:$VERSION" "$@"

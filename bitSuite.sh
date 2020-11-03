#!/usr/bin/env bash

# These are to be overridden from the script using this
verbose=
quiet=

# default log output
# deactivated when quiet=1
function l() {
  [[ -n "$quiet" ]] || echo -e "$*"
}

# log if verbose=1
function v() {
  [[ -n "$verbose" ]] && l "$*"
}

# log errors
# errors go to STDERR and always log, even if quiet=1
function e() {
  (echo >&2 -e "\e[31m$*\e[0m")
}

function die() {
  e "$@"
  exit 1
}

# check if string $1 begins with string $2
function beginsWith() {
  case "$1" in
    "$2"*) true ;;
    *) false ;;
  esac
}

# Ask for user confirmation
#
# Suppressing shellcheck warning as this is an _optional_ parameter
# shellcheck disable=SC2120
function confirm() {
  local msg

  msg="${1:-"Are you sure?"}"

  read -r -p "$msg [y/N] " response
  if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    l 'User aborted'
    exit 0
  fi
}
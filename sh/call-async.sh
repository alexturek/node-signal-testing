#!/usr/bin/env bash

set +e
set -x

COMMAND="${@}"

_terminate() {
  echo "Shell asked to $1"
  kill $(jobs -p)
  wait
  exit 0
}
trap '_terminate SIGTERM' SIGTERM
trap '_terminate SIGINT' SIGINT

$COMMAND &

wait

status=$?
exit $status

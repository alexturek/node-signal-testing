#!/usr/bin/env bash

set +e
set -x

_terminate() {
  echo "Shell asked to terminate"
  kill $(jobs -p)
  exit 0
}
trap _terminate SIGTERM

node sleep &

child=$!
wait $child

status=$?
exit $status

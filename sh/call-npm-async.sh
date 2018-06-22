#!/usr/bin/env bash

set +e
set -x

_terminate() {
  echo "Shell asked to terminate"
  kill $(jobs -p)
  wait
  exit 0
}
trap _terminate SIGTERM

npm run sleep &

wait

status=$?
exit $status

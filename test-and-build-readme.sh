#!/usr/bin/env bash
set -e

README_FILE=README.md

README_HEADER=$(
  cat << EOM
# Testing how to get signals into node processes

I don't really understand how signals and subprocesses work, so this is a "what actually happens" demo.

## Building this readme
\`\`\`sh
./test-and-build-readme.sh
\`\`\`

## Building the dockerfile
\`\`\`sh
docker build -t sleeptest .
\`\`\`

## Tests

-----

EOM
)

# Redirect (non-append) to reset the file
printf "$README_HEADER\n" > $README_FILE

# Get a fresh build
docker build -t sleeptest .

tests=$(cat tests.json)
MAX_TEST_INDEX=$(echo $tests | jq '. | length - 1')

set -x
set +e

for i in `seq 0 $MAX_TEST_INDEX`; do

  title=$(echo $tests | jq -r .[$i].title)
  command=$(echo $tests | jq -r .[$i].command)

  cmd_start_container="docker run -d --name test-container sleeptest $command"
  TEST_HEADER=$(cat << EOM
### $title

#### Run
\`\`\`sh
docker rm -f test-container
$cmd_start_container
sleep 1 ; docker stop -t 4 test-container
docker logs -n 50 test-container ; docker ps -a -f name=test-container --format "{{.Status}}"
\`\`\`

#### Output
\`\`\`
EOM
)
  printf "$TEST_HEADER\n" >> $README_FILE

  docker rm -f test-container
  $cmd_start_container
  start=$(date +%s)
  sleep 1 ; docker stop -t 4 test-container
  end=$(date +%s)

  raw_results=$(docker logs --tail 100 test-container ; docker ps -a -f name=test-container --format "{{.Status}}")
  printf "$raw_results\n" >> $README_FILE
  printf "\`\`\`\n\n#### Results\n" >> $README_FILE

  status=$(echo $raw_results | grep -o -P 'Exited \(\d+' | cut -d '(' -f 2)
  quickexit=no
  duration=`expr $end - $start`
  if [[ $duration < 5 ]] ; then quickexit=yes ; fi
  node_exit_messages=$(echo $raw_results | grep -c -P 'Node exiting')
  node_exited_itself=no
  if [[ "$node_exit_messages" > 0 ]] ; then node_exited_itself=yes ; fi

  RESULTS=$(cat << EOM
| Exit | Quickly? | Did sleep.js get a chance to do something? |
| --- | --- | --- |
| $status | $quickexit | $node_exited_itself |
EOM
)
  printf "$RESULTS\n\n-----\n" >> $README_FILE

done

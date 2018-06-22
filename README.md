# Testing how to get signals into node processes

I don't really understand how signals and subprocesses work, so this is a "what actually happens" demo.

## Building
```sh
docker build -t sleeptest .
```

## Tests

### Calling node directly in the docker container
```sh
docker rm -f test-container ; docker run -d --name test-container sleeptest node sleep
docker stop test-container
echo $?
```
I get: `0`

### Calling npm directly in the docker container
```sh
docker rm -f test-container ; docker run -d --name test-container sleeptest npm run sleep
docker stop test-container
echo $?
```
I get: ``

### Calling shell -> node in the docker container (blocking)
```sh
docker rm -f test-container ; docker run -d --name test-container sleeptest ./sh/call-node-sync.sh
docker stop test-container
echo $?
```
I get: ``

### Calling shell -> node in the docker container (blocking)
```sh
docker rm -f test-container ; docker run -d --name test-container sleeptest ./sh/call-npm-sync.sh
docker stop test-container
echo $?
```
I get: ``

### Calling shell -> node in the docker container (forked process)
```sh
docker rm -f test-container ; docker run -d --name test-container sleeptest ./sh/call-node-async.sh
docker stop test-container
echo $?
```
I get: ``

### Calling shell -> node in the docker container (forked process)
```sh
docker rm -f test-container ; docker run -d --name test-container sleeptest ./sh/call-npm-async.sh
docker stop test-container
echo $?
```
I get: ``

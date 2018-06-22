# Testing how to get signals into node processes

I don't really understand how signals and subprocesses work, so this is a "what actually happens" demo.

## Building
```sh
docker build -t sleeptest .
```

## Tests

### Calling node directly in the docker container
#### Run
```sh
docker rm -f test-container ; docker run -d --name test-container sleeptest node sleep
sleep 1 ; docker stop -t 4 test-container
docker logs test-container ; docker ps -a -f name=test-container --format "{{.Status}}"

```

#### Output
```
starting
.
.
Received sigterm
Exited (0) Less than a second ago
```

#### Results
| Exit | Quickly? | Did sleep.js get a chance to do something? |
| --- | --- | --- |
| 0 | yes | yes |

### Calling npm directly in the docker container

#### Run
```sh
docker rm -f test-container ; docker run -d --name test-container sleeptest npm run sleep
sleep 1 ; docker stop -t 4 test-container
docker logs test-container ; docker ps -a -f name=test-container --format "{{.Status}}"

```

#### Output
```
> signal-testing@1.0.0 sleep /sleeptest
> node sleep

starting
.
Exited (0) Less than a second ago
```

#### Results
| Exit | Quickly? | Did sleep.js get a chance to do something? |
| --- | --- | --- |
| 0 | yes | no |

### Calling shell -> node in the docker container (blocking)
#### Run
```sh
docker rm -f test-container ; docker run -d --name test-container sleeptest ./sh/call-node-sync.sh
sleep 1 ; docker stop -t 4 test-container
docker logs test-container ; docker ps -a -f name=test-container --format "{{.Status}}"

```

#### Output
```
+ node sleep
starting
.
.
.
.
.
.
.
.
.
.
Exited (137) Less than a second ago
```

#### Results
| Exit | Quickly? | Did sleep.js get a chance to do something? |
| --- | --- | --- |
| 137 | no | no |

### Calling shell -> node in the docker container (blocking)
#### Run
```sh
docker rm -f test-container ; docker run -d --name test-container sleeptest ./sh/call-npm-sync.sh
sleep 1 ; docker stop -t 4 test-container
docker logs test-container ; docker ps -a -f name=test-container --format "{{.Status}}"

```

#### Output
```
+ npm run sleep

> signal-testing@1.0.0 sleep /sleeptest
> node sleep

starting
.
.
.
.
.
.
.
.
.
Exited (137) Less than a second ago
```

#### Results
| Exit | Quickly? | Did sleep.js get a chance to do something? |
| --- | --- | --- |
| 137 | no | no |

### Calling shell -> node in the docker container (forked process)
#### Run
```sh
docker rm -f test-container ; docker run -d --name test-container sleeptest ./sh/call-node-async.sh
sleep 1 ; docker stop -t 4 test-container
docker logs test-container ; docker ps -a -f name=test-container --format "{{.Status}}"

```

#### Output
```
+ trap _terminate SIGTERM
+ child=6
+ wait 6
+ node sleep
starting
.
.
Shell asked to terminate
++ _terminate
++ echo 'Shell asked to terminate'
+++ jobs -p
++ kill 6
++ exit 0
Exited (0) Less than a second ago
```

#### Results
| Exit | Quickly? | Did sleep.js get a chance to do something? |
| --- | --- | --- |
| 0 | yes | no |

### Calling shell -> node in the docker container (forked process)
#### Run
```sh
docker rm -f test-container ; docker run -d --name test-container sleeptest ./sh/call-npm-async.sh
sleep 1 ; docker stop -t 4 test-container
docker logs test-container ; docker ps -a -f name=test-container --format "{{.Status}}"

```

#### Output
```
+ trap _terminate SIGTERM
+ child=7
+ wait 7
+ npm run sleep

> signal-testing@1.0.0 sleep /sleeptest
> node sleep

starting
.
++ _terminate
++ echo 'Shell asked to terminate'
+++ jobs -p
Shell asked to terminate
++ kill 7
++ exit 0
Exited (0) Less than a second ago
```

#### Results
| Exit | Quickly? | Did sleep.js get a chance to do something? |
| --- | --- | --- |
| 0 | yes | no |

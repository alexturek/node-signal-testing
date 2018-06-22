# Testing how to get signals into node processes

I don't really understand how signals and subprocesses work, so this is a "what actually happens" demo.

## Building this readme
```sh
./test-and-build-readme.sh
```

## Building the dockerfile
```sh
docker build -t sleeptest .
```

## Tests

-----
### Calling node directly in the docker container

#### Run
```sh
docker rm -f test-container
docker run -d --name test-container sleeptest node sleep
sleep 1 ; docker stop -t 4 test-container
docker logs -n 50 test-container ; docker ps -a -f name=test-container --format "{{.Status}}"
```

#### Output
```
starting
.
.
Node exiting
Exited (0) Less than a second ago
```

#### Results
| Exit | Quickly? | Did sleep.js get a chance to do something? |
| --- | --- | --- |
| 0 | yes | yes |

-----
### Calling npm directly in the docker container

#### Run
```sh
docker rm -f test-container
docker run -d --name test-container sleeptest npm run sleep
sleep 1 ; docker stop -t 4 test-container
docker logs -n 50 test-container ; docker ps -a -f name=test-container --format "{{.Status}}"
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

-----
### Calling shell -> node in the docker container (blocking)

#### Run
```sh
docker rm -f test-container
docker run -d --name test-container sleeptest ./sh/call-sync.sh node sleep
sleep 1 ; docker stop -t 4 test-container
docker logs -n 50 test-container ; docker ps -a -f name=test-container --format "{{.Status}}"
```

#### Output
```
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

-----
### Calling shell -> npm in the docker container (blocking)

#### Run
```sh
docker rm -f test-container
docker run -d --name test-container sleeptest ./sh/call-sync.sh npm run sleep
sleep 1 ; docker stop -t 4 test-container
docker logs -n 50 test-container ; docker ps -a -f name=test-container --format "{{.Status}}"
```

#### Output
```

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

-----
### Calling shell -> node in the docker container (forked process)

#### Run
```sh
docker rm -f test-container
docker run -d --name test-container sleeptest ./sh/call-async.sh node sleep
sleep 1 ; docker stop -t 4 test-container
docker logs -n 50 test-container ; docker ps -a -f name=test-container --format "{{.Status}}"
```

#### Output
```
starting
.
.
Shell asked to SIGTERM
Node exiting
Exited (0) Less than a second ago
```

#### Results
| Exit | Quickly? | Did sleep.js get a chance to do something? |
| --- | --- | --- |
| 0 | yes | yes |

-----
### Calling shell -> npm in the docker container (forked process)

#### Run
```sh
docker rm -f test-container
docker run -d --name test-container sleeptest ./sh/call-async.sh npm run sleep
sleep 1 ; docker stop -t 4 test-container
docker logs -n 50 test-container ; docker ps -a -f name=test-container --format "{{.Status}}"
```

#### Output
```

> signal-testing@1.0.0 sleep /sleeptest
> node sleep

starting
.
Shell asked to SIGTERM
Exited (0) Less than a second ago
```

#### Results
| Exit | Quickly? | Did sleep.js get a chance to do something? |
| --- | --- | --- |
| 0 | yes | no |

-----

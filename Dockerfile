FROM node
WORKDIR sleeptest
COPY ./sleep.js .
COPY ./sh ./sh
COPY ./package.json .

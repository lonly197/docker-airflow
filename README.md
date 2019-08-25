# docker-Airflow

This is a full [Docker](https://www.docker.com/what-docker) image for [Apache Airflow](https://airflow.apache.org).

```
                        ##         .
                  ## ## ##        ==
               ## ## ## ## ##    ===
           /"""""""""""""""""\___/ ===
      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
           \______ o Airflow  __/
             \    \         __/
              \____\_______/
```

## Overview

Dockerized single-host Airflow.

- Based on Python (3.7-slim-stretch) official Image python:3.7-slim-stretch and uses the official Postgres as backend and Redis as queue.
- Following the Airflow release from Python Package Index

## Build

```bash
docker build \
--rm \
-t lonly/docker-airflow \
--build-arg VCS_REF=`git rev-parse --short HEAD` \
--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` .
```

## Exposed ports

- 8080 - Airflow webservere port
- 5555 - Airflow flower port
- 8793 - Airflow celery distributed task queue port

## UI Links

- Airflow: [localhost:8080](http://localhost:8080/)
- Flower: [localhost:5555](http://localhost:5555/)

## Volumes

All below volumes can be mounted to docker host machine folders or shared folders to easy maintain data inside them.

Airflow-specific:
/usr/local/airflow

## Official Documentation and Guides

- [Overview](https://airflow.apache.org/index.html)
- [Quick Start](https://airflow.apache.org/start.html)
- [Tutorial](https://airflow.apache.org/tutorial.html)
- [Guides](https://airflow.apache.org/howto/index.html)

## Usage

By default, docker-airflow runs Airflow with `SequentialExecutor` :

```bash
docker run -d -p 8080:8080 --name airflow lonly/docker-airflow webserver
```

If you want to run another executor, use the other docker-compose.yml files provided in this repository.

For `LocalExecutor` :

```bash
docker-compose -f docker-compose-LocalExecutor.yml up -d
```

For `CeleryExecutor` :

```bash
docker-compose -f docker-compose-CeleryExecutor.yml up -d
```

## Pre-Requisites

Ensure the following pre-requisites are met (due to some blocker bugs in earlier versions). As of today, the latest Docker Toolbox and Homebrew are fine.

- Docker 1.10+
- Docker Machine 0.6.0+

(all downloadable as a single [Docker Toolbox](https://www.docker.com/products/docker-toolbox) package as well)

## How to use from Docker CLI

1. Start Docker Quickstart Terminal
2. Run command  `docker run -d -p 8080:8080 -p 8443:8443 --name Airflow lonly/docker-airflow`
3. Check Docker Contianer Running Status `docker ps -a`
4. Use IP from previous step in address bar of your favorite browser, e.g. ` http://192.168.1.1:8080/#/`

## Contact me

- Email: <lonly197@gamil.com>
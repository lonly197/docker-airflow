#!/usr/bin/env bash

docker build \
--rm \
-t lonly/docker-airflow \
--build-arg VCS_REF=`git rev-parse --short HEAD` \
--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` .
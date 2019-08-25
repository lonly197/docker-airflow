# VERSION 1.10.4
# AUTHOR: lonly(lonly197@qq.com)
# DESCRIPTION: Basic Airflow container
# BUILD: docker build --rm -t lonly/docker-airflow .
# SOURCE: https://github.com/lonly/docker-airflow

FROM python:3.7-slim-stretch

LABEL \
    maintainer="lonly197@qq.com" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="Apache License 2.0" \
    org.label-schema.name="lonly/docker-airflow" \
    org.label-schema.url="https://github.com/lonly197" \
    org.label-schema.description="This is a Docker image for Airflow." \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/lonly197/docker-airflow" \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vendor="lonly197@qq.com" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0"

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Airflow
ARG AIRFLOW_VERSION=1.10.4
ARG AIRFLOW_USER_HOME=/usr/local/airflow
ARG AIRFLOW_DEPS=""
ARG PYTHON_DEPS=""
ENV AIRFLOW_HOME=${AIRFLOW_USER_HOME}

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8

# 更新 apt-get 源
RUN echo \
    deb http://mirrors.aliyun.com/debian/ stretch main non-free contrib\
    deb-src http://mirrors.aliyun.com/debian/ stretch main non-free contrib\
    deb http://mirrors.aliyun.com/debian-security stretch/updates main\
    deb-src http://mirrors.aliyun.com/debian-security stretch/updates main\
    deb http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib\
    deb-src http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib\
    deb http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib\
    deb-src http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib\
    > /etc/apt/sources.list

# 设置 Pip 软件源
COPY ./config/pip.conf /etc/pip.conf

# 安装软件
RUN set -ex \
    && buildDeps=' \
    freetds-dev \
    libkrb5-dev \
    libsasl2-dev \
    libffi-dev \
    git \
    ' \
    && apt-get update -yqq \
    && apt-get upgrade -yqq \
    && apt-get install -yqq --no-install-recommends \
    $buildDeps \
    freetds-bin \
    build-essential \
    default-libmysqlclient-dev \
    apt-utils \
    vim \
    wget \
    curl \
    rsync \
    netcat \
    locales \
    && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && useradd -ms /bin/bash -d ${AIRFLOW_USER_HOME} airflow \
    && pip install -U pip setuptools wheel \
    && pip install --upgrade --ignore-installed six \
    && pip install pytz \
    && pip install pyOpenSSL \
    && pip install ndg-httpsclient \
    && pip install pyasn1 \
    && pip install --upgrade 'flask==1.0.4' \
    && pip install apache-airflow[crypto,celery,postgres,hive,hdfs,jdbc,mysql,ssh${AIRFLOW_DEPS:+,}${AIRFLOW_DEPS}]==${AIRFLOW_VERSION} \
    && pip install 'redis==3.2' \
    && if [ -n "${PYTHON_DEPS}" ]; then pip install ${PYTHON_DEPS}; fi \
    && apt-get purge --auto-remove -yqq $buildDeps \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /usr/share/man \
    /usr/share/doc \
    /usr/share/doc-base


WORKDIR ${AIRFLOW_USER_HOME}
RUN chown -R airflow: ${AIRFLOW_USER_HOME}

COPY script/entrypoint.sh /entrypoint.sh
COPY config/airflow.cfg ${AIRFLOW_USER_HOME}/airflow.cfg
COPY plugin/*.py ${AIRFLOW_USER_HOME}/plugins/

EXPOSE 8080 5555 8793

USER airflow
ENTRYPOINT ["/bin/sh","/entrypoint.sh"]
# set default arg for entrypoint
CMD ["webserver"]
FROM ubuntu:14.04
MAINTAINER devteam@level12.io

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# map to the source code of the app
VOLUME /opt/src
# map to the CI artificates directory
VOLUME /opt/src/.ci/artifacts
# map to the CI test reports directory
VOLUME /opt/src/.ci/test-reports

RUN    echo 'deb http://ppa.launchpad.net/fkrull/deadsnakes/ubuntu trusty main' >> /etc/apt/sources.list.d/python.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DB82666C \
    && apt-get update -q \
    && apt-get install -y curl git python3.6 python3.5 python2.7 libpython2.7 libpython3.6 libpython3.5 \
    && curl -fSL "https://bootstrap.pypa.io/get-pip.py" -o get-pip.py \
    && python2.7 get-pip.py \
    && python3.4 get-pip.py \
    && python3.5 get-pip.py \
    && python3.6 get-pip.py \
    && rm get-pip.py

# need these libraries for lxml & PyQuery
RUN apt-get update && apt-get install -y \
    libfreetype6 \
    libjpeg-turbo8 \
    libpq5 \
    libxml2 \
    libxslt1.1 \
    libffi6 \
    libcairo2 \
    libpango1.0 \
    libtiff5 \
    && rm -rf /var/lib/apt/lists/*

# Git LFS support since that is how new projects will handle wheels
RUN curl -fSL "https://github.com/git-lfs/git-lfs/releases/download/v2.2.1/git-lfs-linux-amd64-2.2.1.tar.gz" -o git-lfs.tar.gz \
    && tar -xzf git-lfs.tar.gz \
    && ./git-lfs-2.2.1/install.sh \
    && git lfs install \
    && rm -r git-lfs*

WORKDIR /opt/src
ENTRYPOINT ["/bin/bash", "/opt/src/docker-entry"]

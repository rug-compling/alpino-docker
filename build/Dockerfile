#
# Ubuntu 16 (xenial) met gcc en zo
#

FROM ubuntu:xenial

LABEL org.opencontainers.image.authors="Peter Kleiweg <p.c.j.kleiweg@rug.nl>"

RUN apt-get update && apt-get install -y tzdata && \
    echo "Europe/Amsterdam" > /etc/timezone && \
    rm -f /etc/localtime && \
    ln -fs /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN apt-get install -y \
  appstream \
  autoconf \
  automake \
  autopoint \
  binutils \
  bison \
  blt-dev \
  build-essential \
  cmake \
  curl \
  desktop-file-utils \
  flex \
  gettext \
  gfortran \
  git \
  less \
  libboost-all-dev \
  libfontconfig1-dev \
  libgraphviz-dev \
  liblzma-dev \
  libpng-dev \
  libssl-dev \
  libtool \
  libwebkit2gtk-4.0-dev \
  libwww-perl \
  libx11-dev \
  libxft-dev \
  libxml2-dev \
  libxslt1-dev \
  locales \
  man \
  mc \
  nano \
  python-dev \
  python3-dev \
  python3-lxml \
  python3-pip \
  qtbase5-dev \
  qttools5-dev-tools \
  squashfs-tools \
  sudo \
  tcl-dev \
  tk-dev \
  unzip \
  vim \
  wget

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
RUN apt-get install git-lfs=3.2.0

ADD https://go.dev/dl/go1.22.0.linux-amd64.tar.gz /
RUN cd / && tar vzxf go*tar.gz --no-same-owner && rm go*tar.gz

ENV GOCACHE=/cache/go/cache
ENV GOPATH=/cache/go
ENV LIBGL_ALWAYS_INDIRECT=1

ADD init.sh /

CMD ["/bin/bash", "--rcfile", "/init.sh"]

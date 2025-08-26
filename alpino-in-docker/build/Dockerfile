#
# Alpino in Docker
#
# To build and push to repository:
#
#     docker build -t registry.webhosting.rug.nl/compling/alpino:latest .
#     docker push registry.webhosting.rug.nl/compling/alpino:latest
#

FROM ubuntu:jammy

LABEL org.opencontainers.image.authors="Peter Kleiweg <p.c.j.kleiweg@rug.nl>"

RUN apt-get update && \
  apt-get install -y tzdata && \
  echo "Etc/UTC" > /etc/timezone && \
  rm -f /etc/localtime && \
  ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update && apt-get install -y \
  curl \
  emacs \
  less \
  libboost-filesystem1.74.0 \
  libboost-system1.74.0 \
  libcgraph6 \
  libgvc6 \
  libqt5network5 \
  libqt5printsupport5 \
  libwebkit2gtk-4.0 \
  libxslt1.1 \
  locales \
  man \
  mc \
  nano \
  python3 \
  python3-lxml \
  tk \
  unzip \
  vim

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV PATH=/Alpino/bin:/Alpino/Tokenization:/opt/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV ALPINO_HOME=/Alpino
ENV HOME=/work
ENV LANG=en_US.utf8
ENV LANGUAGE=en_US.utf8
ENV LC_ALL=en_US.utf8

# Extensions for TrEd
ADD https://www.let.rug.nl/vannoord/alp/Alpino/tred/alpino.zip /
ADD https://www.let.rug.nl/vannoord/alp/Alpino/tred/alpino_full.zip /
RUN mkdir -p /work/.tred.d/extensions/alpino && \
    mkdir    /work/.tred.d/extensions/alpino_full && \
    unzip -d /work/.tred.d/extensions/alpino /alpino.zip && \
    unzip -d /work/.tred.d/extensions/alpino_full /alpino_full.zip && \
    rm /alpino.zip /alpino_full.zip && \
    echo  alpino        >   /work/.tred.d/extensions/extensions.lst && \
    echo '!alpino_full' >>  /work/.tred.d/extensions/extensions.lst

# TrEd
ADD .tredrc /work
RUN chmod ugo+rw /work /work/.tredrc && \
    find /work/.tred.d | xargs chmod ugo+rw && \
    find /work/.tred.d -type d | xargs chmod ugo+x && \
    echo Bookmarks >  /work/.tred_bookmarks && \
    echo Bookmarks >> /work/.tred_bookmarks && \
    chmod ugo+rw /work/.tred_bookmarks

# TODO: symlinks

ENV ALTO_MACROFILE=/work/voorbeelden/macros.txt
ADD weerbericht.txt macros.txt /work/voorbeelden/
ADD init.sh /
ADD emacs /usr/local/bin
RUN chmod +x /usr/local/bin/emacs

ENV LD_LIBRARY_PATH=/Alpino/fadd:/Alpino/TreebankTools/IndexedCorpus

# voor probleem met alpinoviewer
ENV NO_AT_BRIDGE=1

# voor probleem met dact
ENV LIBGL_ALWAYS_INDIRECT=1

ADD opt /opt

ADD Alpino.tar.gz /
ADD dttred /Alpino/bin
RUN chmod +x /Alpino/bin/dttred && \
    find /Alpino -name '.nfs*' | xargs rm -f && \
    ldconfig /Alpino/fadd /Alpino/unix /Alpino/TreebankTools/IndexedCorpus && \
    cd /Alpino/create_bin && \
    rm -fr extralibs && \
    grep -v TCL_LIBRARY env.sh | grep -v TK_LIBRARY > env.sh.tmp && \
    mv env.sh.tmp env.sh

RUN mv /usr/bin/man.REAL /usr/bin/man

CMD ["/bin/bash", "--rcfile", "/init.sh"]

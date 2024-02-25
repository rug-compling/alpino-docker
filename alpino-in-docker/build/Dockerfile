#
# Alpino in Docker
#
# To build and push to repository:
#
#     docker build -t registry.webhosting.rug.nl/compling/alpino:latest .
#     docker push registry.webhosting.rug.nl/compling/alpino:latest
#

FROM ubuntu:xenial

MAINTAINER Peter Kleiweg <p.c.j.kleiweg@rug.nl>

# Bij overstap naar nieuwere Ubuntu invoegen:
#RUN apt-get update && apt-get install -y tzdata && \
#    echo "Etc/UTC" > /etc/timezone && \
#    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
#    dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update && apt-get install -y \
  cpanminus \
  curl \
  emacs \
  less \
  libboost-filesystem1.58.0 \
  libboost-system1.58.0 \
  libcgraph6 \
  libgvc6 \
  libqt5network5 \
  libqt5printsupport5 \
  libwebkit2gtk-4.0 \
  libwww-perl \
  libxslt1.1 \
  locales \
  man \
  mc \
  nano \
  python \
  python-lxml \
  python3 \
  python3-lxml \
  tk \
  unzip \
  vim

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV PATH /Alpino/bin:/Alpino/Tokenization:/opt/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV ALPINO_HOME /Alpino
ENV HOME /work
ENV LANG en_US.utf8
ENV LANGUAGE en_US.utf8
ENV LC_ALL en_US.utf8

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
ADD tred_2.5236_all.deb /
RUN cpanm XML::CompactTree UNIVERSAL::DOES XML::CompactTree::XS Treex::PML && \
    apt-get install -y /tred_2.5236_all.deb && \
    rm /tred_2.5236_all.deb
#RUN echo 2.5049 > /work/.tred.d/last_version
RUN echo 2.5236 > /work/.tred.d/last_version
ADD .tredrc /work
RUN chmod ugo+rw /work /work/.tredrc && \
    find /work/.tred.d | xargs chmod ugo+rw && \
    find /work/.tred.d -type d | xargs chmod ugo+x && \
    echo Bookmarks >  /work/.tred_bookmarks && \
    echo Bookmarks >> /work/.tred_bookmarks && \
    chmod ugo+rw /work/.tred_bookmarks

# TODO: symlinks

ADD weerbericht.txt macros.txt /work/voorbeelden/
ADD init.sh /
ADD emacs /usr/local/bin
RUN chmod +x /usr/local/bin/emacs

ENV LD_LIBRARY_PATH /Alpino/fadd:/Alpino/TreebankTools/IndexedCorpus

# voor probleem met alpinoviewer
ENV NO_AT_BRIDGE 1

# voor probleem met dact
ENV LIBGL_ALWAYS_INDIRECT 1

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

CMD ["/bin/bash", "--rcfile", "/init.sh"]

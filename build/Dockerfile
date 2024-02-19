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

# Downloading the index triggers a new download of Alpino when anything in the index has changed
ADD https://www.let.rug.nl/vannoord/alp/Alpino/versions/binary/ /index
RUN cd / && rm index && \
    curl -s https://www.let.rug.nl/vannoord/alp/Alpino/versions/binary/latest.tar.gz | tar --no-same-owner -vxzf -

# Remove stale nfs files
RUN find /Alpino -name '.nfs*' | xargs rm -f

# Add libraries to standard path
RUN ldconfig /Alpino/boost /Alpino/fadd /Alpino/unix /Alpino/TreebankTools/IndexedCorpus

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
ADD dttred /Alpino/bin
# Downloading the index triggers a new download of sources when anything in the index has changed
ADD https://www.let.rug.nl/alfa/docker/alpino/ /index
RUN rm /index && cd / && curl -s https://www.let.rug.nl/alfa/docker/alpino/TrEd.tar.gz | tar --no-same-owner -vxzf - && \
    echo 2.5049 > /work/.tred.d/last_version && \
    chmod +x /Alpino/bin/dttred
ADD .tredrc /work
RUN chmod ugo+rw /work /work/.tredrc && \
    find /work/.tred.d | xargs chmod ugo+rw && \
    find /work/.tred.d -type d | xargs chmod ugo+x && \
    cd /usr/local/bin && \
    ln -s /TrEd/bin/start_tred tred && \
    ln -s /TrEd/bin/start_tred Tred && \
    ln -s /TrEd/bin/start_btred btred && \
    ln -s /TrEd/bin/start_ntred ntred && \
    echo Bookmarks >  /work/.tred_bookmarks && \
    echo Bookmarks >> /work/.tred_bookmarks && \
    chmod ugo+rw /work/.tred_bookmarks

# DbXML, alpinocorpus
RUN curl -s https://www.let.rug.nl/alfa/docker/alpino/dbxml.tar.gz | tar --no-same-owner -vxzf - && \
    curl -s https://www.let.rug.nl/alfa/docker/alpino/dbxml_tools.tar.gz | tar --no-same-owner -vxzf - && \
    curl -s https://www.let.rug.nl/alfa/docker/alpino/alpinocorpus.tar.gz | tar --no-same-owner -vxzf -

# Dact
RUN curl -s https://www.let.rug.nl/alfa/docker/alpino/dact.tar.gz | tar --no-same-owner -vxzf -

# symlinks
RUN curl -s https://www.let.rug.nl/alfa/docker/alpino/bin.tar.gz | tar --no-same-owner -vxzf -

ADD weerbericht.txt macros.txt /work/voorbeelden/
ADD init.sh /
ADD emacs /usr/local/bin
RUN chmod +x /usr/local/bin/emacs

ENV LD_LIBRARY_PATH /Alpino/fadd:/Alpino/TreebankTools/IndexedCorpus

ADD alpinoviewer alpinoviewer_v6 alparse info to2 to6 /opt/bin/
ADD help/* /opt/info/

RUN cd /Alpino/create_bin && rm -fr extralibs && grep -v TCL_LIBRARY env.sh | grep -v TK_LIBRARY > env.sh.tmp && mv env.sh.tmp env.sh

CMD ["/bin/bash", "--rcfile", "/init.sh"]

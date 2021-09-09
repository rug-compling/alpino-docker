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

RUN apt-get update && apt-get install -y \
  curl \
  emacs \
  less \
  libtcl8.6 \
  libtk8.6 \
  libwww-perl \
  libxslt1.1 \
  locales \
  man \
  nano \
  netsurf \
  python \
  python-lxml \
  python-libxml2 \
  python-libxslt1 \
  tk \
  unzip \
  vim

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV PATH /Alpino/bin:/Alpino/Tokenization:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV ALPINO_HOME /Alpino
ENV BROWSER netsurf
ENV HOME /work
ENV LANG en_US.utf8
ENV LANGUAGE en_US.utf8
ENV LC_ALL en_US.utf8

# Downloading the index triggers a new download of Alpino when anything in the index has changed
ADD http://www.let.rug.nl/vannoord/alp/Alpino/versions/binary/ /index
RUN cd / && rm index && \
    curl -s http://www.let.rug.nl/vannoord/alp/Alpino/versions/binary/latest.tar.gz | tar --no-same-owner -vxzf -

# Remove stale nfs files
RUN find /Alpino -name '.nfs*' | xargs rm -f

# Add libraries to standard path
RUN ldconfig /Alpino/boost /Alpino/fadd /Alpino/unix /Alpino/TreebankTools/IndexedCorpus

# Extensions for TrEd
ADD http://www.let.rug.nl/vannoord/alp/Alpino/tred/alpino.zip /
ADD http://www.let.rug.nl/vannoord/alp/Alpino/tred/alpino_full.zip /
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
ADD http://www.let.rug.nl/alfa/docker/alpino/ /index
RUN rm /index && cd / && curl -s http://www.let.rug.nl/alfa/docker/alpino/TrEd.tar.gz | tar --no-same-owner -vxzf - && \
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

ADD weerbericht.txt /work/voorbeelden/
ADD init.sh /
ADD info.html /work/
ADD Choices /work/.config/netsurf/
ADD emacs /usr/local/bin
RUN chmod +x /usr/local/bin/emacs && \
    chmod 777 /work/.config/netsurf && \
    chmod 666 /work/.config/netsurf/Choices && \
    cd /usr/local/bin && \
    ln -s /usr/bin/netsurf netscape

ENV LD_LIBRARY_PATH :/Alpino/util:/Alpino/Tokenization:/Alpino/fadd:/Alpino/TreebankTools/IndexedCorpus:/Alpino/create_bin:/Alpino/util:/Alpino/create_bin/extralibs:/Alpino/create_bin/extralibs/boost
ENV TCL_LIBRARY /Alpino/create_bin/extralibs/tcl8.5
ENV TK_LIBRARY /Alpino/create_bin/extralibs/tk8.5

CMD ["/bin/bash", "--rcfile", "/init.sh"]

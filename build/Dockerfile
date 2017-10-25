#
# Alpino in Docker
#
# To build and push to docker hub:
#
#     docker build -t rugcompling/alpino:latest .
#     docker push rugcompling/alpino:latest
#

FROM debian:8

MAINTAINER Peter Kleiweg <p.c.j.kleiweg@rug.nl>

RUN apt-get update && apt-get install -y \
  curl \
  less \
  libtcl8.5 \
  libtk8.5 \
  libwww-perl \
  libxslt1.1 \
  locales \
  man \
  nano \
  python \
  python-libxml2 \
  python-libxslt1 \
  tk \
  unzip \
  vim

RUN sed -e 's/^# en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen > /etc/locale.gen.tmp && \
    mv /etc/locale.gen.tmp /etc/locale.gen && \
    locale-gen

ENV PATH /Alpino/bin:/Alpino/Tokenization:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV ALPINO_HOME /Alpino
ENV LANG en_US.utf8
ENV LANGUAGE en_US.utf8
ENV LC_ALL en_US.utf8
ENV LD_LIBRARY_PATH /Alpino/create_bin

# Downloading the index triggers a new download of Alpino when anything in the index has changed
ADD http://www.let.rug.nl/vannoord/alp/Alpino/versions/binary/ /index
RUN cd / && rm index && \
    curl -s http://www.let.rug.nl/vannoord/alp/Alpino/versions/binary/latest.tar.gz | tar vxzf -

# Remove stale nfs files
RUN find /Alpino -name '.nfs*' | xargs rm -f

# Add libraries to standard path
RUN ldconfig /Alpino/boost /Alpino/fadd /Alpino/TreebankTools/IndexedCorpus

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
RUN cd / && curl -s http://www.let.rug.nl/alfa/docker/alpino/TrEd.tar.gz | tar vxzf - && \
    echo 2.5049 > /work/.tred.d/last_version && \
    sed -e 's!@@@TRED_EXECUTABLE@@@!/TrEd/bin/start_tred!' < /Alpino/TreebankTools/bin/dttred.in > Alpino/bin/dttred
ADD .tredrc /work
RUN chmod ugo+rw /work /work/.tredrc && \
    find /work/.tred.d | xargs chmod ugo+rw && \
    find /work/.tred.d -type d | xargs chmod ugo+x && \
    cd /usr/local/bin && \
    ln -s /TrEd/bin/start_tred tred && \
    ln -s /TrEd/bin/start_btred btred && \
    ln -s /TrEd/bin/start_ntred ntred

ADD weerbericht.txt /work/voorbeelden/

RUN echo "alias ll='ls -Fla'" >  /init.sh && \
    echo "alias rm='rm -i'"   >> /init.sh && \
    echo "PS1='[Alpino] \w '" >> /init.sh && \
    echo 'HOME=/work'         >> /init.sh && \
    echo 'cd ~/data'          >> /init.sh

CMD ["/bin/bash", "--rcfile", "/init.sh"]

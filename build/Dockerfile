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
  libtcl8.5 \
  libtk8.5 \
  libwww-perl \
  libxslt1.1 \
  locales \
  man \
  python \
  python-libxml2 \
  python-libxslt1 \
  tk

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

# Remove incompatible libs
RUN rm -f /Alpino/create_bin/libtcl* /Alpino/create_bin/libtk*
RUN rm -rf /Alpino/create_bin/tcl8.5 /Alpino/create_bin/tk8.5

# Remove stale nfs files
RUN find /Alpino -name '.nfs*' | xargs rm -f

# TrEd
RUN cd / && curl -s http://www.let.rug.nl/alfa/docker/alpino/TrEd.tar.gz | tar vxzf -
RUN mkdir -p /work/.tred.d/extensions/alpino/contrib/alpino && \
    mkdir    /work/.tred.d/extensions/alpino/resources && \
    echo alpino > /work/.tred.d/extensions/extensions.lst && \
    cp /Alpino/TreebankTools/TrEd/alpino.mak /work/.tred.d/extensions/alpino/contrib/alpino && \
    cp /Alpino/TreebankTools/TrEd/contrib.mac /work/.tred.d/extensions/alpino/contrib/alpino && \
    cp /Alpino/TreebankTools/TrEd/pmlbackend_conf.xml /work/.tred.d/extensions/alpino/resources/pmlbackend_conf.inc && \
    cp /Alpino/TreebankTools/TrEd/alpino2pml.xsl /work/.tred.d/extensions/alpino/resources && \
    cp /Alpino/TreebankTools/TrEd/alpino_schema.xml /work/.tred.d/extensions/alpino/resources && \
    cp /Alpino/TreebankTools/TrEd/pml2alpino.xsl /work/.tred.d/extensions/alpino/resources && \
    echo 2.5049 > /work/.tred.d/last_version && \
    sed -e 's!@@@TRED_EXECUTABLE@@@!/TrEd/bin/start_tred!' < /Alpino/TreebankTools/bin/dttred.in > Alpino/bin/dttred
ADD .tredrc /work
ADD package.xml /work/.tred.d/extensions/alpino/
RUN chmod go+w /work /work/.tredrc && \
    find /work/.tred.d | xargs chmod go+w

ADD weerbericht.txt /work/voorbeelden/

RUN echo "alias ll='ls -Fla'" >  /init.sh && \
    echo "alias rm='rm -i'"   >> /init.sh && \
    echo "PS1='[Alpino] \w '" >> /init.sh && \
    echo 'HOME=/work'         >> /init.sh && \
    echo 'cd ~/data'          >> /init.sh

CMD ["/bin/bash", "--rcfile", "/init.sh"]

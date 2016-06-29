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
  locales \
  man

RUN sed -e 's/^# en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen > /etc/locale.gen.tmp && \
    mv /etc/locale.gen.tmp /etc/locale.gen && \
    locale-gen

ENV PATH /Alpino/bin:/Alpino/Tokenization:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV ALPINO_HOME /Alpino
ENV LANG en_US.utf8
ENV LANGUAGE en_US.utf8
ENV LC_ALL en_US.utf8

# Downloading the index triggers a new download of Alpino when anything in the index has changed
ADD http://www.let.rug.nl/vannoord/alp/Alpino/versions/binary/ /index
RUN cd / && rm index && \
    curl -s http://www.let.rug.nl/vannoord/alp/Alpino/versions/binary/latest.tar.gz | tar vxzf -

# Remove incompatible libs
RUN rm -f /Alpino/create_bin/libtcl* /Alpino/create_bin/libtk*

# Remove stale nfs files
RUN find /Alpino -name '.nfs*' | xargs rm -f

ADD voorbeelden/weerbericht.txt /work/voorbeelden/

RUN echo "alias ll='ls -Fla'" >  /init.sh && \
    echo "alias rm='rm -i'"   >> /init.sh && \
    echo "PS1='[Alpino] \w '" >> /init.sh && \
    echo 'HOME=/work'         >> /init.sh && \
    echo 'cd ~/data'          >> /init.sh

CMD ["/bin/bash", "--rcfile", "/init.sh"]

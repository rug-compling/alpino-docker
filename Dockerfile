
FROM debian:8

MAINTAINER Peter Kleiweg <p.c.j.kleiweg@rug.nl>

RUN apt-get update && apt-get install -y \
  libtcl8.5 \
  libtk8.5 \
  locales \
  man

RUN sed -e 's/^# en_US.UTF-8'/en_US.UTF-8'/' /etc/locale.gen > /etc/locale.gen.tmp && \
    mv /etc/locale.gen.tmp /etc/locale.gen && \
    locale-gen

ENV PATH /Alpino/bin:/Alpino/Tokenization:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV ALPINO_HOME /Alpino
ENV LANG en_US.utf8
ENV LANGUAGE en_US.utf8
ENV LC_ALL en_US.utf8

ADD http://www.let.rug.nl/vannoord/alp/Alpino/versions/binary/latest.tar.gz /alpino.tar.gz
RUN cd / && tar vxzf alpino.tar.gz && rm -f alpino.tar.gz

# remove incompatible libs
RUN rm -f /Alpino/create_bin/libtcl* /Alpino/create_bin/libtk*

# remove stale nfs files
RUN find /Alpino -name '.nfs*' | xargs rm -f

RUN echo 'alias ll="ls -Fla"' >  /init.sh && \
    echo 'alias rm="rm -i"'   >> /init.sh && \
    echo "PS1='[Alpino] \w '" >> /init.sh && \
    echo 'HOME=/work'         >> /init.sh && \
    echo 'cd ~/data'          >> /init.sh

ENTRYPOINT ["/bin/bash", "--rcfile", "/init.sh"]

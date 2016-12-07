FROM prana/centos7

ENV OO_HOME /home/prana
ENV INDUCTOR_HOME /opt/prana
ENV GITHUB_URL https://github.com/prana
VOLUME ${OO_HOME}
VOLUME ${INDUCTOR_HOME}/inductor

WORKDIR /opt
COPY inductor.ini /etc/supervisord.d/inductor.ini
COPY inductor.sh inductor.sh
WORKDIR ${INDUCTOR_HOME}/inductor

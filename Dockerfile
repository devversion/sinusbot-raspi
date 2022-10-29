FROM amd64/ubuntu:latest

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y python3 x11vnc xvfb libxcursor1 ca-certificates curl bzip2 libglib2.0-0 \
      libnss3 libegl1-mesa x11-xkb-utils libasound2 libpci3 libxslt1.1 libxkbcommon0 libxss1 libxcomposite1

ADD https://files.teamspeak-services.com/releases/client/3.5.6/TeamSpeak3-Client-linux_amd64-3.5.6.run \
    /opt/ts3/install_script.run

RUN cd /opt/ts3/ && \
    chmod 777 ./install_script.run && \
    ./install_script.run --tar xvf .

RUN addgroup --gid 5000 botgrp && \
    useradd bot --shell /bin/bash --no-create-home && \
    adduser bot botgrp && \
    mkdir -p /opt/sinusbot && \
    chown -R bot:botgrp /opt/sinusbot && \
    chown -R bot:botgrp /opt/ts3

# youtube-dl expects "python"
RUN ln -s /usr/bin/python3 /usr/bin/python

USER bot

ADD --chown=bot https://www.sinusbot.com/dl/sinusbot.current.tar.bz2 /opt/sinusbot/
COPY --chown=bot ./config.ini /opt/sinusbot/config.ini

RUN cd /opt/sinusbot/ && \
    tar -xvf ./sinusbot.current.tar.bz2 && \
    mkdir /opt/ts3/plugins && \
    cp ./plugin/libsoundbot_plugin.so /opt/ts3/plugins/

ADD --chown=bot https://yt-dl.org/downloads/latest/youtube-dl /opt/sinusbot/
RUN chmod 777 /opt/sinusbot/youtube-dl

VOLUME /opt/sinusbot/data
VOLUME /opt/sinusbot/scripts

ENTRYPOINT ["/opt/sinusbot/sinusbot"]

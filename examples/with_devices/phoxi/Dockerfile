FROM ghcr.io/ca-giken/rosnoetic-base:main

# PhoXiControl
ENV PHOXI_CONTROL_PATH=/opt/Photoneo/PhoXiControl
RUN add-apt-repository universe && apt-get update -q \
    && apt-get install -y avahi-utils libqt5core5a libqt5dbus5 libqt5gui5 libgtk2.0-0 libssl1.0.0 libgomp1 libpcre16-3 libflann-dev libssh2-1-dev libpng16-16 libglfw3-dev xcb \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

COPY ./phoxi/PhotoneoPhoXiControlInstaller-1.2.35-Ubuntu16-STABLE.run /tmp/phoxi.run
COPY ./phoxi/PhoXiControl /usr/local/bin/PhoXiControl
ENV PHOXI_CONTROL_PATH="/opt/Photoneo/PhoXiControl"
RUN set -eux \
    && cd /tmp \
    && chmod a+x phoxi.run \
    && ./phoxi.run --accept ${PHOXI_CONTROL_PATH} \
    && rm -rf phoxi.run
RUN set -eux \
    && mkdir /root/.PhotoneoPhoXiControl

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the entrypoint
COPY ./entrypoint.sh /root/entrypoint.sh
ENTRYPOINT ["/bin/bash", "-c", "/root/entrypoint.sh"]

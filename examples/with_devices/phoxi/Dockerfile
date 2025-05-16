FROM ubuntu:16.04

WORKDIR /root/

ENV DEBIAN_FRONTEND=noninteractive

# Upgrade Packages
RUN apt-get update -q \
    && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Utility packages
RUN apt-get update -q \
    && apt-get install -y software-properties-common \
    && add-apt-repository universe && apt-get update -q \
    && apt-get install -y git build-essential wget curl vim sudo lsb-release locales \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install X11 requirements
RUN apt-get update -q && apt-get install -y \
    iputils-ping telnet x11-apps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python
RUN add-apt-repository universe && \
    apt-get update -q && apt-get install -y \
    python3-pip python3-dev python3-tk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install ROS
ENV ROS_DISTRO kinetic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
RUN apt-get update -q \
    && apt-get install -y ros-kinetic-desktop-full \
    && apt-get install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential python-catkin-tools\
    && rosdep init \
    && rosdep update \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# PhoXiControl
ENV PHOXI_CONTROL_PATH=/opt/Photoneo/PhoXiControl
RUN add-apt-repository universe && apt-get update -q \
    && apt-get install -y avahi-utils libqt5core5a libqt5dbus5 libqt5gui5 libgtk2.0-0 libssl1.0.0 libgomp1 libpcre16-3 libflann-dev libssh2-1-dev libpng16-16 libglfw3-dev xcb \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean
COPY ./PhotoneoPhoXiControlInstaller-1.2.35-Ubuntu16-STABLE.run /tmp/phoxi.run
COPY ./PhoXiControl /usr/local/bin/PhoXiControl
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

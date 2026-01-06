FROM ubuntu:focal-20240427 as rosnoetic_slim

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
RUN apt-get update -q && apt-get install -y \
    python3.8 python3-pip python3-dev python3-tk python-is-python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install ROS
ENV ROS_DISTRO=noetic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
RUN apt-get update -q \
    && apt-get install -y ros-noetic-desktop-full \
    && apt-get install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential python3-catkin-tools \
    && rosdep init \
    && rosdep update \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Setting for Japanese
RUN apt-get update -q && apt-get install -y \
    tzdata locales fonts-noto-cjk fcitx-mozc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN ln -s -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    dpkg-reconfigure tzdata && \
    locale-gen ja_JP.UTF-8

# Set user
ARG UID=1000
RUN useradd -m -u ${UID} ros

# Bash configuration
RUN sh -c 'echo "export PYTHONPATH=/usr/local/lib/python3.8/dist-packages:$PYTHONPATH" >> ~/.bashrc'
RUN sh -c 'echo "export ROS_HOSTNAME=localhost" >> ~/.bashrc'
RUN sh -c 'echo "export ROS_MASTER_URI=http://localhost:11311" >> ~/.bashrc'
RUN sh -c 'echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc'
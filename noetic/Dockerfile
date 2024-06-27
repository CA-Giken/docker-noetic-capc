FROM ubuntu:focal-20240427

# Docker実行してシェルに入ったときの初期ディレクトリ（ワークディレクトリ）の設定
WORKDIR /app/

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
    && apt-get install -y git build-essential wget curl vim sudo lsb-release locales
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install X11 requirements
RUN apt-get update -q && apt-get install -y \
    iputils-ping telnet x11-apps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python
RUN apt-get update -q && apt-get install -y \
    python3.8.10 python3-pip python3-dev python3-tk python-is-python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install ROS
ENV ROS_DISTRO noetic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
RUN apt-get update -q \
    && apt-get install -y ros-noetic-desktop-full \
    && apt-get install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential python3-catkin-tools \
    && rosdep init \
    && rosdep update \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Python packages
RUN python3 -m pip install PySimpleGUI pytk tkfilebxrowser pymsgbox
RUN python3 -m pip install open3d==0.11.1

# for rviz_animted_view_controller
RUN apt-get update -q && apt-get install -y \
    qt5-default qtscript5-dev libqwt-qt5-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Rovi setup(Aravis)
ENV LIBGL_ALWAYS_SOFTWARE=1
ENV ORGE_RTT_MODE=Copy
RUN apt-get update -q && apt-get install -y \
    g++ automake intltool libgstreamer*-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN wget http://ftp.gnome.org/pub/GNOME/sources/aravis/0.6/aravis-0.6.0.tar.xz
RUN tar -xvf aravis-0.6.0.tar.xz
RUN cd aravis-0.6.0 && ./configure && make && make install

# Install Eigen3
RUN apt-get update -q && apt-get install -y \
    && libeigen3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Node.js setup
RUN apt-get update && apt-get install -y \
    && nodejs npm \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*
RUN npm install -g n
RUN n 16.20.2
RUN npm install rosnodejs js-yaml mathjs terminate ping

# CAPC
RUN python3 -m pip install pyserial

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

RUN sh -c 'echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc'
RUN sh -c 'echo "export ROS_HOSTNAME=localhost" >> ~/.bashrc'
RUN sh -c 'echo "export ROS_MASTER_URI=http://localhost:11311" >> ~/.bashrc'
RUN sh -c 'echo "export NODE_PATH=/usr/lib/node_modules" >> ~/.bashrc'
RUN sh -c 'echo "export PYTHONPATH=/usr/local/lib/python3.8/dist-packages:$PYTHONPATH" >> ~/.bashrc'


# Command copy
# COPY ./entrypoint.sh /app/
# RUN chmod +x /app/entrypoint.sh
# CMD ["/bin/sh", "-c", "./entrypoint.sh"]

# YCAM3D Setup
RUN pip install scipy
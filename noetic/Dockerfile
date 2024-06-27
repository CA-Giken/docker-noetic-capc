FROM ubuntu:focal-20240427

# Docker実行してシェルに入ったときの初期ディレクトリ（ワークディレクトリ）の設定
WORKDIR /app/

ENV DEBIAN_FRONTEND=noninteractive

# Upgrade Packages
RUN apt-get update -q \
    && apt-get upgrade -y

# Utility packages
RUN apt-get update -q \
    && apt-get install -y software-properties-common \
    && add-apt-repository universe && apt-get update \
    && apt-get install -y git build-essential wget curl vim sudo lsb-release locales

# Install X11 requirements
RUN apt-get install -y iputils-ping telnet x11-apps

# Install Python
RUN apt-get install -y python3 python3-pip python3-dev python3-tk
# Symbolic link
RUN apt-get install -y python-is-python3

# Install ROS
ENV ROS_DISTRO noetic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
RUN apt-get update -q \
    && apt-get install -y ros-noetic-desktop-full \
    && apt-get install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential python3-catkin-tools \
    && rosdep init \
    && rosdep update

# Python packages
RUN python3 -m pip install PySimpleGUI pytk tkfilebrowser pymsgbox
RUN python3 -m pip install open3d

# for rviz_animted_view_controller
RUN apt-get install -y qt5-default qtscript5-dev libqwt-qt5-dev

# Rovi setup
ENV LIBGL_ALWAYS_SOFTWARE=1
ENV ORGE_RTT_MODE=Copy
RUN apt-get install -y automake intltool libgstreamer*-dev
RUN wget http://ftp.gnome.org/pub/GNOME/sources/aravis/0.6/aravis-0.6.0.tar.xz
RUN tar -xvf aravis-0.6.0.tar.xz
RUN cd aravis-0.6.0 && ./configure && make && make install

# CAPC
RUN pip install pyserial

# Setting for Japanese
RUN apt-get install -y tzdata locales fonts-noto-cjk fcitx-mozc
RUN ln -s -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    dpkg-reconfigure tzdata && \
    locale-gen ja_JP.UTF-8

# Set user
ARG UID=1000
RUN useradd -m -u ${UID} ros

# Clean up
RUN apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN sh -c 'echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc'

# Command copy
# COPY ./entrypoint.sh /app/
# RUN chmod +x /app/entrypoint.sh
# CMD ["/bin/sh", "-c", "./entrypoint.sh"]
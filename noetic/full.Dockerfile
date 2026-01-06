ARG REGISTRY=ghcr.io
ARG OWNER=ca-giken
FROM ${REGISTRY}/${OWNER}/rosnoetic-base:main

ENV DEBIAN_FRONTEND=noninteractive

# Install Eel
RUN pip install eel
RUN apt-get update \
    && apt-get install -y chromium-browser libgtk2.0-0 libgtk-3-0 libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb libgbm-dev fonts-ipafont \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN apt-get update \
    && apt-get install -y net-tools \
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

# Rovi_industrial setup
RUN pip install git+https://github.com/UniversalRobots/RTDE_Python_Client_Library.git

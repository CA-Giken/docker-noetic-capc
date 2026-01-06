ARG REGISTRY=ghcr.io
ARG OWNER=ca-giken
FROM ${REGISTRY}/${OWNER}/rosnoetic-slim:main

ENV DEBIAN_FRONTEND=noninteractive

# Open3d - AMD64のみプレビルドwheelをインストール、ARM64はユーザーが必要に応じてビルド
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        echo "Installing Open3D 0.13.0 prebuilt wheel for AMD64"; \
        pip install open3d==0.13.0; \
    else \
        echo "Skipping Open3D installation for ARM64. Users can build from source if needed."; \
    fi

RUN pip install scipy

# Node.js setup
RUN apt-get update && apt-get install -y \
    nodejs npm \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*
RUN npm install -g n
RUN n 16.20.2
RUN apt-get purge -y nodejs npm && apt-get autoremove -y
RUN npm install -g rosnodejs js-yaml mathjs terminate ping

# Install Eigen3
RUN apt-get update -q && apt-get install -y \
    libeigen3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# For rviz_animated_view_controller
RUN add-apt-repository universe && apt-get update -q \
    && apt-get install -y qt5-default qtscript5-dev libqwt-qt5-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install pymsgbox, tkfilebrowser, pysimplegui
RUN pip install pymsgbox tkfilebrowser pysimplegui

# CAPC-host
RUN pip install pyserial
RUN pip install git+https://github.com/CA-Giken/capc-host.git

# Bash configuration
RUN sh -c 'echo "export NODE_PATH=/usr/local/lib/node_modules" >> ~/.bashrc'
ARG REGISTRY=ghcr.io
ARG OWNER=ca-giken
FROM ${REGISTRY}/${OWNER}/rosnoetic-slim:main

ENV DEBIAN_FRONTEND=noninteractive

ARG TARGETARCH
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        echo "Installing Open3D 0.13.0 prebuilt wheel for AMD64"; \
        pip install --no-cache-dir open3d==0.13.0; \
    fi

RUN if [ "$TARGETARCH" = "arm64" ]; then \
# Install build dependencies
    apt-get update && apt-get install -y \
        build-essential \
        git \
        cmake \
        xorg-dev \
        libglu1-mesa-dev \
        libblas-dev \
        liblapack-dev \
        liblapacke-dev \
        libsdl2-dev \
        libc++-dev \
        libc++abi-dev \
        libxi-dev \
        clang \
        ccache && \
    # Upgrade CMake
    pip install cmake==3.22.6 && \
    # Clone Open3D
    cd /tmp && \
    git clone --recursive --branch v0.13.0 --depth 1 https://github.com/isl-org/Open3D.git && \
    cd Open3D && \
    git submodule update --init --recursive && \
    # Build Open3D (CUDA無効)
    mkdir build && cd build && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=ON \
        -DBUILD_CUDA_MODULE=OFF \
        -DBUILD_GUI=OFF \
        -DBUILD_TENSORFLOW_OPS=OFF \
        -DBUILD_PYTORCH_OPS=OFF \
        -DBUILD_UNIT_TESTS=OFF \
        -DPYTHON_EXECUTABLE=$(which python3) \
        .. && \
    make -j2 && \
    make install-pip-package && \
    # Cleanup
    cd / && \
    rm -rf /tmp/Open3D && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*; \
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
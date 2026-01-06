ARG REGISTRY=ghcr.io
ARG OWNER=ca-giken
FROM ${REGISTRY}/${OWNER}/rosnoetic-slim:main

ENV DEBIAN_FRONTEND=noninteractive

# Open3d dependencies for ARM64 build from source
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "arm64" ]; then \
        apt-get update && apt-get install -y \
            cmake \
            git \
            libeigen3-dev \
            libglew-dev \
            libglfw3-dev \
            libjpeg-dev \
            libpng-dev \
            libpython3-dev \
            xorg-dev \
            libx11-dev \
            libxrandr-dev \
            libxi-dev \
            libxinerama-dev \
            libxcursor-dev \
            libfmt-dev \
            libspdlog-dev && \
        rm -rf /var/lib/apt/lists/*; \
    fi

# Open3d - ARM64 builds from source from GitHub, AMD64 uses prebuilt wheel
RUN if [ "$TARGETARCH" = "arm64" ]; then \
        echo "Building Open3D 0.13.0 from source for ARM64 (may take 30-60 minutes)"; \
        cd /tmp && \
        git clone --branch v0.13.0 --depth 1 https://github.com/isl-org/Open3D.git && \
        cd Open3D && \
        mkdir build && cd build && \
        cmake -DBUILD_SHARED_LIBS=ON \
              -DCMAKE_INSTALL_PREFIX=/usr/local \
              -DBUILD_PYTHON_MODULE=ON \
              -DBUILD_CUDA_MODULE=OFF \
              -DBUILD_EXAMPLES=OFF \
              -DBUILD_UNIT_TESTS=OFF \
              .. && \
        make -j$(nproc) && \
        make install-pip-package && \
        cd / && rm -rf /tmp/Open3D; \
    else \
        echo "Installing Open3D 0.13.0 prebuilt wheel for AMD64"; \
        pip install open3d==0.13.0; \
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
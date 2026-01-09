FROM ubuntu:focal-20240427

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
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
  ccache

RUN apt-get update -q && apt-get install -y \
    python3.8 python3-pip python3-dev python3-tk python-is-python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip setuptools wheel
RUN pip install cmake==3.22.6
RUN cd /tmp && \
  git clone --recursive --branch v0.13.0 --depth 1 https://github.com/isl-org/Open3D.git
RUN cd /tmp/Open3D && \
  git submodule update --init --recursive
RUN mkdir /tmp/Open3D/build && cd /tmp/Open3D/build && \
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
  make install-pip-package
RUN mkdir -p /output && \
    find /tmp/Open3D/build -name "*.whl" -exec cp {} /output/ \;
RUN cd / && \
  rm -rf /tmp/Open3D && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Display wheel info
RUN ls -lh /output/

CMD ["sh", "-c", "echo 'Wheel file created successfully:' && ls -lh /output/*.whl"]
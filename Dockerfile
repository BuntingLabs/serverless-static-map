# Dockerfile edited mostly from https://github.com/brendan-ward/pymgl
FROM nvidia/cudagl:11.3.0-devel-ubuntu20.04

WORKDIR /app

ENV DISPLAY :99
ENV DEBIAN_FRONTEND noninteractive
ENV PYTHONMALLOC malloc
ENV BUILD_TEMP_DIR /tmp/build

RUN apt-get update && \
    apt-get install -y \
    g++ \
    make \
    cmake \
    unzip \
    libcurl4-openssl-dev

RUN apt-get update && \
    apt-get -y install software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get -y install \
    curl \
    # build tools
    build-essential \
    cmake \
    ccache \
    ninja-build \
    pkg-config \
    # install python 3.9
    python3 \
    python3-dev \
    python3-pip \
    # required dependencies
    libcurl4-openssl-dev \
    libicu-dev \
    libturbojpeg0-dev \
    libpng-dev \
    libprotobuf-dev \
    libuv1-dev \
    libx11-dev \
    libegl-dev \
    libopengl-dev \
    # runtime dependencies
    xvfb \
    # debugging utilities
    valgrind && \
    /usr/sbin/update-ccache-symlinks

# pip is screwed up
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3 get-pip.py --force-reinstall

#  Install python test deps
RUN python3 -m pip install pytest pytest-benchmark pytest-valgrind python-dotenv Pillow numpy pixelmatch requests

# install pymgl with python 3.8.10
RUN mkdir -p /opt/pymgl-wheels
RUN curl -Lo /opt/pymgl-wheels/pymgl-0.3.1-cp38-cp38-linux_x86_64.whl https://github.com/brendan-ward/pymgl/releases/download/v0.3.1/pymgl-0.3.1-cp38-cp38-linux_x86_64.whl.ubuntu-20.04

RUN python3 -m pip install /opt/pymgl-wheels/pymgl-0.3.1-cp38-cp38-linux_x86_64.whl

# emulator
RUN python3 -m pip install awslambdaric
RUN mkdir -p /opt/.aws-lambda-rie && curl -Lo /opt/.aws-lambda-rie/aws-lambda-rie \
    https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie \
    && chmod +x /opt/.aws-lambda-rie/aws-lambda-rie 

COPY app.py .
COPY example.png .
COPY run.sh .

ENTRYPOINT [ "/app/run.sh" ]

CMD [ "app.handler" ]

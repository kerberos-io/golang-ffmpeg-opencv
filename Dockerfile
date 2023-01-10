FROM golang:1.18.0-stretch AS builder

ARG gitlab_id
ARG gitlab_token

WORKDIR /build

# Compile FFMPEG + x264
RUN apt-get update && apt-get upgrade -y && apt-get -y --no-install-recommends install git cmake wget dh-autoreconf autotools-dev autoconf automake gcc build-essential libtool make ca-certificates supervisor nasm zlib1g-dev tar libx264. unzip wget pkg-config libavresample-dev && \
    git clone https://github.com/FFmpeg/FFmpeg && \
    cd FFmpeg && git checkout remotes/origin/release/4.0 && \
    ./configure --prefix=/usr/local --target-os=linux --enable-nonfree --enable-libx264 --enable-gpl --enable-shared && \
    make -j8 && \
    make install && \
    cd .. && rm -rf FFmpeg
RUN	wget -O opencv.zip https://github.com/opencv/opencv/archive/4.0.0.zip && \
    unzip opencv.zip && mv opencv-4.0.0 opencv && cd opencv && mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/ \
    -D OPENCV_GENERATE_PKGCONFIG=YES \
    -D BUILD_TESTS=OFF \
    -D OPENCV_ENABLE_NONFREE=ON \
    #-D BUILD_opencv_dnn=OFF \
    -D BUILD_opencv_ml=OFF \
    -D BUILD_opencv_stitching=OFF \
    -D BUILD_opencv_ts=OFF \
    -D BUILD_opencv_java_bindings_generator=OFF \
    -D BUILD_opencv_python_bindings_generator=OFF \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D BUILD_EXAMPLES=OFF .. && make -j8 && make install && cd ../.. && rm -rf opencv*

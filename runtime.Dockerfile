ARG GOLANG_VERSION
ARG OPENCV_VERSION

FROM ghcr.io/khlipeng/opencv-debian:$OPENCV_VERSION-$TARGETARCH as opencv

FROM debian:buster

LABEL maintainer="khlipeng"

RUN apt-get update \
    && apt-get install -y ffmpeg \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
            pkg-config unzip libgtk2.0-dev \
            curl ca-certificates libcurl4-openssl-dev libssl-dev \
            libavcodec-dev libavformat-dev libswscale-dev libtbb2 libtbb-dev \
            libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev && \
            rm -rf /var/lib/apt/lists/*

COPY --from=opencv /usr/local/include/opencv4 /usr/local/include/opencv4
COPY --from=opencv /usr/local/lib /usr/local/lib
# COPY ldconfig/opencv.conf /etc/ld.so.conf.d/opencv.conf
RUN echo "/usr/local/include/opencv4" >> /etc/ld.so.conf.d/opencv.conf \
    && echo "/usr/local/lib" >> /etc/ld.so.conf.d/opencv.conf \
    && ldconfig

ENV CGO_CPPFLAGS "-I/usr/local/include"
ENV CGO_LDFLAGS "-L/usr/local/lib -lopencv_core -lopencv_face -lopencv_videoio -lopencv_imgproc -lopencv_highgui -lopencv_imgcodecs -lopencv_objdetect -lopencv_features2d -lopencv_video -lopencv_dnn -lopencv_xfeatures2d"



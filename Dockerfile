FROM alpine:3.6
RUN export VERSION=5.2.0.224 && \
    apk update && \
    apk upgrade && \
    apk add --no-cache --virtual .build-deps curl build-base linux-headers cmake libtool python2 perl && \
    curl -O https://download.mono-project.com/sources/mono/mono-$VERSION.tar.bz2 && \
    tar xvf mono-$VERSION.tar.bz2 && \
    cd mono-$VERSION && \
    ./configure --prefix=/usr/local && \
    export CPU_COUNT=`awk '/^processor/{n+=1}END{print n}' /proc/cpuinfo` && \
    make --jobs=$CPU_COUNT && \
    make install && \
    cd .. && \
    rm mono-$VERSION.tar.bz2 && \
    rm -rf mono-$VERSION && \
    apk del .build-deps && \
    apk add libgcc
ENTRYPOINT ["mono"]
CMD ["--version"]

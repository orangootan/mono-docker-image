FROM alpine:3.7
RUN apk upgrade --no-cache
RUN export VERSION=5.10.1.47 && \
    apk add --no-cache --virtual .build-deps curl build-base linux-headers cmake libtool python2 perl zlib-dev && \
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
    apk del .build-deps
RUN apk add libgcc zlib
ENTRYPOINT ["/bin/sh"]

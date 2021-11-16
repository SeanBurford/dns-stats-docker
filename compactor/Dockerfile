FROM ubuntu:focal as builder

ARG COMPACTOR_VERSION=1.2.0
ARG COMPACTOR_BRANCH="master"

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

WORKDIR /tmp

RUN apt-get -y update -qq && \
    apt-get install -y --no-install-recommends \
      git build-essential ca-certificates

COPY patches/01-pseudoanon-inspector.patch /tmp/

RUN git clone -b "${COMPACTOR_BRANCH}" --single-branch \
        https://github.com/dns-stats/compactor.git && \
    cd compactor && \
    git checkout tags/${COMPACTOR_VERSION} && \
    patch -p 1 < /tmp/01-pseudoanon-inspector.patch && \
    git submodule update --init

RUN apt-get install -y --no-install-recommends \
      autoconf automake pkg-config libtool \
      protobuf-compiler libprotobuf-dev libtcmalloc-minimal4 \
      libboost-filesystem-dev libboost-iostreams-dev \
      libboost-program-options-dev libboost-log-dev \
      libpcap-dev liblzma-dev libtins-dev libctemplate-dev \
      libmaxminddb-dev && \
    ldconfig && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/*

RUN cd /tmp/compactor && \
    CFLAGS="-O2 -flto -FPIE -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 -fstack-protector-strong \
            -Wformat -Werror=format-security" \
    LDFLAGS="-Wl,-z,now -Wl,-z,relro" && \
    export CFLAGS LDFLAGS && \
    autoreconf --install --force && \
    ./configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc/ \
                --with-geoip-data-dir=/usr/share/GeoIP \
                --disable-pseudo-anonymisation && \
    make && \
    make install DESTDIR=/builder

FROM ubuntu:focal

LABEL Maintainer "Sean Burford (unix.gurus@gmail.com)"

RUN apt-get -y update -qq && \
    apt-get install -y --no-install-recommends \
      tini libprotobuf-lite17 libtcmalloc-minimal4 \
      libboost-filesystem1.71.0 libboost-iostreams1.71.0 \
      libboost-program-options1.71.0 libboost-log1.71.0 \
      libpcap0.8 liblzma5 libtins4.0 libmaxminddb0 \
      libprotobuf17 socat
 
COPY bin /usr/local/bin
COPY etc/dns-stats/compactor.conf /etc/dns-stats-compactor/compactor.conf
COPY --from=builder /builder/usr/bin/inspector /usr/bin/inspector
COPY --from=builder /builder/usr/bin/compactor /usr/bin/compactor
COPY --from=builder /builder/etc/dns-stats-compactor/compactor.conf \
                    /etc/dns-stats-compactor/compactor.conf.sample
COPY --from=builder /builder/etc/dns-stats-compactor/default_values.conf \
                    /etc/dns-stats-compactor/default_values.conf
COPY --from=builder /builder/etc/dns-stats-compactor/excluded_fields.conf.sample \
                    /etc/dns-stats-compactor/excluded_fields.conf.sample
COPY --from=builder /builder/usr/share/doc/dns-stats-compactor/ChangeLog.txt \
                    /usr/share/doc/dns-stats-compactor/ChangeLog.txt
COPY --from=builder /builder/usr/share/doc/dns-stats-compactor/LICENSE.txt \
                    /usr/share/doc/dns-stats-compactor/LICENSE.txt
COPY --from=builder /builder/usr/share/doc/dns-stats-compactor/KNOWN_ISSUES.txt \
                    /usr/share/doc/dns-stats-compactor/KNOWN_ISSUES.txt

ENV UID=991 GID=991

CMD ["start_compactor.sh"]

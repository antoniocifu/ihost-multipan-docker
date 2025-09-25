ARG BASE_VERSION=1.0.0
ARG TARGETARCH=amd64
ARG BASE_IMAGE_NAME=ghcr.io/ihost-open-source-project/hassio-ihost-silabs-multiprotocol-${TARGETARCH}

FROM ${BASE_IMAGE_NAME}:${BASE_VERSION}

ENV S6_VERBOSITY=3 \
    DEVICE="/dev/ttyUSB0" \
    BAUDRATE="115200" \
    CPCD_TRACE="false" \
    CPCP_DISABLE_ENCRYPTION="true" \
    FLOW_CONTROL="false" \
    NETWORK_DEVICES=0 \
    OTBR_ENABLE=1 \
    BACKBONE_IF="eth0" \
    OTBR_LOG_LEVEL="notice" \
    OTB_FIREWALL=1 \
    OTBR_REST_LISTEN_PORT="8081" \
    OTBR_WEB_PORT="8086" \
    NETWORK_DEVICE="" \
    EZSP_LISTEN_PORT="20108"\
    AUTOFLASH_FIRMWARE=0 \
    FIRMWARE=""

RUN rm -rf /etc/s6-overlay/s6-rc.d/banner && \
    rm -rf /etc/s6-overlay/scripts/banner.sh && \
    rm -rf /etc/s6-overlay/s6-rc.d/universal-silabs-flasher/dependencies.d && \
    rm -rf /etc/s6-overlay/s6-rc.d/otbr-agent-rest-discovery && \
    rm -rf /etc/s6-overlay/scripts/otbr-agent-rest-discovery.sh && \
    rm -rf /etc/s6-overlay/s6-rc.d/user/contents.d/otbr-agent-rest-discovery && \
    rm -rf /etc/s6-overlay/s6-rc.d/cpcd-config && \
    rm -rf /etc/s6-overlay/s6-rc.d/cpcd/dependencies.d && \
    rm -rf /usr/bin/bashio && \
    rm -rf *.gbl && \
    rm -rf firmware && \
    rm -rf /home/firmware && \
    rm -rf /root/*.gbl


RUN if [ "$TARGETARCH" != "armv7" ]; then \
    apt-get update && \
    apt-get install -y --no-install-recommends python3-pip && \
    pip install --no-cache-dir universal-silabs-flasher==0.0.31 && \
    rm -rf /var/lib/apt/lists/*; \
    fi

COPY rootfs /

WORKDIR /

VOLUME /data

ENTRYPOINT ["/init"]

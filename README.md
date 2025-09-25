# iHost Multipan Docker (Sonoff)

This is a standalone container based on the Sonoff iHost multiprotocol add-on (CPCD/OTBR/zigbeed), with no HAOS dependency. It works with ZHA/Zigbee2MQTT via EZSP over TCP and exposes the OTBR Web UI/API.

![](https://img.shields.io/github/license/b2un0/silabs-multipan-docker.svg)
![](https://img.shields.io/github/stars/b2un0/silabs-multipan-docker)
![](https://img.shields.io/docker/v/b2un0/silabs-multipan-docker)
![](https://img.shields.io/docker/pulls/b2un0/silabs-multipan-docker.svg)
![](https://img.shields.io/docker/image-size/b2un0/silabs-multipan-docker.svg)

# ❗ Attention ❗

I do not provide any support for the software running in this container.

I have only provided a `standalone` version of the Silabs multiprotocol container which can run **without** `HAOS`

## Credits

Based on the work by [@nervousapps](https://github.com/nervousapps/haDOCKERaddons/tree/master/silabs-multiprotocol/dockerCustom), [m33ts4k0z](https://github.com/m33ts4k0z/silabs-multipan-docker), [b2un0](https://github.com/b2un0/silabs-multipan-docker), and the [iHost Open Source Project add-on](https://github.com/iHost-Open-Source-Project/hassio-ihost-addon/tree/master/hassio-ihost-silabs-multiprotocol).

## Versions

see [VERSIONS.md](VERSIONS.md)

## Changelog

see [CHANGELOG.md](CHANGELOG.md)

## Docs

see [DOCS.md](DOCS.md)

## Base

see [BASE.md](BASE.md)

## ❗ requirements ❗ read carefully ❗

1. the container must run in `host` network mode
2. working `IPv6` in your LAN
3. the container must run with `--privileged` flag
4. the name of your network interface (try `ifconfig` or `ip a`) to set `BACKBONE_IF` correctly
5. the path of your Device like `/dev/tty???` (`/dev/serial/by-id/` will not work out of the box)
6. **Zigbee channel and Thread channel must be configured to the same**
7. OTBR REST API uses port `8081` (fixed); Web UI is on `8086`.

## environment variables

take a look at the [Dockerfile](Dockerfile) file for more information

## Getting Started

⚠️ Change `DEVICE` and `BACKBONE_IF` for your environment ⚠️

### With docker run

```bash
docker run --name multipan \
            --detach \
            --privileged \
            --network host \
            --restart unless-stopped \
            --volume ~/multipan/:/data \
            --env DEVICE="/dev/ttyUSB0" \
            --env BACKBONE_IF="eth0" \
            antoniocifu/ihost-multipan-docker:latest
```

### With docker compose

1. download the [docker-compose.yml](docker-compose.yml) or copy the service to your existing one
2. change the config in `environment` if necessary
3. run `docker compose up -d`

## Setup OpenThread Border Router

Open `http://HOST:8086` and configure your OTBR.

## Home Assistant

### OTBR

add a new Device Integration `Open Thread Border Router` and use as Host `http://HOST:8081` as Endpoint.

### ZHA

1. Add the Zigbee Home Automation (`ZHA`) integration
2. Choose `EZSP` as Radio type
3. As serial path, enter `tcp://host_ip:20108` or `socket://host_ip:20108`
4. Port speed `115200` (iHost default)
5. Flow control `none` (iHost default). Adjust if your dongle requires otherwise.

## Setup Zigbee2MQTT

To use this with `Zigbee2MQTT` change the `configuration.yaml` file of Zigbee2MQTT to this configuration:

```yaml
serial:
  port: tcp://host_ip:20108
  adapter: ezsp
  baudrate: 115200
```

Restart `Zigbee2MQTT`.
It might take a couple of tries for `Zigbee2MQTT` to connect the first time, but it will work without issues afterward.

## Matter

you also need the [python-matter-server](https://github.com/home-assistant-libs/python-matter-server) if you want to use Matter enabled devices with Home Assistant.

### Firmware Update

1. download the newer firmware from https://github.com/NabuCasa/silabs-firmware/tree/main/RCPMultiPAN/beta
2. place them into your local directory `~/multipan/firmware/` (if your `/data` Volume mounted to `~/multipan/`)
3. change the environment variable `FIRMWARE` to the new Filename (without path)
4. change the environment variable `AUTOFLASH_FIRMWARE` to `1`
5. redeploy your container

## Docker Base Images

| arch    | url                                                                       |
|---------|---------------------------------------------------------------------------|
| aarch64 | https://hub.docker.com/r/homeassistant/aarch64-addon-silabs-multiprotocol |
| amd64   | https://hub.docker.com/r/homeassistant/amd64-addon-silabs-multiprotocol   |
| armv7   | https://hub.docker.com/r/homeassistant/arm-addon-silabs-multiprotocol     |
| i386    | not exists (not supported by HA)                                          |

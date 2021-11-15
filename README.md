# dns-stats-docker

[DNS Stats Compactor](https://github.com/dns-stats/compactor) configured to run on
Docker and Kubernetes.

## Compactor Usage

Mount `/var/dnstap/` in both the dns-stats-compactor container and the name server
container.  This will contain the dnstap.sock Unix socket.

Mount `/var/log/dnstap/` in the dns-stats-compactor container.  This will contain
the logs from compactor.

Optionally, mount a config map at `/etc/dns-stats-compactor/` to provide compactor.conf.

Run dns-stats-compactor in the same Kubernetes pod as your name server.

Configure your name server to send dnstap records to the dnstap Unix socket.

## Inspector Usage

Download the [MaxMind GeoIP Lite](https://dev.maxmind.com/geoip/geolite2-free-geolocation-data?lang=en)
City and ASN databases and create a mount at `/usr/share/GeoIP` containing
the uncompressed mmdb files.

## Build

*  `vi Makefile`: Modify `IMAGES_REPO` to point to your repo.
*  `make all`: Build the image and push it to your repo.

## Prebuilt Containers

*  https://hub.docker.com/repository/docker/seanburford/dns-stats-compactor

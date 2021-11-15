#!/bin/sh

set -eux

UID=$UID
GID=$GID

mkdir -m 0755 -p /var/dnstap
mkdir -m 0755 -p /var/log/dnstap

exec /usr/bin/tini -- compactor -c /etc/dns-stats-compactor/compactor.conf

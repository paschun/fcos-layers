#!/usr/bin/env bash

set -xeuo pipefail

podman build --pull=newer -t localhost/custom-kernel:latest .
time podman save --format oci-archive -o custom-kernel.tar localhost/custom-kernel:latest
rsync -vhicP ./custom-kernel.tar "$HOST":/var/tmp/
rm -v ./custom-kernel.tar
ssh "$HOST" 'sudo ostree admin pin 0'
ssh "$HOST" 'sudo rpm-ostree rebase ostree-unverified-image:oci-archive:/var/tmp/custom-kernel.tar'
# then reboot
#
# to delete:
# sudo rpm-ostree cleanup -bprm
# sudo ostree admin pin -u 0

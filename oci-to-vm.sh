#!/usr/bin/env bash

set -xeuo pipefail

# written on macOS
# podman machine must be rootful
# does not yet work on CoreOS images: https://github.com/coreos/fedora-coreos-tracker/issues/1906
# https://osbuild.org/docs/bootc
# https://coreos.github.io/coreos-assembler/building-fcos/

#CONTAINER_IMAGE="localhost/base:latest"
CONTAINER_IMAGE="quay.io/fedora/fedora-coreos:stable"
#CONTAINER_IMAGE="quay.io/centos-bootc/centos-bootc:c10s"


# maybe look at https://github.com/coreos/custom-coreos-disk-images

cosa() {
    # wont run on macOS, requires /dev/kvm
    # uses osbuild https://github.com/coreos/coreos-assembler/blob/main/src/runvm-osbuild
    rm -rfv ./cosa
    mkdir -v ./cosa
    podman run --rm -ti --security-opt=label=disable --privileged                             \
        --pull=newer                                                                          \
        --userns=host                                                    \
        -v=${PWD}/cosa/:/srv/  --device=/dev/fuse                                  \
        --tmpfs=/tmp -v=/var/tmp:/var/tmp --name=cosa                                         \
        ${COREOS_ASSEMBLER_CONFIG_GIT:+-v=$COREOS_ASSEMBLER_CONFIG_GIT:/srv/src/config/:ro}   \
        ${COREOS_ASSEMBLER_GIT:+-v=$COREOS_ASSEMBLER_GIT/src/:/usr/lib/coreos-assembler/:ro}  \
        ${COREOS_ASSEMBLER_ADD_CERTS:+-v=/etc/pki/ca-trust:/etc/pki/ca-trust:ro}              \
        quay.io/coreos-assembler/coreos-assembler:latest shell
}


bib() {
    podman pull --policy=newer $CONTAINER_IMAGE
    rm -vr ./vm-disk/*
    podman run \
        --rm \
        -it \
        --privileged \
        --pull=newer \
        --security-opt label=type:unconfined_t \
        -v "$(pwd)"/vm-disk:/output \
        -v /var/lib/containers/storage:/var/lib/containers/storage \
        quay.io/centos-bootc/bootc-image-builder:latest \
        --rootfs xfs \
        --type qcow2 \
        --log-level debug \
        --use-librepo=True \
        $CONTAINER_IMAGE
}



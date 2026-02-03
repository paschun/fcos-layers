#!/usr/bin/env bash

# written on macOS
# podman machine must be rootful

# does not yet work on CoreOS images: https://github.com/coreos/fedora-coreos-tracker/issues/1906
#CONTAINER_IMAGE="localhost/bcachefs:latest"
#CONTAINER_IMAGE="quay.io/fedora/fedora-coreos:stable"
CONTAINER_IMAGE="quay.io/centos-bootc/centos-bootc:c10s"

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
    $CONTAINER_IMAGE

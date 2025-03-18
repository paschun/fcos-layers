# fcos-layers

Custom Fedora CoreOS layered images.

- [`base`](#base-image): Includes some cli utils
- [`zfs`](#zfs-image): Includes ZFS as a kernel module (built on top of `base`)

These images are built using GitHub Actions every day, from the upstream "stable" images of Fedora CoreOS.

Images are published on GitHub Packages and available for linux/amd64 and linux/arm64.

## `base` image

Includes:

- [restic](https://github.com/restic/restic)
- Utilities: `tmux`, `pv`, `btop`

Image:

```text
ghcr.io/italypaleale/fcos-layers/base:stable
```

[Containerfile](./base/Containerfile)

## `zfs` image

Includes:

- ZFS as a kernel module

Image:

```text
ghcr.io/italypaleale/fcos-layers/zfs:stable
```

[Containerfile](./zfs/Containerfile)


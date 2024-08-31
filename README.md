# fcos-layers

Custom Fedora CoreOS layered images.

- [`tailscale`](#tailscale-image): Includes Tailscale
- [`base`](#base-image): Includes Tailscale and Cloudflare Tunnel client (cloudflared)
- [`zfs`](#zfs-image): Includes ZFS as a kernel module (built on top of `base`)
- [`monitoring`](#monitoring-image): Includes Grafana Alloy (built on top of `base`)
- [`monitoring-zfs`](#monitoring-zfs-image): Includes Grafana Alloy (built on top of `zfs`)

These images are built using GitHub Actions every Monday and Friday, from the upstream "stable" images of Fedora CoreOS.

Images are published on GitHub Packages and available for linux/amd64.

## `tailscale` image

Includes:

- [Tailscale](https://tailscale.com/)

Image:

```text
ghcr.io/italypaleale/fcos-layers/tailscale:stable
```

[Containerfile](./tailscale/Containerfile)

## `base` image

Includes:

- [Tailscale](https://tailscale.com/)
- [Cloudflare Tunnel client](https://github.com/cloudflare/cloudflared) (cloudflared)
- [restic](https://github.com/restic/restic)
- The `screen` utility

Image:

```text
ghcr.io/italypaleale/fcos-layers/base:stable
```

[Containerfile](./base/Containerfile)

## `zfs` image

Includes:

- ZFS as a kernel module
- [Tailscale](https://tailscale.com/)
- [Cloudflare Tunnel client](https://github.com/cloudflare/cloudflared) (cloudflared)

Image:

```text
ghcr.io/italypaleale/fcos-layers/zfs:stable
```

[Containerfile](./zfs/Containerfile)

## `monitoring` image

Includes:

- Everything in the [`base` image](#base-image)
- [Grafana Alloy](https://github.com/grafana/alloy)

Image:

```text
ghcr.io/italypaleale/fcos-layers/monitoring:stable
```

[Containerfile](./monitoring/Containerfile)

## `monitoring-zfs` image

Includes:

- Everything in the [`zfs` image](#zfs-image)
- [Grafana Alloy](https://github.com/grafana/alloy)

Image:

```text
ghcr.io/italypaleale/fcos-layers/monitoring-zfs:stable
```

[Containerfile](./monitoring/Containerfile)

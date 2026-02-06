# fcos-layers

Custom Fedora CoreOS (FCOS) layered images.

- [`base`](#base-image): Includes some cli utils
- [`zfs`](#zfs-image): Includes ZFS as a kernel module (built on top of `base`)
- [`bcachefs`](#bcachefs-image): Includes bcachefs as a kernel module (built on top of `base`)

These images are based on the upstream images of FCOS.

Images are built and tagged using GitHub Actions every time a FCOS stream is updated: stable, testing, and next.

Upstream currently releases in a 2 week cadence.

Images are published on GitHub Packages (ghcr.io) and are multi-arch for linux/amd64 and linux/arm64.

You can also extend `FROM` these images in your own `Containerfile` for further customization, if you wish.

## Install

To install, run
```sh
> sudo rpm-ostree rebase --bypass-driver --reboot ostree-unverified-registry:ghcr.io/paschun/fcos-layers/bcachefs:stable
```

The images are also cryptographically signed.

All images contain the necessary config in `/etc/containers/policy.json`, `/etc/containers/registries.d/`, and `/etc/pki/` to have ostree verify the signature.

So after getting the signature config files via a first unverified rebase, you can activate ostree signature verification with:
```sh
> sudo rpm-ostree rebase --bypass-driver --reboot ostree-image-signed:docker://ghcr.io/paschun/fcos-layers/bcachefs:stable
```

## `base` image

Includes:

- Utilities: `pv`, `kitty`, `fd-find`, `ripgrep`, `procs`, `tree`, `neovim`, `bat`, `man-db`, `ranger`, `btop`, `et`, `tmux`, `tcpdump`, `drill`, `restorecon`, `qemu-guest-agent`, `podman-tui`, `restic`, `rclone`, `uv`, `parted`, `nmap-ncat`, `buildah`, `mtr`, `inxi`, `gdu`, `7zip`, `strace`, `xxhash`, `fish`
- `python3` and `nodejs` are pulled in as dependencies of the above.
- Maybe more, check the Containerfile

Image:

```text
ghcr.io/paschun/fcos-layers/base:stable
```

Tags:

- `:stable`
- `:testing`
- `:next`
- Each FCOS version number is tagged, like `:43.20260119.3.1`
- `:latest` -> `:stable`

[Containerfile](./base/Containerfile)

## `zfs` image

Includes:

- Everything in Base
- Latest ZFS as a kernel module

Image:

```text
ghcr.io/paschun/fcos-layers/zfs:stable
```

Tags:

- `:stable`
- `:testing`
- `:next`
- FCOS-ZFS version number, like `:43.20260119.3.1-2.4.0`
- `:latest` -> `:stable`

[Containerfile](./zfs/Containerfile)

## `bcachefs` image

Includes:

- Everything in Base
- Latest bcachefs as a kernel module

Image:

```text
ghcr.io/paschun/fcos-layers/bcachefs:stable
```

Tags:

- `:stable`
- `:testing`
- `:next`
- FCOS-bcachefs version number, like `:43.20260119.3.1-1.36.0`
- `:latest` -> `:stable`

[Containerfile](./bcachefs/Containerfile)


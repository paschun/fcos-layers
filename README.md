# fcos-layers

Custom Fedora CoreOS (FCOS) layered images.

- [`base`](#base-image): Includes some cli utils
  - [`bcachefs`](#bcachefs-image): Includes bcachefs as a kernel module (built on top of `base`)
  - [`zfs`](#zfs-image): Includes ZFS as a kernel module (built on top of `base`)
- [Install instructions](#install)
  - [Automatic Updates](#automatic-updates)
- [Manually verify signature](#manually-verify-signature)

These images are based on the upstream images of FCOS.

Images are built and tagged using GitHub Actions every time a FCOS stream is updated: stable, testing, and next. Or when a new version of bcachefs or zfs is released.

Upstream currently releases in a 2 week cadence.

Images are published on GitHub Packages (ghcr.io) and are multi-arch for linux/amd64 and linux/arm64.

You can also extend `FROM` these images in your own `Containerfile` for further customization, if you wish.

## `base` image

`FROM fedora-coreos`

Includes:

- Utilities: `pv`, `fd`, `ripgrep`, `procs`, `tree`, `neovim`, `bat`, `ranger`, `btop`, `et`, `tmux`, `tcpdump`, `drill`, `restorecon`, `podman-tui`, `restic`, `rclone`, `uv`, `parted`, `ncat`, `buildah`, `mtr`, `inxi`, `gdu`, `7zip`, `strace`, `xxhash`, `fish`
- `python3` and `nodejs` are pulled in as dependencies of the above.
- Maybe more utils, check the Containerfile
- Config files necessary to verify the signature on images from this repo
- Config files for a proper [auto-update](#automatic-updates)

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

## `bcachefs` image

`FROM base`

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

## `zfs` image

`FROM base`

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

### Automatic Updates

If you are coming from vanilla FCOS, it uses [Zincati](https://coreos.github.io/zincati/usage/auto-updates/) by default for updates. Zincati depends on a [Cincinnati](https://github.com/coreos/fedora-coreos-cincinnati) service that runs on Fedora servers. The Zincati client uses it to see if an update is available, and if so, it runs `rpm-ostree upgrade`.

After rebasing, you can't use Zincati anymore.  
So the [`base`](#base-image) image (and derived images) disables `zincati.service` and instead enables `rpm-ostreed-automatic.timer` which triggers `rpm-ostreed-automatic.service`.

You can see what it will do with `systemctl cat rpm-ostreed-automatic.{timer,service}`. It just runs `rpm-ostree upgrade` once a day.

`rpm-ostreed-automatic.service` is further configured by [`/etc/rpm-ostreed.conf`](https://www.mankier.com/5/rpm-ostreed.conf). In the [`base`](#base-image) image, I have set `AutomaticUpdatePolicy=apply` in this conf file, which applies upgrades and reboots when the service is triggered.

However, `rpm-ostreed-automatic` is a dumb service. It runs `rpm-ostree upgrade` every day and reboots, even if there is no base image update available, even if only to update a few rpm packages, which is unnecessary and wipes out useful rollback images.
So, in the [`base`](#base-image) image I have created a systemd unit drop-in for `rpm-ostreed-automatic.service` that checks first to see if an update is available before running `rpm-ostree upgrade`.

## Manually verify signature

The image manifests are signed with [cosign](https://docs.sigstore.dev/about/overview/). To verify them yourself, get the public key in `base/paschun.pub`, and run:
```sh
> cosign verify --key paschun.pub ghcr.io/paschun/fcos-layers/bcachefs:stable
```

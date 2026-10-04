# archStream

Setup notes and local package builds for an Arch Linux streaming PC.

## OBS Studio with NVENC on a GTX 1080

`pkgbuilds/obs-studio/` is the official Arch `obs-studio` PKGBUILD, modified so
NVIDIA's hardware encoder (NVENC) works on Pascal GPUs.

### The problem

- The GTX 1080 (Pascal) is stuck on the `nvidia-580xx` driver. 580 is the last
  driver branch NVIDIA released for Pascal, and it supports NVENC API **13.0**.
- Arch's `obs-studio` (and `ffmpeg`) are built against `ffnvcodec-headers`
  **13.1**, which requires driver 610 or newer.
- OBS checks the driver at startup, finds it too old, and hides the NVENC
  encoders entirely. `obs-nvenc-test` reports `reason=outdated_driver`.

### The fix

OBS still supports NVENC headers back to 12.0, so the PKGBUILD builds OBS
against [nv-codec-headers 13.0.19.0](https://github.com/FFmpeg/nv-codec-headers/releases/tag/n13.0.19.0)
instead of the system `ffnvcodec-headers`. Changes from the official PKGBUILD:

- `pkgrel` is `1.1` to mark it as a local build.
- The 13.0 headers are added to `source` and installed into `$srcdir/ffnvcodec`
  in `prepare()`.
- `build()` points CMake at those headers (`PKG_CONFIG_PATH` and
  `-DFFnvcodec_INCLUDE_DIR`).
- `ffnvcodec-headers` is removed from `makedepends`.

Everything else, including the browser source (`obs-studio-plugin-browser`), is
built the same way as the official package. AV1 encoding is not available,
because the GTX 1080 has no AV1 encoder.

### Building and installing

```bash
cd pkgbuilds/obs-studio
makepkg -s
sudo pacman -U obs-studio-*-x86_64.pkg.tar.zst obs-studio-plugin-browser-*-x86_64.pkg.tar.zst
```

`makepkg` also builds `obs-studio-debug`, which you don't need to install.

To check that NVENC works, run `obs-nvenc-test` and look for
`nvenc_supported=true`. In OBS, **NVIDIA NVENC H.264** and **HEVC** appear
under Settings → Output.

### Keeping it from being replaced

`/etc/pacman.conf` holds both packages back so a system update doesn't
replace them with the repo versions:

```
IgnorePkg   = obs-studio obs-studio-plugin-browser
```

### Updating to a new OBS version

1. Get the new official PKGBUILD:
   `git clone https://gitlab.archlinux.org/archlinux/packaging/packages/obs-studio.git`
2. Apply the same changes listed under [The fix](#the-fix).
3. Build and install as above.

Plugins built against the old OBS version (see below) may need a rebuild too.

### Plugins

These come from the AUR and work with this build:

| Plugin | AUR package |
|---|---|
| Aitum Vertical | `obs-vertical-canvas` |
| Aitum Multistream | `obs-aitum-multistream-bin` |

### When this stops working

This workaround only lasts as long as OBS keeps supporting NVENC 13.0 headers
and the `nvidia-580xx` driver keeps building on current kernels. The LTS kernel
is the default boot entry to keep the driver stable. Once either breaks, the
fix is a newer GPU (RTX 20 series or later; RTX 40/50 for AV1 encoding).

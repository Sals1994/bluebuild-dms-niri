export bib_image := env("BIB_IMAGE", "quay.io/centos-bootc/bootc-image-builder:latest")

[private]
default:
    @just --list

[private]
_build-bib $target_image $config:
    #!/usr/bin/env bash
    set -euo pipefail
    BUILDTMP=$(mktemp -p "${PWD}" -d -t _build-bib.XXXXXXXXXX)
    sudo podman run \
      --rm -it --privileged --pull=always --net=host \
      --security-opt label=type:unconfined_t \
      -v "$(pwd)/${config}:/config.toml:ro" \
      -v "$BUILDTMP:/output" \
      -v /var/lib/containers/storage:/var/lib/containers/storage \
      "${bib_image}" \
      --type iso \
      --rootfs xfs \
      --use-librepo=True \
      "${target_image}"
    mkdir -p output
    sudo mv -f "$BUILDTMP"/* output/
    sudo rmdir "$BUILDTMP"
    sudo chown -R "$USER:$USER" output/

# Build a bootable ISO from the standard image
build-iso:
    just _build-bib "ghcr.io/sals1994/bluebuild-dms-niri:latest" "iso/iso.toml"

# Build a bootable ISO from the NVIDIA image
build-iso-nvidia:
    just _build-bib "ghcr.io/sals1994/bluebuild-dms-niri-nvidia:latest" "iso/iso-nvidia.toml"

# Remove build artifacts
[group('Utility')]
clean:
    #!/usr/bin/bash
    set -eoux pipefail
    rm -rf output/
    find . -maxdepth 1 -name "_build-bib.*" -type d -exec sudo rm -rf {} \; 2>/dev/null || true

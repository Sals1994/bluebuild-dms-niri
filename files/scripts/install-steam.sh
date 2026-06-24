#!/usr/bin/env bash
set -oue pipefail
# RPMFusion Steam is i686 and pulls pipewire-libs.i686 → libfdk-aac.so.2,
# which is blocked by libfdk-aac.x86_64's Obsoletes in ublue-os/base-main.
# negativo17's Steam is noarch with only 4 hard deps (libc, libdrm, libGL,
# libnsl), so no multilib conflict. See negativo17.org/updates-to-the-steam-package/
curl -L https://negativo17.org/repos/fedora-steam.repo -o /etc/yum.repos.d/negativo17-steam.repo
dnf5 -y install steam steam-devices

#!/usr/bin/env bash
set -oue pipefail
# libfdk-aac.x86_64 (from ublue-os/base-main) obsoletes fdk-aac-free and fdk-aac,
# blocking pipewire-libs.i686 from being installed. --setopt=obsoletes=False disables
# that check so fdk-aac-free.i686 can satisfy pipewire-libs.i686's libfdk-aac.so.2 dep.
dnf5 -y install --setopt=obsoletes=False steam

#!/usr/bin/env bash
set -euo pipefail

ARCH=$(uname -m)
BASE_URL=https://repo.nordvpn.com
KEY_PATH=/gpg/nordvpn_public.asc
REPO_PATH=/yum/nordvpn/centos

rpm -v --import "${BASE_URL}${KEY_PATH}"

repo="${BASE_URL}${REPO_PATH}/${ARCH}"
dnf5 config-manager addrepo --id="nordvpn" --set=baseurl="${repo}" --set=enabled=1 --overwrite
dnf5 install -y nordvpn

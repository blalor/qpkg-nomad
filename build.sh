#!/bin/bash
set -e -u -o pipefail

basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
bindir="${basedir}/x86_64"

eval "$( grep QPKG_VER "${basedir}/qpkg.cfg" )"

tmpd=$( mktemp -d )
function cleanup() {
    rm -rf "${tmpd}"
}
trap cleanup EXIT

if [ ! -e "${bindir}/nomad" ]; then
    pushd "${tmpd}" >/dev/null

    curl -fS -O "https://releases.hashicorp.com/nomad/${QPKG_VER}/nomad_${QPKG_VER}_linux_amd64.zip"
    curl -fS -O "https://releases.hashicorp.com/nomad/${QPKG_VER}/nomad_${QPKG_VER}_SHA256SUMS"
    curl -fS -O "https://releases.hashicorp.com/nomad/${QPKG_VER}/nomad_${QPKG_VER}_SHA256SUMS.sig"
    gpg --verify "nomad_${QPKG_VER}_SHA256SUMS.sig" "nomad_${QPKG_VER}_SHA256SUMS"
    grep -E '_linux_amd64\.zip$' "nomad_${QPKG_VER}_SHA256SUMS" | shasum -c
    
    unzip "nomad_${QPKG_VER}_linux_amd64.zip"
    mv nomad "${bindir}/nomad"
    
    popd >/dev/null
fi

cd "${basedir}"
qbuild -v

#!/usr/bin/env sh
set -e
DIR=~/Downloads
APP=ctlptl
GHUSER=tilt-dev
MIRROR=https://github.com/${GHUSER}/${APP}/releases/download

dl() {
    local ver=$1
    local lchecksums=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-tar.gz}
    local platform="${os}.${arch}"
    local file="${APP}.${ver}.${platform}.${archive_type}"
    local url="$MIRROR/v$ver/$file"
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep $file $lchecksums | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    # https://github.com/tilt-dev/ctlptl/releases/download/v0.5.5/checksums.txt
    local url="$MIRROR/v$ver/checksums.txt"
    local lchecksums="$DIR/${APP}_${ver}_checksums.txt"
    if [ ! -e $lchecksums ];
    then
        wget -q -O $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver

    dl $ver $lchecksums mac arm64
    dl $ver $lchecksums mac x86_64
    dl $ver $lchecksums linux arm64
    dl $ver $lchecksums linux x86_64
    dl $ver $lchecksums windows x86_64 zip
}

dl_ver ${1:-0.8.5}

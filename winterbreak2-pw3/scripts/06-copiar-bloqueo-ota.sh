#!/bin/bash

set -euo pipefail
source "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/_common.sh"

ARCHIVE="$PACKAGES_DIR/renameotabin.zip"
require_kindle
verify_sha256 "$ARCHIVE" 'd2d333620420096e040e2f195c05bebfc97bdeeb5adf26b04c21a254e48ac439'

[ -d "$KINDLE_VOLUME/extensions/MRInstaller" ] || die 'No encuentro MRPI. Termina primero la FASE 6.'

tmp_dir="$(mktemp -d /tmp/renameota-copy.XXXXXX)"
trap 'rm -rf "$tmp_dir"' EXIT
unzip -q "$ARCHIVE" -d "$tmp_dir"
mkdir -p "$KINDLE_VOLUME/extensions"
rsync -a "$tmp_dir/renameotabin" "$KINDLE_VOLUME/extensions/"
sync

[ -s "$KINDLE_VOLUME/extensions/renameotabin/bin/rename.sh" ] || die 'El bloqueo OTA no se copio correctamente.'

printf '\nBLOQUEO_OTA_COPIADO_OK\n'
eject_kindle
printf 'EXPULSION_OK\n'
printf 'USB: AHORA desconecta fisicamente el cable.\n'
printf 'Siguiente: KUAL -> Rename OTA Binaries -> Rename. NO elegir Restore.\n'


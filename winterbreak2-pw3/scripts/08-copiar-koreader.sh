#!/bin/bash

set -euo pipefail
source "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/_common.sh"

ARCHIVE="$PACKAGES_DIR/koreader-kindlepw2-v2026.03.zip"
require_kindle
verify_sha256 "$ARCHIVE" '46e969bb13765b2630b5e14aa2e7fa2445ec551ccaa47db3efe644d0e34944b0'
[ -d "$KINDLE_VOLUME/extensions/MRInstaller" ] || die 'No encuentro MRPI/KUAL. Completa primero las fases anteriores.'
[ "$(free_mb)" -ge 150 ] || die 'KOReader necesita mas espacio libre. Completa primero la FASE 8 para quitar el relleno.'

tmp_dir="$(mktemp -d /tmp/koreader-copy.XXXXXX)"
trap 'rm -rf "$tmp_dir"' EXIT
unzip -q "$ARCHIVE" -d "$tmp_dir"
rsync -a "$tmp_dir/extensions/" "$KINDLE_VOLUME/extensions/"
rsync -a "$tmp_dir/koreader" "$KINDLE_VOLUME/"
sync

[ -s "$KINDLE_VOLUME/koreader/reader.lua" ] || die 'KOReader no se copio por completo.'
[ -s "$KINDLE_VOLUME/extensions/koreader/menu.json" ] || die 'Falta la extension de KOReader para KUAL.'

printf '\nKOREADER_2026_03_COPIADO_OK\n'
eject_kindle
printf 'EXPULSION_OK\n'
printf 'USB: AHORA desconecta fisicamente el cable.\n'
printf 'Abre KUAL -> KOReader -> Start KOReader.\n'


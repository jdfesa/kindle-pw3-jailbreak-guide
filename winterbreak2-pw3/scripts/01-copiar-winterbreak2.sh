#!/bin/bash

set -euo pipefail
source "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/_common.sh"

ARCHIVE="$PACKAGES_DIR/wb2-v1.0.0.zip"
EXPECTED_SHA='932ff113c414c9b0109b98d7f4b96da20815364fb4905e4483581b881b2ae2e2'

require_kindle
verify_expected_firmware
verify_sha256 "$ARCHIVE" "$EXPECTED_SHA"

tmp_dir="$(mktemp -d /tmp/winterbreak2-copy.XXXXXX)"
trap 'rm -rf "$tmp_dir"' EXIT
unzip -q "$ARCHIVE" -d "$tmp_dir"

cp -f "$tmp_dir/jb.sh" "$KINDLE_VOLUME/jb.sh"
cp -f "$tmp_dir/patchedUks.sqsh" "$KINDLE_VOLUME/patchedUks.sqsh"
mkdir -p "$KINDLE_VOLUME/winterbreak2"
cp -f "$tmp_dir/winterbreak2/dialoger.html" "$KINDLE_VOLUME/winterbreak2/dialoger.html"
sync

cmp -s "$tmp_dir/jb.sh" "$KINDLE_VOLUME/jb.sh" || die 'La verificacion de jb.sh fallo.'
cmp -s "$tmp_dir/patchedUks.sqsh" "$KINDLE_VOLUME/patchedUks.sqsh" || die 'La verificacion de patchedUks.sqsh fallo.'
cmp -s "$tmp_dir/winterbreak2/dialoger.html" "$KINDLE_VOLUME/winterbreak2/dialoger.html" || die 'La verificacion de dialoger.html fallo.'

printf '\nCOPIA_WINTERBREAK2_OK\n'
printf 'USB: DEJAR CONECTADO.\n'
printf 'Siguiente comando: ./scripts/02-rellenar-espacio.sh\n'


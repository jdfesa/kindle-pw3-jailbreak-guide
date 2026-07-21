#!/bin/bash

set -euo pipefail
source "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/_common.sh"

ARCHIVE="$PACKAGES_DIR/KindleForge-v4.1.0.zip"
URL='https://github.com/KindleTweaks/KindleForge/releases/download/v4.1.0/KindleForge.zip'
EXPECTED_SHA='43033781974e63d0ce0f46b87b40e9424fdcb5c29b7f23a2b460c1f32e77c7ed'

require_kindle
[ -s "$KINDLE_VOLUME/documents/KUAL.kual" ] || die 'KUAL no está instalado.'

if [ ! -f "$ARCHIVE" ]; then
    printf 'Descargando KindleForge 4.1.0 desde GitHub...\n'
    curl -fL "$URL" -o "$ARCHIVE"
fi
verify_sha256 "$ARCHIVE" "$EXPECTED_SHA"

tmp_dir="$(mktemp -d /tmp/kindleforge-copy.XXXXXX)"
trap 'rm -rf "$tmp_dir"' EXIT
unzip -q "$ARCHIVE" -d "$tmp_dir"

[ -s "$tmp_dir/KindleForge.sh" ] || die 'El paquete no contiene KindleForge.sh.'
[ -s "$tmp_dir/KindleForge/binaries/KFPM" ] || die 'El paquete no contiene KFPM.'

rsync -a "$tmp_dir/KindleForge" "$KINDLE_VOLUME/documents/"
cp -f "$tmp_dir/KindleForge.sh" "$KINDLE_VOLUME/documents/KindleForge.sh"
sync

cmp -s "$tmp_dir/KindleForge.sh" "$KINDLE_VOLUME/documents/KindleForge.sh" || die 'La verificación de KindleForge.sh falló.'
[ -s "$KINDLE_VOLUME/documents/KindleForge/binaries/UtildSF" ] || die 'Falta el binario soft-float requerido por este PW3.'

printf '\nKINDLEFORGE_4_1_0_COPIADO_OK\n'
eject_kindle
printf 'EXPULSION_OK\n'
printf 'USB: AHORA desconecta físicamente el cable.\n'
printf 'Abre KindleForge una vez desde Library para registrarlo.\n'


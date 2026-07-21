#!/bin/bash

set -euo pipefail
source "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/_common.sh"

manifest="$PACKAGES_DIR/SHA256SUMS.txt"
[ -f "$manifest" ] || die "Falta $manifest."

missing=0
while read -r expected filename; do
    [ -n "${filename:-}" ] || continue
    if [ ! -f "$PACKAGES_DIR/$filename" ]; then
        printf 'FALTA: %s\n' "$filename" >&2
        missing=1
        continue
    fi
    verify_sha256 "$PACKAGES_DIR/$filename" "$expected"
    printf 'OK: %s\n' "$filename"
done < "$manifest"

[ "$missing" -eq 0 ] || die 'Descarga los paquetes que faltan siguiendo paquetes/README.md.'
printf '\nTODOS_LOS_PAQUETES_VERIFICADOS_OK\n'


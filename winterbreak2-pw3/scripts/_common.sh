#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
GUIDE_DIR="$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)"
PACKAGES_DIR="$GUIDE_DIR/paquetes"
KINDLE_VOLUME="${KINDLE_VOLUME:-/Volumes/Kindle}"

die() {
    printf '\nERROR: %s\n' "$*" >&2
    exit 1
}

require_kindle() {
    [ -d "$KINDLE_VOLUME" ] || die "El Kindle no esta montado en $KINDLE_VOLUME. Conectalo por USB y espera a que aparezca en Finder."
    [ -d "$KINDLE_VOLUME/documents" ] || die "$KINDLE_VOLUME no parece ser la unidad del Kindle: falta la carpeta documents."
}

free_mb() {
    df -Pm "$KINDLE_VOLUME" | awk 'NR == 2 { print $4 }'
}

verify_sha256() {
    local file="$1"
    local expected="$2"
    local actual
    actual="$(shasum -a 256 "$file" | awk '{ print $1 }')"
    [ "$actual" = "$expected" ] || die "SHA-256 incorrecto para $(basename "$file"). Esperado $expected; obtenido $actual."
}

verify_expected_firmware() {
    local version_file="$KINDLE_VOLUME/system/version.txt"
    if [ -f "$version_file" ]; then
        grep -Fq '5.16.2.1.1' "$version_file" || die "El archivo system/version.txt no confirma firmware 5.16.2.1.1. No continuar con esta guia."
    else
        printf 'AVISO: no existe system/version.txt; la comprobacion automatica del firmware no fue posible.\n'
        printf 'Esta guia es solamente para PW3 G090G1 con firmware 5.16.2.1.1.\n'
    fi
}

eject_kindle() {
    sync
    diskutil eject "$KINDLE_VOLUME" >/dev/null || die "macOS no pudo expulsar el Kindle. Cierra cualquier ventana de Finder abierta en Kindle y vuelve a ejecutar este paso."
}


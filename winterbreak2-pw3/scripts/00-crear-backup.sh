#!/bin/bash

set -euo pipefail
source "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/_common.sh"

REPO_DIR="$(CDPATH= cd -- "$GUIDE_DIR/.." && pwd)"
BACKUP_DIR="${BACKUP_DIR:-$REPO_DIR/backup}"

require_kindle
case "$BACKUP_DIR" in
    "$KINDLE_VOLUME"|"$KINDLE_VOLUME"/*) die 'El backup no puede guardarse dentro del propio Kindle.' ;;
esac

mkdir -p "$BACKUP_DIR"
printf 'Origen:  %s\n' "$KINDLE_VOLUME"
printf 'Destino: %s\n' "$BACKUP_DIR"
printf 'El Kindle queda conectado después de este paso.\n\n'

rsync -rlt \
    --exclude='.Spotlight-V100' \
    --exclude='.fseventsd' \
    --exclude='.Trashes' \
    --exclude='.DS_Store' \
    --exclude='._*' \
    "$KINDLE_VOLUME/" "$BACKUP_DIR/"

sync
[ -d "$BACKUP_DIR/documents" ] || die 'La copia terminó sin carpeta documents; no continuar.'
files="$(find "$BACKUP_DIR" -type f | wc -l | tr -d ' ')"
[ "$files" -gt 0 ] || die 'El backup no contiene archivos.'

printf '\nBACKUP_COMPLETO_OK: %s archivos accesibles\n' "$files"
printf 'USB: DEJAR CONECTADO si se continúa con la fase de copia.\n'


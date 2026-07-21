#!/bin/bash

set -euo pipefail
source "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/_common.sh"

REPO_DIR="$(CDPATH= cd -- "$GUIDE_DIR/.." && pwd)"
BACKUP_DIR="${BACKUP_DIR:-$REPO_DIR/backup}"

require_kindle
[ -d "$BACKUP_DIR/documents" ] || die "No existe $BACKUP_DIR/documents. No borrar nada hasta localizar el backup."
[ -s "$KINDLE_VOLUME/documents/KUAL.kual" ] || die 'KUAL no está presente. Confirma el jailbreak antes de limpiar instaladores.'
[ -s "$KINDLE_VOLUME/koreader/reader.lua" ] || die 'KOReader no está presente. Completa primero su instalación y prueba de apertura.'

printf 'Se eliminarán solamente:\n'
printf '  - instaladores WinterBreak2 ya usados\n'
printf '  - Run Hotfix y volcados KPPMainAppV2\n'
printf '  - dos marcadores de LanguageBreak dentro de dictionaries\n'
printf 'Después se restaurará: %s/documents\n' "$BACKUP_DIR"
printf 'NO se toca KUAL, KOReader, MRPI, libkh ni Rename OTA Binaries.\n\n'
read -r -p 'Escribe LIMPIAR-Y-RESTAURAR para continuar: ' answer
[ "$answer" = 'LIMPIAR-Y-RESTAURAR' ] || die 'Confirmación incorrecta; no se modificó el Kindle.'

rm -rf -- \
    "$KINDLE_VOLUME/jb.sh" \
    "$KINDLE_VOLUME/patchedUks.sqsh" \
    "$KINDLE_VOLUME/winterbreak2" \
    "$KINDLE_VOLUME/winterbreak.log" \
    "$KINDLE_VOLUME/documents/Run Hotfix.run_hotfix"

find "$KINDLE_VOLUME/documents" -maxdepth 1 -name 'KPPMainAppV2_*' -exec rm -rf -- {} +
if [ -d "$KINDLE_VOLUME/documents/dictionaries" ]; then
    find "$KINDLE_VOLUME/documents/dictionaries" -maxdepth 1 -type f -name 'a; export SLASH=*' -delete
    find "$KINDLE_VOLUME/documents/dictionaries" -maxdepth 1 -type f -name 'amisane' -delete
fi

rsync -rlt \
    --exclude='._*' \
    --exclude='.DS_Store' \
    --exclude='KPPMainAppV2_*' \
    --exclude='Run Hotfix*' \
    --exclude='a; export SLASH=*' \
    --exclude='amisane' \
    "$BACKUP_DIR/documents/" "$KINDLE_VOLUME/documents/"

sync
[ -s "$KINDLE_VOLUME/documents/KUAL.kual" ] || die 'La verificación final no encuentra KUAL.'
[ -s "$KINDLE_VOLUME/koreader/reader.lua" ] || die 'La verificación final no encuentra KOReader.'
[ ! -e "$KINDLE_VOLUME/documents/Run Hotfix.run_hotfix" ] || die 'Run Hotfix no fue retirado.'

printf '\nLIMPIEZA_Y_RESTAURACION_OK: %s MB libres\n' "$(free_mb)"
eject_kindle
printf 'EXPULSION_OK\n'
printf 'USB: AHORA desconecta físicamente el cable.\n'

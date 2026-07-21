#!/bin/bash

set -euo pipefail
source "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/_common.sh"

require_kindle

printf 'Este paso elimina UNICAMENTE la carpeta de archivos dummy: %s/fill_disk\n' "$KINDLE_VOLUME"
printf 'Ejecutalo solo despues de KUAL -> Rename OTA Binaries -> Rename y del reinicio.\n'
read -r -p 'Escribe OTA-BLOQUEADA para confirmar: ' answer
[ "$answer" = 'OTA-BLOQUEADA' ] || die 'Confirmacion incorrecta; no se elimino nada.'

if [ -d "$KINDLE_VOLUME/fill_disk" ]; then
    rm -rf "$KINDLE_VOLUME/fill_disk"
fi
sync

printf '\nRELLENO_ELIMINADO_OK: %s MB libres\n' "$(free_mb)"
eject_kindle
printf 'EXPULSION_OK\n'
printf 'USB: AHORA desconecta fisicamente el cable.\n'


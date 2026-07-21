#!/bin/bash

set -euo pipefail
source "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/_common.sh"

require_kindle

[ -s "$KINDLE_VOLUME/jb.sh" ] || die 'Falta jb.sh en la raiz del Kindle.'
[ -s "$KINDLE_VOLUME/patchedUks.sqsh" ] || die 'Falta patchedUks.sqsh en la raiz del Kindle.'
[ -s "$KINDLE_VOLUME/winterbreak2/dialoger.html" ] || die 'Falta winterbreak2/dialoger.html.'

available="$(free_mb)"
case "$available" in
    ''|*[!0-9]*) die "No pude medir el espacio libre del Kindle." ;;
esac
[ "$available" -ge 50 ] && [ "$available" -le 90 ] || die "Quedaron ${available} MB libres; deben quedar entre 50 y 90 MB. Vuelve a ejecutar 02 y elige 70 MB."

shopt -s nullglob
updates=("$KINDLE_VOLUME"/update*.bin "$KINDLE_VOLUME"/update.bin.tmp.partial "$KINDLE_VOLUME"/update.partial.bin)
for update in "${updates[@]}"; do
    [ -e "$update" ] || continue
    die "Hay un archivo de actualizacion en el Kindle: $(basename "$update"). No conectes Wi-Fi; hay que retirarlo primero."
done

printf '\nVERIFICACION_PREVIA_OK: %s MB libres\n' "$available"
eject_kindle
printf 'EXPULSION_OK\n'
printf 'USB: AHORA desconecta fisicamente el cable.\n'
printf 'En el Kindle sigue la FASE 3 de la guia. NO pulses ni mantengas Power.\n'


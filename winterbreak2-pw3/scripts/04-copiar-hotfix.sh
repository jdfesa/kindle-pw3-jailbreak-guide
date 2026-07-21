#!/bin/bash

set -euo pipefail
source "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/_common.sh"

HOTFIX="$PACKAGES_DIR/Update_hotfix_universal-v2.3.7.bin"
EXPECTED_SHA='2f895b2c96a6f8232c2648b500e09463738d6e117323199f5f67d523730c9779'

require_kindle
verify_expected_firmware
verify_sha256 "$HOTFIX" "$EXPECTED_SHA"

LOG="$KINDLE_VOLUME/winterbreak.log"
[ -f "$LOG" ] || die 'No existe winterbreak.log. WinterBreak2 no llego a ejecutar el jailbreak; no instalar el hotfix.'
grep -Fq '*** Finished installing jailbreak! ***' "$LOG" || die 'winterbreak.log no contiene Finished installing jailbreak. No continuar.'
if grep -Fq 'ERR -' "$LOG"; then
    die 'winterbreak.log contiene un error. No continuar ni resetear; revisar el log.'
fi

rescue_dir="$GUIDE_DIR/archivos-update-rescatados/$(date +%Y%m%d-%H%M%S)"
shopt -s nullglob
conflicts=("$KINDLE_VOLUME"/*.bin "$KINDLE_VOLUME"/update.bin.tmp.partial "$KINDLE_VOLUME"/update.partial.bin)
for conflict in "${conflicts[@]}"; do
    [ -e "$conflict" ] || continue
    mkdir -p "$rescue_dir"
    mv "$conflict" "$rescue_dir/"
done

cp -f "$HOTFIX" "$KINDLE_VOLUME/Update_hotfix_universal.bin"
sync
cmp -s "$HOTFIX" "$KINDLE_VOLUME/Update_hotfix_universal.bin" || die 'La verificacion del hotfix copiado fallo.'

printf '\nJAILBREAK_LOG_OK\nHOTFIX_2_3_7_COPIADO_OK\n'
eject_kindle
printf 'EXPULSION_OK\n'
printf 'USB: AHORA desconecta fisicamente el cable.\n'
printf 'Siguiente: FASE 5 de la guia, instalar Update Your Kindle con Modo Avion activado.\n'


#!/bin/bash

set -euo pipefail
source "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/_common.sh"

PUBLIC_KEY="${PUBLIC_KEY:-$HOME/.ssh/id_ecdsa_kindle_pw3.pub}"
SSH_SETTINGS_DIR="$KINDLE_VOLUME/koreader/settings/SSH"
AUTHORIZED_KEYS="$SSH_SETTINGS_DIR/authorized_keys"

require_kindle
verify_expected_firmware
[ -s "$KINDLE_VOLUME/koreader/reader.lua" ] || die 'KOReader no está instalado.'
[ -s "$PUBLIC_KEY" ] || die "No existe la clave pública: $PUBLIC_KEY"

key_line="$(tr -d '\r\n' < "$PUBLIC_KEY")"
case "$key_line" in
    ecdsa-sha2-nistp256\ *) ;;
    *) die 'La clave pública no es ECDSA P-256, el formato recomendado por KOReader.' ;;
esac

mkdir -p "$SSH_SETTINGS_DIR"
touch "$AUTHORIZED_KEYS"

if ! grep -Fqx "$key_line" "$AUTHORIZED_KEYS"; then
    printf '%s\n' "$key_line" >> "$AUTHORIZED_KEYS"
fi

grep -Fqx "$key_line" "$AUTHORIZED_KEYS" || die 'La clave no quedó registrada en authorized_keys.'
sync

printf '\nKOREADER_SSH_KEY_INSTALLED_OK\n'
printf 'Destino: %s\n' "$AUTHORIZED_KEYS"
printf 'Huella esperada: SHA256:NkyP/krpXihdUjU30hQr0xUa8busmxcb/vT5AzwbkTA\n'
eject_kindle
printf 'EXPULSION_OK\n'
printf 'USB: AHORA desconecta físicamente el cable.\n'
printf 'En KOReader, deja desactivado Login without password (DANGEROUS).\n'

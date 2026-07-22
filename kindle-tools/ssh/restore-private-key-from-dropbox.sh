#!/bin/bash

set -euo pipefail

DROPBOX_ROOT="${DROPBOX_ROOT:-$HOME/Library/CloudStorage/Dropbox}"
BACKUP_DIR="$DROPBOX_ROOT/99_Archive/kindle-pw3-jailbreak-guide/ssh"
ENCRYPTED_KEY="${ENCRYPTED_KEY:-$BACKUP_DIR/id_ecdsa_kindle_pw3.enc}"
PUBLIC_KEY="${PUBLIC_KEY:-$BACKUP_DIR/id_ecdsa_kindle_pw3.pub}"
RESTORED_KEY="${RESTORED_KEY:-$HOME/.ssh/id_ecdsa_kindle_pw3.recovered}"

[ -s "$ENCRYPTED_KEY" ] || { printf 'ERROR: falta %s\n' "$ENCRYPTED_KEY" >&2; exit 1; }
[ -s "$PUBLIC_KEY" ] || { printf 'ERROR: falta %s\n' "$PUBLIC_KEY" >&2; exit 1; }
[ ! -e "$RESTORED_KEY" ] || { printf 'ERROR: %s ya existe; no se sobrescribe.\n' "$RESTORED_KEY" >&2; exit 1; }
[ -t 0 ] || { printf 'ERROR: ejecutá este script desde una terminal interactiva.\n' >&2; exit 1; }

tmp_dir="$(mktemp -d /tmp/kindle-pw3-key-restore.XXXXXX)"
trap 'rm -rf "$tmp_dir"' EXIT
pass_file="$tmp_dir/passphrase"
derived_public="$tmp_dir/derived.pub"
chmod 700 "$tmp_dir"

printf 'Contraseña de recuperación: ' >&2
IFS= read -r -s passphrase
printf '\n' >&2
printf '%s' "$passphrase" > "$pass_file"
unset passphrase
chmod 600 "$pass_file"

openssl enc -d -aes-256-cbc -pbkdf2 -iter 600000 \
    -in "$ENCRYPTED_KEY" -out "$RESTORED_KEY" -pass "file:$pass_file"
chmod 600 "$RESTORED_KEY"
ssh-keygen -y -f "$RESTORED_KEY" > "$derived_public"

derived_material="$(awk '{ print $1 " " $2 }' "$derived_public")"
expected_material="$(awk '{ print $1 " " $2 }' "$PUBLIC_KEY")"
[ "$derived_material" = "$expected_material" ] || {
    rm -f "$RESTORED_KEY"
    printf 'ERROR: la clave recuperada no corresponde a la pública archivada.\n' >&2
    exit 1
}

printf 'SSH_KEY_RESTORE_OK\n'
printf 'Clave recuperada: %s\n' "$RESTORED_KEY"
ssh-keygen -lf "$PUBLIC_KEY"
printf 'Se creó con sufijo .recovered y no se sobrescribió ninguna clave activa.\n'

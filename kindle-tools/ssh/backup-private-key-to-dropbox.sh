#!/bin/bash

set -euo pipefail

PRIVATE_KEY="${PRIVATE_KEY:-$HOME/.ssh/id_ecdsa_kindle_pw3}"
PUBLIC_KEY="${PUBLIC_KEY:-$PRIVATE_KEY.pub}"
DROPBOX_ROOT="${DROPBOX_ROOT:-$HOME/Library/CloudStorage/Dropbox}"
BACKUP_DIR="$DROPBOX_ROOT/99_Archive/kindle-pw3-jailbreak-guide/ssh"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

[ -s "$PRIVATE_KEY" ] || { printf 'ERROR: falta %s\n' "$PRIVATE_KEY" >&2; exit 1; }
[ -s "$PUBLIC_KEY" ] || { printf 'ERROR: falta %s\n' "$PUBLIC_KEY" >&2; exit 1; }
[ -d "$DROPBOX_ROOT/99_Archive" ] || { printf 'ERROR: falta Dropbox/99_Archive\n' >&2; exit 1; }

tmp_dir="$(mktemp -d /tmp/kindle-pw3-key-backup.XXXXXX)"
trap 'rm -rf "$tmp_dir"' EXIT
pass_file="$tmp_dir/passphrase"
encrypted_file="$tmp_dir/id_ecdsa_kindle_pw3.enc"
verified_file="$tmp_dir/id_ecdsa_kindle_pw3.verified"
chmod 700 "$tmp_dir"

if [ -n "${BACKUP_PASSPHRASE_FILE:-}" ]; then
    [ -s "$BACKUP_PASSPHRASE_FILE" ] || {
        printf 'ERROR: BACKUP_PASSPHRASE_FILE no existe o está vacío.\n' >&2
        exit 1
    }
    cp "$BACKUP_PASSPHRASE_FILE" "$pass_file"
elif [ -t 0 ]; then
    printf 'Contraseña de recuperación (mínimo 16 caracteres): ' >&2
    IFS= read -r -s passphrase
    printf '\nRepetir contraseña: ' >&2
    IFS= read -r -s confirmation
    printf '\n' >&2
    [ "$passphrase" = "$confirmation" ] || {
        printf 'ERROR: las contraseñas no coinciden.\n' >&2
        exit 1
    }
    [ "${#passphrase}" -ge 16 ] || {
        printf 'ERROR: la contraseña debe tener al menos 16 caracteres.\n' >&2
        exit 1
    }
    printf '%s' "$passphrase" > "$pass_file"
    unset passphrase confirmation
else
    printf 'ERROR: ejecutá este script desde una terminal para ingresar la contraseña sin mostrarla.\n' >&2
    printf 'Alternativa: define BACKUP_PASSPHRASE_FILE con un archivo guardado fuera del equipo de administración.\n' >&2
    exit 1
fi
chmod 600 "$pass_file"

openssl enc -aes-256-cbc -salt -pbkdf2 -iter 600000 \
    -in "$PRIVATE_KEY" -out "$encrypted_file" -pass "file:$pass_file"
openssl enc -d -aes-256-cbc -pbkdf2 -iter 600000 \
    -in "$encrypted_file" -out "$verified_file" -pass "file:$pass_file"
cmp -s "$PRIVATE_KEY" "$verified_file" || {
    printf 'ERROR: la copia cifrada no supera la verificación.\n' >&2
    exit 1
}

mkdir -p "$BACKUP_DIR"
cp -f "$encrypted_file" "$BACKUP_DIR/id_ecdsa_kindle_pw3.enc"
cp -f "$PUBLIC_KEY" "$BACKUP_DIR/id_ecdsa_kindle_pw3.pub"
cp -f "$SCRIPT_DIR/BACKUP_MANIFEST.txt" "$BACKUP_DIR/README.txt"
chmod 700 "$BACKUP_DIR"
chmod 600 "$BACKUP_DIR/id_ecdsa_kindle_pw3.enc" "$BACKUP_DIR/README.txt"
chmod 644 "$BACKUP_DIR/id_ecdsa_kindle_pw3.pub"

cmp -s "$encrypted_file" "$BACKUP_DIR/id_ecdsa_kindle_pw3.enc" || {
    printf 'ERROR: Dropbox no conserva una copia idéntica del archivo cifrado.\n' >&2
    exit 1
}
cmp -s "$PUBLIC_KEY" "$BACKUP_DIR/id_ecdsa_kindle_pw3.pub" || {
    printf 'ERROR: Dropbox no conserva una copia idéntica de la clave pública.\n' >&2
    exit 1
}

printf 'SSH_BACKUP_ENCRYPTED_OK\n'
printf 'Destino: %s\n' "$BACKUP_DIR"
printf 'Cifrado: AES-256-CBC, PBKDF2, 600000 iteraciones\n'
printf 'Contraseña: no almacenada; debe conservarse fuera del equipo de administración.\n'
printf 'No se copió la clave privada sin cifrar.\n'

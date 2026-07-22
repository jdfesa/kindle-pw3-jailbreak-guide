#!/bin/sh

# Configure NiLuJe USBNetwork as a physical, USB-only recovery channel.
# Run only after installing kindle-usbnet-0.22.N-r19297 with MRPI.
set -eu

usbnet=/mnt/us/usbnet
config="$usbnet/etc/config"
source_keys=/mnt/us/koreader/settings/SSH/authorized_keys
target_keys="$usbnet/etc/authorized_keys"
evidence=/mnt/us/system/usbnetwork-install-2026-07-22
backup="$evidence/config-before-local-first"

[ -f "$config" ] || {
    printf 'ERROR: USBNetwork no está instalado: %s\n' "$config" >&2
    exit 1
}
[ -s "$source_keys" ] || {
    printf 'ERROR: no existe la clave pública de recuperación: %s\n' "$source_keys" >&2
    exit 1
}
[ ! -e "$usbnet/auto" ] || {
    printf 'ERROR: el modo automático ya está activo; desactívalo antes de editar config.\n' >&2
    exit 1
}

mkdir -p "$backup"
[ -e "$backup/config" ] || cp -p "$config" "$backup/config"
[ ! -e "$target_keys" ] || [ -e "$backup/authorized_keys" ] || \
    cp -p "$target_keys" "$backup/authorized_keys"

set_config() {
    key=$1
    value=$2
    temporary="$config.tmp.$$"

    grep -q "^${key}=" "$config" || {
        printf 'ERROR: falta la opción %s en %s\n' "$key" "$config" >&2
        exit 1
    }
    sed "s|^${key}=.*|${key}=${value}|" "$config" > "$temporary"
    mv "$temporary" "$config"
}

set_config KINDLE_IP 192.168.15.244
set_config USE_WIFI '"false"'
set_config USE_WIFI_SSHD_ONLY '"false"'
set_config USE_OPENSSH '"false"'
set_config QUIET_DROPBEAR '"false"'
set_config TWEAK_MAC_ADDRESS '"false"'

cp "$source_keys" "$target_keys"
chmod 600 "$target_keys"

if grep "$(printf '\r')" "$config" >/dev/null 2>&1; then
    printf 'ERROR: config contiene finales CRLF.\n' >&2
    exit 1
fi

mkdir -p "$evidence"
{
    printf 'mode=manual-usb-only\n'
    grep -E '^(KINDLE_IP|USE_WIFI|USE_WIFI_SSHD_ONLY|USE_OPENSSH|QUIET_DROPBEAR|TWEAK_MAC_ADDRESS)=' "$config"
    printf 'authorized_keys_entries='
    grep -cve '^[[:space:]]*$' "$target_keys"
    sha256sum "$config" "$target_keys"
} > "$evidence/configured.txt"

sync
printf 'USBNETWORK_LOCAL_FIRST_CONFIG_OK\n'
cat "$evidence/configured.txt"

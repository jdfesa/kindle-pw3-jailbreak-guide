#!/bin/bash

set -euo pipefail
source "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/_common.sh"

MRPI="$PACKAGES_DIR/kual-mrinstaller-1.7.N-r19303.tar.xz"
KUAL="$PACKAGES_DIR/KUAL-c6ac782-20250419.tar.xz"

require_kindle
verify_sha256 "$MRPI" '36b3c28a44ad1a91609cc82d2bb9836ad6d7125ba1f63596307bf93f17a9255e'
verify_sha256 "$KUAL" '8dace9db8ff7b7de80662a48e830296990e978efc71c281efde43b370bc7afe3'

available="$(free_mb)"
if [ "$available" -lt 300 ]; then
    [ -d "$KINDLE_VOLUME/fill_disk" ] || die "Solo hay ${available} MB libres y no existe fill_disk para liberar espacio."
    printf 'Hay %s MB libres. Se eliminaran solamente archivos dummy de fill_disk hasta superar 300 MB.\n' "$available"
    read -r -p 'Escribe SI para continuar: ' answer
    [ "$answer" = 'SI' ] || die 'Operacion cancelada; no se elimino nada.'
    while IFS= read -r filler; do
        rm -f "$filler"
        available="$(free_mb)"
        [ "$available" -ge 300 ] && break
    done < <(find "$KINDLE_VOLUME/fill_disk" -type f -name 'file_*' | sort)
fi

available="$(free_mb)"
[ "$available" -ge 220 ] || die "Quedan ${available} MB libres; KUAL/MRPI requieren al menos 220 MB."

tmp_dir="$(mktemp -d /tmp/kual-mrpi-copy.XXXXXX)"
trap 'rm -rf "$tmp_dir"' EXIT
mkdir -p "$tmp_dir/mrpi" "$tmp_dir/kual"
tar -xJf "$MRPI" -C "$tmp_dir/mrpi"
tar -xJf "$KUAL" -C "$tmp_dir/kual"

rescue_dir="$GUIDE_DIR/archivos-update-rescatados/$(date +%Y%m%d-%H%M%S)"
shopt -s nullglob
conflicts=("$KINDLE_VOLUME"/*.bin "$KINDLE_VOLUME"/update.bin.tmp.partial "$KINDLE_VOLUME"/update.partial.bin)
for conflict in "${conflicts[@]}"; do
    [ -e "$conflict" ] || continue
    mkdir -p "$rescue_dir"
    mv "$conflict" "$rescue_dir/"
done

mkdir -p "$KINDLE_VOLUME/extensions" "$KINDLE_VOLUME/mrpackages"
rsync -a "$tmp_dir/mrpi/extensions/MRInstaller" "$KINDLE_VOLUME/extensions/"

# En el PW3 verificado, `;log mrpi` no lanzó MRPI. La instalación que sí
# funcionó fue colocar el paquete OTA de KUAL en la raíz y usar
# Settings -> Advanced Options -> Update Your Kindle.
kual_package='Update_KUALBooklet_hotfix_c6ac782_install.bin'
cp -f "$tmp_dir/kual/$kual_package" "$KINDLE_VOLUME/$kual_package"
sync

[ -s "$KINDLE_VOLUME/extensions/MRInstaller/bin/mrinstaller.sh" ] || die 'MRPI no quedo completo.'
cmp -s "$tmp_dir/kual/$kual_package" "$KINDLE_VOLUME/$kual_package" || die 'La verificacion de KUAL fallo.'

printf '\nKUAL_DIRECTO_Y_MRPI_COPIADOS_OK: %s MB libres\n' "$(free_mb)"
eject_kindle
printf 'EXPULSION_OK\n'
printf 'USB: AHORA desconecta fisicamente el cable.\n'
printf 'Siguiente: Settings -> Advanced Options -> Update Your Kindle.\n'

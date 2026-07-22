#!/bin/bash

set -euo pipefail
source "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/_common.sh"

REPO_ROOT="$(CDPATH= cd -- "$GUIDE_DIR/.." && pwd)"
SOURCE_IMAGE="$REPO_ROOT/assets/screensavers/library-mountain-pw3.png"
SOURCE_PATCH="$REPO_ROOT/kindle-tools/koreader-personalization/2-enable-screensaver-on-special-offers.lua"
KOREADER_DIR="$KINDLE_VOLUME/koreader"
SETTINGS_FILE="$KOREADER_DIR/settings.reader.lua"
TARGET_IMAGE="$KOREADER_DIR/screensavers/library-mountain-pw3.png"
TARGET_PATCH="$KOREADER_DIR/patches/2-enable-screensaver-on-special-offers.lua"
BACKUP_FILE="$SETTINGS_FILE.pre-custom-screensaver.bak"

require_kindle
verify_expected_firmware
[ -s "$KOREADER_DIR/reader.lua" ] || die 'KOReader no está instalado.'
[ -s "$SETTINGS_FILE" ] || die 'Falta la configuración de KOReader. Abrilo y cerralo normalmente una vez.'
[ -s "$SOURCE_IMAGE" ] || die "Falta la imagen optimizada: $SOURCE_IMAGE"
[ -s "$SOURCE_PATCH" ] || die "Falta el user patch: $SOURCE_PATCH"

mkdir -p "$KOREADER_DIR/screensavers" "$KOREADER_DIR/patches"
cp -f "$SOURCE_IMAGE" "$TARGET_IMAGE"
cp -f "$SOURCE_PATCH" "$TARGET_PATCH"

if [ ! -e "$BACKUP_FILE" ]; then
    cp -p "$SETTINGS_FILE" "$BACKUP_FILE"
fi

tmp_settings="$(mktemp "$KOREADER_DIR/.settings.reader.lua.XXXXXX")"
trap 'rm -f "$tmp_settings"' EXIT

awk '
    /^[[:space:]]*\["screensaver_document_cover"\][[:space:]]*=/ { next }
    /\["screensaver_delay"\][[:space:]]*=/ {
        print
        print "    [\"screensaver_document_cover\"] = \"/mnt/us/koreader/screensavers/library-mountain-pw3.png\","
        next
    }
    /\["screensaver_show_message"\][[:space:]]*=/ {
        print "    [\"screensaver_show_message\"] = false,"
        next
    }
    /\["screensaver_stretch_images"\][[:space:]]*=/ {
        print "    [\"screensaver_stretch_images\"] = true,"
        next
    }
    /\["screensaver_type"\][[:space:]]*=/ {
        print "    [\"screensaver_type\"] = \"document_cover\","
        next
    }
    { print }
' "$SETTINGS_FILE" > "$tmp_settings"

mv "$tmp_settings" "$SETTINGS_FILE"
trap - EXIT

cmp -s "$SOURCE_IMAGE" "$TARGET_IMAGE" || die 'La verificación de la imagen copiada falló.'
cmp -s "$SOURCE_PATCH" "$TARGET_PATCH" || die 'La verificación del user patch copiado falló.'
grep -Fq '["screensaver_type"] = "document_cover"' "$SETTINGS_FILE" || die 'No se activó el fondo personalizado.'
grep -Fq '["screensaver_document_cover"] = "/mnt/us/koreader/screensavers/library-mountain-pw3.png"' "$SETTINGS_FILE" || die 'La ruta del fondo no quedó registrada.'

printf '\nKOREADER_PERSONALIZADO_OK\n'
printf 'Fondo: %s\n' "$TARGET_IMAGE"
printf 'Backup: %s\n' "$BACKUP_FILE"
eject_kindle
printf 'EXPULSION_OK\n'
printf 'USB: AHORA desconecta físicamente el cable.\n'
printf 'Abre KUAL -> KOReader -> Start KOReader y suspende el equipo para probar.\n'

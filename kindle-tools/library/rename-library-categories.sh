#!/bin/sh

# One-time, reversible structural migration from the initial Spanish folder
# names to the English convention used by the Kindle/KOReader environment.
set -eu

documents=/mnt/us/documents
old_library="$documents/Biblioteca"
new_library="$documents/Library"
migration_root=/mnt/us/system/library-migrations/2026-07-22-english-names-v2
before_manifest="$migration_root/before.books.sha256"
after_manifest="$migration_root/after.books.sha256"
moves_manifest="$migration_root/moves.tsv"
dry_run=${DRY_RUN:-0}

book_count() {
    find "$documents" -type f \( \
        -iname '*.epub' -o -iname '*.mobi' -o -iname '*.azw' -o \
        -iname '*.azw3' -o -iname '*.pdf' -o -iname '*.djvu' -o \
        -iname '*.fb2' -o -iname '*.cbz' -o -iname '*.cbr' \
    \) | wc -l
}

hash_books() {
    output=$1
    find "$documents" -type f \( \
        -iname '*.epub' -o -iname '*.mobi' -o -iname '*.azw' -o \
        -iname '*.azw3' -o -iname '*.pdf' -o -iname '*.djvu' -o \
        -iname '*.fb2' -o -iname '*.cbz' -o -iname '*.cbr' \
    \) -exec sha256sum '{}' ';' | sort -k2 > "$output"
}

rename_inside_library() {
    old_relative=$1
    new_relative=$2
    source_path="$old_library/$old_relative"
    destination_path="$old_library/$new_relative"

    if [ ! -e "$source_path" ]; then
        [ -e "$destination_path" ] && return 0
        printf 'ERROR: no existe %s\n' "$source_path" >&2
        exit 1
    fi
    [ ! -e "$destination_path" ] || {
        printf 'ERROR: destino existente %s\n' "$destination_path" >&2
        exit 1
    }

    if [ "$dry_run" = 1 ]; then
        printf 'RENAME\t%s\t%s\n' "$source_path" "$destination_path"
        return 0
    fi

    mv "$source_path" "$destination_path"
    printf '%s\t%s\n' "$source_path" "$destination_path" >> "$moves_manifest"
}

if [ ! -d "$old_library" ] && [ -d "$new_library" ]; then
    printf 'LIBRARY_ENGLISH_NAMES_ALREADY_APPLIED\n'
    exit 0
fi
[ -d "$old_library" ] || {
    printf 'ERROR: no existe %s\n' "$old_library" >&2
    exit 1
}
[ ! -e "$new_library" ] || {
    printf 'ERROR: existen ambas bibliotecas: %s y %s\n' "$old_library" "$new_library" >&2
    exit 1
}

if [ "$dry_run" != 1 ]; then
    [ ! -e "$migration_root/SUCCESS" ] || {
        printf 'ERROR: la migración ya terminó: %s\n' "$migration_root" >&2
        exit 1
    }
    mkdir -p "$migration_root"
    : > "$moves_manifest"
    initial_count=$(book_count)
    hash_books "$before_manifest"
fi

# Rename nested folders before their parent.
rename_inside_library '03_Tecnologia/01_Programacion' '03_Tecnologia/01_Programming'
rename_inside_library '03_Tecnologia/02_Bases_de_Datos' '03_Tecnologia/02_Databases'
rename_inside_library '03_Tecnologia/03_Sistemas' '03_Tecnologia/03_Systems'
rename_inside_library '03_Tecnologia/04_Seguridad' '03_Tecnologia/04_Security'
rename_inside_library '03_Tecnologia/05_Gestion_y_Negocios' '03_Tecnologia/05_Management_and_Business'
rename_inside_library '03_Tecnologia/06_Otros' '03_Tecnologia/06_Other'

rename_inside_library '01_Literatura' '01_Literature'
rename_inside_library '02_Filosofia_y_Ensayo' '02_Philosophy_and_Essays'
rename_inside_library '03_Tecnologia' '03_Technology'
rename_inside_library '04_Referencia_y_Revistas' '04_Reference_and_Magazines'
rename_inside_library '90_Pendientes_de_Clasificar' '90_Inbox'
rename_inside_library '99_Archivo' '99_Archive'

if [ "$dry_run" = 1 ]; then
    printf 'RENAME\t%s\t%s\n' "$old_library" "$new_library"
    printf 'LIBRARY_ENGLISH_NAMES_DRY_RUN_OK\n'
    exit 0
fi

mv "$old_library" "$new_library"
printf '%s\t%s\n' "$old_library" "$new_library" >> "$moves_manifest"

final_count=$(book_count)
[ "$initial_count" -eq "$final_count" ] || {
    printf 'ERROR: cantidad de libros %s -> %s\n' "$initial_count" "$final_count" >&2
    exit 1
}

hash_books "$after_manifest"
awk '{ print $1 }' "$before_manifest" | sort > "$migration_root/before.hashes"
awk '{ print $1 }' "$after_manifest" | sort > "$migration_root/after.hashes"
cmp -s "$migration_root/before.hashes" "$migration_root/after.hashes" || {
    printf 'ERROR: cambió el conjunto de libros durante el renombrado.\n' >&2
    exit 1
}

{
    printf 'books=%s\n' "$final_count"
    printf 'book_hashes=identical\n'
} > "$migration_root/SUCCESS"

printf 'LIBRARY_ENGLISH_NAMES_OK\n'
printf 'Libros conservados: %s\n' "$final_count"
printf 'Manifiesto: %s\n' "$moves_manifest"

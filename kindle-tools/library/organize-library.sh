#!/bin/sh

set -eu

documents=/mnt/us/documents
library="$documents/Library"
migration_root=/mnt/us/system/library-migrations/2026-07-21-v1
before_manifest="$migration_root/before.books.sha256"
after_manifest="$migration_root/after.books.sha256"
before_inventory="$migration_root/before.files.sha256"
after_inventory="$migration_root/after.files.sha256"
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

inventory_files() {
    output=$1
    find "$documents" -type f -exec sha256sum '{}' ';' | sort -k2 > "$output"
}

move_dir() {
    destination_parent=$1
    name=$2
    source_path="$documents/$name"
    destination_path="$library/$destination_parent/$name"

    if [ ! -d "$source_path" ]; then
        [ -d "$destination_path" ] && return 0
        printf 'ERROR: no existe %s\n' "$source_path" >&2
        exit 1
    fi
    [ ! -e "$destination_path" ] || {
        printf 'ERROR: destino existente %s\n' "$destination_path" >&2
        exit 1
    }

    if [ "$dry_run" = 1 ]; then
        printf 'MOVE_DIR\t%s\t%s\n' "$source_path" "$destination_path"
        return 0
    fi

    mkdir -p "$library/$destination_parent"
    mv "$source_path" "$destination_path"
    printf '%s\t%s\n' "$source_path" "$destination_path" >> "$moves_manifest"
}

move_item() {
    destination_parent=$1
    source_path=$2
    destination_path="$library/$destination_parent/${source_path##*/}"

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
        printf 'MOVE_ITEM\t%s\t%s\n' "$source_path" "$destination_path"
        return 0
    fi

    mkdir -p "$library/$destination_parent"
    mv "$source_path" "$destination_path"
    printf '%s\t%s\n' "$source_path" "$destination_path" >> "$moves_manifest"
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
    inventory_files "$before_inventory"
fi

# Literatura: ficción, poesía, narrativa y memorias.
for name in \
    'Benavent, Elisabet' 'Borges, Jorge Luis' 'Bradbury, Ray' 'Brown, Dan' \
    'Card, Orson Scott' 'Cortazar, Julio' 'Dostoyevski, Fiodor' \
    'Espinosa, Albert' 'Gier, Kerstin' 'Handler, Daniel' 'Hesse, Hermann' \
    'Invisibles, Las Ciudades' 'Luca de Tena, Torcuato' \
    'Marquez, Gabriel Garcia' 'Moyes, Jojo' 'Murakami, Haruki' \
    'Neruda, Pablo' 'Northup, Solomon' 'Pessoa, Fernando' \
    'Pessoa, Fernando, Nombres' 'Poe, Edgar Allan' 'Rulfo, Juan' \
    'Saint-Exupery, Antoine de' 'Solzhenitsyn, Aleksandr' \
    'Spinetta, Luis Alberto' 'Voltaire' 'Woolf, Virginia' 'Zusak, Markus' \
    'paolalucantis'
do
    move_dir '01_Literature' "$name"
done

# Filosofía, psicología, ensayo y desarrollo personal.
for name in \
    'Ariely, Dan' 'Aristoteles' 'Rol_n, Gabriel' 'Rolon, Gabriel' \
    'Sinek, Simon' 'Stamateas, Bernardo'
do
    move_dir '02_Philosophy_and_Essays' "$name"
done

# Tecnología dividida por el uso con el que normalmente se busca el material.
for name in \
    'Belarmino' 'Deitel, Harvey M_' 'Garcia, Miguel Angel Duran' \
    'Gauchat, J.D_' 'Miguel Bonilla' 'Moure, Brais' 'USERS'
do
    move_dir '03_Technology/01_Programming' "$name"
done

for name in \
    'Android' 'Elmasri, Ramez' 'Fernandez, Dolores Cuadra' \
    'Ibanez, Luis Hueso' 'Jose' 'Oppel, Andy(Author)' \
    'Sevilla, Unai Estebanez'
do
    move_dir '03_Technology/02_Databases' "$name"
done

for name in 'Pc' 'Peddicord, Jacob' 'Semiconductor, TOSHIBA'
do
    move_dir '03_Technology/03_Systems' "$name"
done

for name in \
    'A., Ussiel' 'Aguirre, Jorge Ramio' 'BUSIRAKO' 'Chema' 'Dani' 'H47' \
    'Lopez, Manuel Jose Lucena' 'Newman, Aaron' 'Security, Offensive' 'jfuentec'
do
    move_dir '03_Technology/04_Security' "$name"
done

move_dir '03_Technology/05_Management_and_Business' 'Robbins, Stephen P_'

# Publicaciones periódicas y material de consulta.
move_dir '04_Reference_and_Magazines' 'Octubre 2015'

# Carpetas mixtas o con metadatos insuficientes: se preservan y se clasifican
# manualmente durante la fase de pulido.
for name in 'Desconocido' 'Final, Usuario' 'Unknown' 'rooter'
do
    move_dir '90_Inbox' "$name"
done

# Dos libros estaban sueltos en documents.
move_item '02_Philosophy_and_Essays/Cioran, E.M.' \
    "$documents/(Microsoft Word - EN LAS CIMAS DE LA DESESPERACI_323N - completo) - E.M. Cioran.mobi"
move_item '02_Philosophy_and_Essays/Cioran, E.M.' \
    "$documents/(Microsoft Word - EN LAS CIMAS DE LA DESESPERACI_323N - completo) - E.M. Cioran.sdr"
move_item '04_Reference_and_Magazines' "$documents/Kindle_Users_Guide.azw3"
move_item '04_Reference_and_Magazines' "$documents/Kindle_Users_Guide.sdr"

if [ "$dry_run" = 1 ]; then
    printf 'LIBRARY_ORGANIZATION_DRY_RUN_OK\n'
    exit 0
fi

mkdir -p \
    "$library/03_Technology/06_Other" \
    "$library/90_Inbox" \
    "$library/99_Archive"

final_count=$(book_count)
[ "$initial_count" -eq "$final_count" ] || {
    printf 'ERROR: cantidad de libros %s -> %s\n' "$initial_count" "$final_count" >&2
    exit 1
}

hash_books "$after_manifest"
inventory_files "$after_inventory"
awk '{ print $1 }' "$before_manifest" | sort > "$migration_root/before.hashes"
awk '{ print $1 }' "$after_manifest" | sort > "$migration_root/after.hashes"
cmp -s "$migration_root/before.hashes" "$migration_root/after.hashes" || {
    printf 'ERROR: cambió el conjunto de libros durante la migración.\n' >&2
    exit 1
}

printf 'books=%s\n' "$final_count" > "$migration_root/SUCCESS"
printf 'LIBRARY_ORGANIZATION_OK\n'
printf 'Libros conservados: %s\n' "$final_count"
printf 'Manifiesto: %s\n' "$moves_manifest"

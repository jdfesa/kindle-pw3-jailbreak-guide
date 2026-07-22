# Organización de la biblioteca local

## Resultado verificado

El 22 de julio de 2026 quedaron verificados:

- 113 libros antes y después de ambas migraciones;
- 111 libros dentro de `/mnt/us/documents/Library`;
- 2 diccionarios en `/mnt/us/documents/dictionaries`;
- igualdad del conjunto SHA-256 de los 113 archivos de lectura;
- 72 movimientos en la organización inicial y 13 renombrados estructurales;
- conservación de carpetas `.sdr`, progreso, notas y metadatos.

La organización intermedia usó nombres en español. Se migró después a nombres
estructurales en inglés para mantener consistencia con Kindle y KOReader. Los
títulos, autores y contenido conservan su idioma original.

## Estructura diaria

```text
/mnt/us/documents/Library/
├── 01_Literature/
│   └── Lastname, Firstname/
├── 02_Philosophy_and_Essays/
│   └── Lastname, Firstname/
├── 03_Technology/
│   ├── 01_Programming/
│   ├── 02_Databases/
│   ├── 03_Systems/
│   ├── 04_Security/
│   ├── 05_Management_and_Business/
│   └── 06_Other/
├── 04_Reference_and_Magazines/
├── 90_Inbox/
└── 99_Archive/
```

Los diccionarios permanecen en `documents/dictionaries` para que el sistema y
KOReader puedan detectarlos. KUAL, aplicaciones, `My Clippings.txt` y archivos
técnicos tampoco se mezclan con `Library`.

## Criterio de mantenimiento

Todo libro nuevo entra primero en `Library/90_Inbox`. Después se mueve, junto
con su carpeta `.sdr` si existe, a una de las pocas categorías estables. La
clasificación no depende de si el libro está leído o pendiente.

El objetivo no es una taxonomía académica perfecta. Se priorizan:

1. pocas decisiones para incorporar un libro;
2. pocas categorías previsibles para encontrarlo;
3. autores agrupados dentro de cada categoría;
4. una bandeja explícita para lo todavía no clasificado;
5. ninguna mezcla entre libros y componentes técnicos.

Los nombres estructurales son ingleses; no se traducen ni se anglicanizan
títulos de libros o nombres propios. Las anomalías de metadatos —por ejemplo,
autores duplicados o texto con codificación dañada— se corrigen en una fase
posterior y sólo después de verificar progreso e historial.

## Interfaz diaria de KOReader

`2-library-home.lua` fija `/mnt/us/documents/Library` como HOME bloqueada de
KOReader y selecciona mosaico de portadas con progreso. Así no aparecen en la
navegación habitual `extensions`, `fonts`, `koreader`, `libkh`, `mrpackages` ni
`system`; esas carpetas no se renombran ni se alteran.

Retirar el parche y reiniciar KOReader restaura el navegador sin restricciones.

## Evidencia y recuperación

La primera migración conserva manifiestos en:

```text
/mnt/us/system/library-migrations/2026-07-21-v1/
```

Su comparación inicial de todos los archivos detectó dos elementos nuevos. La
auditoría demostró que eran reportes `KPPMainAppV2` generados por Amazon durante
la operación: no hubo hashes eliminados y los 113 hashes de libros fueron
idénticos. Los reportes se conservaron en `incidental-kpp-crash/`, fuera de la
biblioteca diaria, y `SUCCESS` registra el resultado.

La traducción de carpetas conserva evidencia separada en:

```text
/mnt/us/system/library-migrations/2026-07-22-english-names-v2/
```

Cada directorio incluye `moves.tsv`, manifiestos anteriores y posteriores, y
un marcador `SUCCESS`. Para revertir rutas se recorre `moves.tsv` de abajo hacia
arriba; los libros no necesitan restaurarse desde otra copia porque sólo se
usó `mv` dentro del mismo volumen.

## Automatización

- `organize-library.sh`: reproduce desde el estado original directamente hacia
  la estructura inglesa y valida sólo archivos de lectura como contenido
  inmutable. El inventario completo se conserva como evidencia, pero no se usa
  para fallar si una aplicación crea metadatos o logs mientras corre.
- `rename-library-categories.sh`: migración idempotente desde la estructura
  española intermedia hacia la convención inglesa actual.

Ambos scripts admiten `DRY_RUN=1` y se prueban así antes de una ejecución real.

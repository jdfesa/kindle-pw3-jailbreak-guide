# Herramientas de biblioteca

`organize-library.sh` migra la biblioteca original directamente a la taxonomía
inglesa documentada en `docs/ORGANIZACION_BIBLIOTECA.md`. Mueve carpetas
completas para conservar los `.sdr`, no convierte formatos y verifica tanto la
cantidad como el conjunto de hashes de los archivos de lectura.

La primera ejecución siempre se revisa en modo simulación:

```bash
DRY_RUN=1 /mnt/us/system/tools/organize-library.sh
```

La ejecución real escribe su evidencia en:

```text
/mnt/us/system/library-migrations/2026-07-21-v1/
```

La fase uno no corrige nombres ni fusiona autores. Esas decisiones se toman
después de verificar progreso e historial, para que un error de metadatos no se
confunda con un error estructural.

`rename-library-categories.sh` es la migración única aplicada al dispositivo
que ya tenía la estructura española intermedia. Cambia únicamente nombres de
directorios, conserva 113 hashes de libros y escribe su propia evidencia en:

```text
/mnt/us/system/library-migrations/2026-07-22-english-names-v2/
```

Simulación obligatoria:

```bash
DRY_RUN=1 /mnt/us/system/tools/rename-library-categories.sh
```

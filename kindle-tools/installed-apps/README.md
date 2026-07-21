# Menú `Installed Apps` para KUAL

Este menú agrupa en KUAL las aplicaciones verificadas en el dispositivo de prueba. No contiene aplicaciones, no cambia sus archivos y no altera la base de datos de Collections.

## Motivo

Las aplicaciones instaladas aparecen repartidas entre Library y KUAL. Mover sus carpetas por USB no es seguro porque varios lanzadores apuntan a rutas absolutas como `/mnt/us/documents/KNotes`. Este menú conserva esas rutas y ofrece un único punto de entrada:

```text
KUAL → Installed Apps
```

## Instalación manual

Con el Kindle montado como `/Volumes/Kindle`, crear la carpeta `installed_apps` y copiar únicamente `menu.json`:

```text
/Volumes/Kindle/extensions/installed_apps/menu.json
```

Después hay que expulsar el volumen de forma segura, desconectar el cable, cerrar KUAL si estaba abierto y volver a abrirlo.

## Qué enlaza

- KOReader;
- KindleForge;
- KNotes;
- KPomo;
- KAnki;
- KWordle;
- Check OTA Protection, que corresponde al paquete `UpdateBlock Status`;
- kTerm;
- KindleFetch.

Los accesos sólo funcionan mientras cada aplicación conserve su ruta original. Si se desinstala una aplicación, también debe quitarse su entrada de `menu.json`.

## Limitaciones

- No oculta los lanzadores que ya aparecen en Library.
- No crea una Collection nativa.
- No instala ni actualiza aplicaciones.
- KindleFetch conserva sus riesgos legales y de seguridad; el menú no cambia su funcionamiento.

Para ordenar también Library, crear manualmente una Collection llamada `Applications` y añadir allí los documentos de lanzamiento. No se automatiza esa operación porque las Collections pertenecen al estado interno del usuario.

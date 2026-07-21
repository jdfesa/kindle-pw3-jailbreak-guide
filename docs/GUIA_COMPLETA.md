# Guía completa y verificada: Kindle Paperwhite 3 con WinterBreak2 desde macOS

Última verificación práctica: **21 de julio de 2026**.

Esta guía documenta una liberación terminada y comprobada sobre este equipo:

- Kindle Paperwhite 3, 7.ª generación, año 2015.
- Prefijo de serie probado: `G090G1`.
- Firmware probado: `5.16.2.1.1`.
- Arquitectura de aplicaciones: `soft-float`.
- Computadora: macOS.
- Punto de montaje esperado: `/Volumes/Kindle`.

El resultado comprobado incluye:

- jailbreak persistente;
- KUAL funcionando;
- bloqueo de actualizaciones OTA;
- KOReader 2026.03 para PDF, EPUB, DjVu, CBZ y otros formatos;
- KindleForge 4.1.0 como gestor opcional de aplicaciones;
- restauración de libros y metadatos desde un backup local;
- eliminación de archivos de instalación, Demo Mode, LanguageBreak y volcados KPP.

> No aplicar automáticamente esta guía a otro modelo o firmware. Confirmar primero el modelo por el prefijo de serie y la versión en `Settings → Device Options → Device Info`.

## La ruta que realmente funcionó

```text
Backup de USB
  ↓
WinterBreak2 v1.0.0 en el navegador
  ↓
Hotfix universal 2.3.7 mediante Update Your Kindle
  ↓
Run Hotfix una sola vez
  ↓
KUAL de NiLuJe instalado directamente mediante Update Your Kindle
  ↓
KUAL abre: jailbreak confirmado
  ↓
Rename OTA Binaries → Rename
  ↓
Quitar relleno → KOReader kindlepw2 → limpiar → restaurar libros
  ↓
KindleForge opcional
```

Dos rutas se descartaron después de probarlas:

1. **LanguageBreak mediante Demo Mode:** produjo ciclos entre idiomas, registro demo y lista de redes. La ventana USB de pocos segundos y el estado posterior a `Resell Device` no fueron reproducibles en este PW3.
2. **KUAL mediante `;log mrpi`:** MRPI se copió correctamente, pero la orden regresaba silenciosamente a `Home` y el paquete permanecía en `mrpackages`. La solución comprobada fue poner el `.bin` de KUAL en la raíz e instalarlo desde `Update Your Kindle`.

## Reglas que evitan la mayoría de los errores

1. **No resetear de fábrica para solucionar una fase.** WinterBreak2 no requiere Demo Mode ni selección de idioma.
2. **No tocar Power durante el procedimiento**, salvo un reinicio normal solicitado explícitamente por el sistema.
3. **No desconectar el USB hasta ver `EXPULSION_OK`.** Después de esa línea sí se desconecta físicamente.
4. **Modo avión siempre**, excepto durante los minutos necesarios para abrir WinterBreak2 o usar KindleForge después del bloqueo OTA.
5. **No usar Hotfix 2.5.0 en esta combinación.** En PW3/5.16.2.1.1 se observaron `Application Error` con esa versión. Esta guía fija 2.3.7.
6. **No usar PEKI para KUAL en este equipo.** La combinación probada es el paquete de NiLuJe `KUAL-c6ac782-20250419`.
7. Si una pantalla no coincide, no improvisar: activar Modo avión, fotografiar la pantalla y detener esa fase.

## Estado del cable y la red, de principio a fin

| Fase | USB | Red | Acción |
|---|---|---|---|
| Backup | Conectado | Modo avión | Copiar el contenido accesible al Mac |
| Preparación | Conectado | Modo avión | Copiar WinterBreak2 y dejar 50–90 MB libres |
| Jailbreak web | Desconectado | Wi‑Fi encendido temporalmente | Abrir la página y esperar el texto final |
| Copia del hotfix | Conectado | Modo avión | Verificar el log y copiar Hotfix 2.3.7 |
| Instalación del hotfix | Desconectado | Modo avión | `Update Your Kindle` y después `Run Hotfix` |
| Copia de KUAL | Conectado | Modo avión | Copiar MRPI y KUAL directo a la raíz |
| Instalación de KUAL | Desconectado | Modo avión | `Update Your Kindle` y abrir KUAL |
| Copia del bloqueo OTA | Conectado | Modo avión | Copiar extensión Rename OTA |
| Activar bloqueo OTA | Desconectado | Modo avión | KUAL → Rename OTA Binaries → Rename |
| Quitar relleno | Conectado hasta `EXPULSION_OK` | Modo avión | Recuperar el espacio |
| KOReader | Conectado hasta `EXPULSION_OK` | Modo avión | Copiar aplicación y extensión KUAL |
| Limpieza/restauración | Conectado hasta `EXPULSION_OK` | Modo avión | Retirar instaladores y devolver libros |
| KindleForge | Conectado hasta `EXPULSION_OK` | Modo avión | Copiar; Wi‑Fi se habilita después, si se usa |

## Preparar el repositorio

Desde Terminal, entrar en el directorio clonado y verificar herramientas:

```bash
cd kindle-pw3-jailbreak-guide
bash --version
diskutil list
```

Los scripts usan Bash, `diskutil`, `rsync`, `unzip`, `tar`, `shasum`, `cmp` y `curl`. Todos vienen incluidos en una instalación normal de macOS, salvo cambios futuros de Apple.

Descargar los paquetes en `winterbreak2-pw3/paquetes/` siguiendo [paquetes/README.md](../winterbreak2-pw3/paquetes/README.md). Los binarios están excluidos de Git deliberadamente.

Verificarlos antes de tocar el Kindle:

```bash
./winterbreak2-pw3/scripts/00-verificar-paquetes.sh
```

No continuar hasta ver:

```text
TODOS_LOS_PAQUETES_VERIFICADOS_OK
```

## Fase 0 — Confirmar modelo, firmware y estado inicial

USB: **desconectado**.

Red: **Modo avión**.

1. Abrir `Settings → Device Options → Device Info`.
2. Confirmar firmware `5.16.2.1.1`.
3. Confirmar que el prefijo del número de serie corresponda a PW3; `G090G1` es PW3 Wi‑Fi.
4. Activar Modo avión.
5. Volver a `Home`.

Si el Kindle está en `Welcome to Kindle` después de un reset anterior:

1. elegir `English (United States)`;
2. en la lista de Wi‑Fi usar `Set up later`;
3. llegar a `Home`;
4. activar Modo avión.

No entrar en Demo Mode. No usar `;enter_demo`, `;demo`, `Sideload Content` ni `Resell Device`.

## Fase 1 — Crear y comprobar el backup

USB: conectar ahora y dejar conectado.

Red: Modo avión.

1. Esperar a que Finder muestre el volumen `Kindle`.
2. Ejecutar:

```bash
./winterbreak2-pw3/scripts/00-crear-backup.sh
```

3. La copia queda en `backup/` en la raíz del repositorio.
4. Debe aparecer:

```text
BACKUP_COMPLETO_OK: ... archivos accesibles
USB: DEJAR CONECTADO
```

5. Abrir `backup/documents` en Finder y comprobar visualmente algunos libros.

El backup está ignorado por Git porque contiene libros, anotaciones y datos personales. No forzar su inclusión en GitHub.

Si `rsync` informa un error de lectura, anotar el nombre exacto. No declarar completo ese archivo. En la ejecución documentada, dos entradas dañadas del almacenamiento original no pudieron leerse; los demás archivos accesibles sí quedaron respaldados.

## Fase 2 — Copiar WinterBreak2

USB: sigue conectado desde el backup.

Red: Modo avión.

Ejecutar:

```bash
./winterbreak2-pw3/scripts/01-copiar-winterbreak2.sh
```

El script:

- comprueba el firmware cuando `system/version.txt` es visible;
- valida SHA‑256 de WinterBreak2;
- copia `jb.sh`, `patchedUks.sqsh` y `winterbreak2/dialoger.html`;
- compara byte por byte lo escrito.

Salida obligatoria:

```text
COPIA_WINTERBREAK2_OK
USB: DEJAR CONECTADO.
```

No expulsar ni desconectar todavía.

## Fase 3 — Dejar entre 50 y 90 MB libres

WinterBreak2 necesita poco espacio libre durante la ventana con Wi‑Fi. El objetivo probado fue **70 MB**.

USB: sigue conectado.

Red: Modo avión.

Ejecutar:

```bash
./winterbreak2-pw3/scripts/02-rellenar-espacio.sh
```

En `Filler.sh`, responder:

1. `Choice (1-2) [1]:` → Enter para elegir `Fill`.
2. `Enter your choice (1-4) [1]:` → `4` y Enter.
3. `minimum free space in MB` → `70` y Enter.
4. `Proceed with filling this device?` → `y` y Enter.
5. Cuando muestre `Disk fill complete`, pulsar Enter una vez.

Después ejecutar:

```bash
./winterbreak2-pw3/scripts/03-verificar-y-expulsar.sh
```

Salida válida:

```text
VERIFICACION_PREVIA_OK: 70 MB libres
EXPULSION_OK
USB: AHORA desconecta fisicamente el cable.
```

El valor puede variar, pero el script sólo acepta de 50 a 90 MB. Después de `EXPULSION_OK`, desconectar físicamente el cable.

## Fase 4 — Ejecutar WinterBreak2 desde el navegador

USB: **desconectado durante toda esta fase**.

Red: se habilita solamente ahora.

1. Desactivar Modo avión.
2. Conectar el Kindle a Wi‑Fi con Internet.
3. No registrarlo en Amazon y no abrir Kindle Store.
4. Abrir `Web Browser` o `Experimental Browser`, según el texto de la interfaz.
5. Ir exactamente a:

```text
https://winterbreak2.now.sh/
```

6. Esperar la página de WinterBreak2.
7. Tocar `Jailbreak` una sola vez.
8. Aceptar los cuadros de confirmación que aparezcan.
9. No salir al descargar el archivo intermedio. Esperar el texto en la página.
10. El éxito requiere ver el bloque completo:

```text
*** Finished installing jailbreak! ***
*** Please Install HOTFIX now ***
```

11. Activar **Modo avión inmediatamente**.

No basta con que se descargue algo o con que la página solicite una donación. La prueba es el texto `Finished installing jailbreak`.

Si se tocó `Jailbreak` varias veces, `winterbreak.log` puede contener varias ejecuciones exitosas. Eso no requiere resetear; la siguiente fase comprueba que no exista `ERR -`.

## Fase 5 — Copiar e instalar Hotfix 2.3.7

USB: conectar ahora.

Red: Modo avión.

Ejecutar:

```bash
./winterbreak2-pw3/scripts/04-copiar-hotfix.sh
```

El script exige que `/Volumes/Kindle/winterbreak.log` contenga el éxito y no contenga `ERR -`. Después copia el hotfix y expulsa.

Salida obligatoria:

```text
JAILBREAK_LOG_OK
HOTFIX_2_3_7_COPIADO_OK
EXPULSION_OK
```

Desconectar físicamente el USB.

En el Kindle:

1. abrir `Settings`;
2. abrir el menú de tres puntos;
3. entrar en `Advanced Options` si existe;
4. tocar `Update Your Kindle`;
5. confirmar;
6. esperar el reinicio sin tocar Power;
7. en `Library`, abrir `Run Hotfix` una sola vez;
8. esperar texto similar a una terminal y el reinicio de la interfaz.

### El cartel KPPMainAppV2 no significa que se perdió el jailbreak

En el PW3 probado, después de `Run Hotfix` apareció:

```text
Generating core dump file for process KPPMainAppV2...
```

Se cerró con `Close`. Luego aparecieron dos documentos KPP en `Library`. Eran volcados de diagnóstico del reinicio de la interfaz, no libros ni una señal de fallo permanente. Se eliminan al final, después de confirmar KUAL.

### `;log` no es una prueba fiable en este equipo

En esta unidad, buscar `;log` dejó la pantalla esperando unos segundos y volvió a `Home` sin mostrar resultados. Repetirlo no cambió nada. No resetear por eso. La prueba definitiva será que KUAL se instale y abra.

## Fase 6 — Instalar KUAL por la ruta directa comprobada

USB: conectar ahora.

Red: Modo avión.

Ejecutar:

```bash
./winterbreak2-pw3/scripts/05-copiar-kual-mrpi.sh
```

Si quedan menos de 300 MB, el script ofrece retirar únicamente algunos archivos dummy de `fill_disk`. Confirmar escribiendo `SI`.

El script instala los archivos de MRPI para uso futuro, pero coloca este paquete directamente en la raíz:

```text
Update_KUALBooklet_hotfix_c6ac782_install.bin
```

Salida correcta:

```text
KUAL_DIRECTO_Y_MRPI_COPIADOS_OK
EXPULSION_OK
```

Desconectar el USB. En el Kindle:

1. abrir `Settings → Advanced Options`;
2. tocar `Update Your Kindle`;
3. confirmar;
4. esperar el reinicio;
5. abrir `Library`;
6. abrir el nuevo elemento `KUAL`.

KUAL debe mostrar un menú. En la instalación probada primero mostró `Sort menu 123`, `Quit` y `/`. Eso fue suficiente para confirmar que el jailbreak, el hotfix y KUAL estaban ejecutando código externo.

No usar `;log mrpi` como vía principal en este PW3. Se probó y no lanzó el instalador.

## Fase 7 — Copiar y activar el bloqueo OTA

Este bloqueo renombra internamente `/usr/bin/otaupd` y `/usr/bin/otav3`. Impide actualizaciones normales hasta ejecutar `Restore`.

USB: conectar ahora.

Red: Modo avión.

Ejecutar:

```bash
./winterbreak2-pw3/scripts/06-copiar-bloqueo-ota.sh
```

Esperar:

```text
BLOQUEO_OTA_COPIADO_OK
EXPULSION_OK
```

Desconectar físicamente el cable. Después:

1. abrir `KUAL`;
2. abrir `Rename OTA Binaries`;
3. elegir **`Rename`**;
4. no elegir `Restore`;
5. esperar el reinicio automático.

El reinicio es la señal esperada de que el script se ejecutó. Más adelante, KindleForge permite instalar `UpdateBlock Status` para comprobarlo visualmente.

## Fase 8 — Quitar el relleno

Hacerlo solamente después del reinicio de `Rename`.

USB: conectar ahora.

Red: Modo avión.

Ejecutar:

```bash
./winterbreak2-pw3/scripts/07-quitar-relleno.sh
```

Confirmar escribiendo:

```text
OTA-BLOQUEADA
```

El script elimina exclusivamente `/Volumes/Kindle/fill_disk`, sincroniza y expulsa. En la ejecución probada quedaron aproximadamente 3,1 GB libres antes de restaurar los libros.

Después de `EXPULSION_OK`, desconectar el cable.

## Fase 9 — Instalar y probar KOReader

Para PW3 con firmware `5.16.2.1.1`, el paquete correcto es **`kindlepw2`**. No usar `kindlehf`: éste es para firmware 5.16.3 o superior.

USB: conectar ahora.

Red: Modo avión.

Ejecutar:

```bash
./winterbreak2-pw3/scripts/08-copiar-koreader.sh
```

Esperar:

```text
KOREADER_2026_03_COPIADO_OK
EXPULSION_OK
```

Desconectar el cable. Abrir:

```text
Library → KUAL → KOReader → Start KOReader
```

Si aparece la interfaz de KOReader, la aplicación está instalada. KUAL actúa como lanzador: KOReader no suele aparecer como una aplicación separada en `Library`. Mientras KOReader siga abierto, suspender y reanudar el Kindle conserva la sesión; después de salir o reiniciar se vuelve a abrir desde KUAL.

Nunca conectar el Kindle al Mac en modo de almacenamiento mientras KOReader está ejecutándose. Salir de KOReader primero.

## Fase 10 — Limpiar instaladores y restaurar libros

Ejecutar esta fase sólo después de abrir correctamente KUAL y KOReader.

USB: conectar ahora, con KOReader cerrado.

Red: Modo avión.

Ejecutar:

```bash
./winterbreak2-pw3/scripts/09-limpiar-y-restaurar-backup.sh
```

Confirmar:

```text
LIMPIAR-Y-RESTAURAR
```

El script elimina únicamente:

- `jb.sh`, `patchedUks.sqsh`, `winterbreak2/` y `winterbreak.log`;
- `Run Hotfix.run_hotfix`;
- documentos y carpetas `KPPMainAppV2_*`;
- los dos archivos cero bytes creados por LanguageBreak en `documents/dictionaries`.

Conserva:

- `documents/KUAL.kual`;
- `koreader/`;
- `extensions/koreader`;
- `extensions/renameotabin`;
- `extensions/MRInstaller`;
- `libkh/` y los componentes internos del hotfix.

Después copia solamente `backup/documents/`, excluyendo metadatos basura de macOS y restos KPP/Hotfix. No restaura `backup/system`, porque devolver una base interna antigua después de un reset puede reintroducir estado obsoleto.

Salida correcta:

```text
LIMPIEZA_Y_RESTAURACION_OK
EXPULSION_OK
```

Tras desconectar, el Kindle puede tardar varios minutos en indexar los libros. Eso es normal.

## Fase 11 — Instalar KindleForge opcionalmente

KindleForge es un gestor gráfico de aplicaciones. La versión fijada es 4.1.0. Su proyecto declara soporte para firmware 5.12.2.2 o superior, hotfix 2.3.1 o superior y ambas ABI; este PW3 usa la variante soft-float.

USB: conectar ahora.

Red: Modo avión durante la copia.

Ejecutar:

```bash
./winterbreak2-pw3/scripts/10-copiar-kindleforge.sh
```

Si el archivo no existe, el script lo descarga desde la publicación oficial, verifica SHA‑256, copia la variante soft-float y expulsa.

Después de `EXPULSION_OK`:

1. desconectar el USB;
2. abrir `KindleForge` desde `Library` una vez;
3. esa primera apertura registra la aplicación;
4. si solicita Internet, desactivar Modo avión y conectar Wi‑Fi;
5. instalar primero `UpdateBlock Status`;
6. no reinstalar `HotfixUpdater`, `KUAL` ni `KOReader` sobre las versiones ya probadas.

Consultar [APLICACIONES_COMPATIBLES.md](APLICACIONES_COMPATIBLES.md) antes de instalar paquetes adicionales.

## Verificación final

El proceso está completo cuando se cumplen todas estas condiciones:

- KUAL abre y muestra sus menús.
- KOReader abre desde `KUAL → KOReader → Start KOReader`.
- `Rename OTA Binaries → Rename` produjo un reinicio.
- `Run Hotfix` y los libros KPP ya no están en `Library`.
- Los libros del backup volvieron a aparecer.
- No existen en la raíz `jb.sh`, `patchedUks.sqsh` ni `winterbreak2/`.
- El Kindle conserva espacio libre razonable; en la ejecución documentada quedaron 2,3 GB después de libros, KOReader y KindleForge.

## Problemas y respuesta exacta

### Vuelve a aparecer la lista de Wi‑Fi

Durante WinterBreak2, usar `Set up later` si se está configurando el equipo. No entrar en Demo Mode. En el intento LanguageBreak esa pantalla indicaba que la secuencia `Resell Device` no había terminado como esperaba el exploit; no repetir ese método.

### `Update Your Kindle` está gris

1. Activar Modo avión.
2. No resetear.
3. Conectar USB.
4. Comprobar que exista exactamente un `.bin` compatible en la raíz.
5. Sincronizar, expulsar y desconectar.
6. Volver a `Settings`.

### `Run Hotfix` genera un KPPMainAppV2

Cerrar el cuadro. No borrar aún el hotfix interno. Continuar con KUAL directo. Si KUAL abre, eliminar únicamente los documentos KPP y `Run Hotfix` durante la fase de limpieza.

### `;log` no devuelve nada

En este PW3 fue el comportamiento observado aun cuando el hotfix sí había terminado. No usar esa búsqueda como prueba definitiva.

### `;log mrpi` no ejecuta el paquete

No repetir indefinidamente. Usar el script 05 actualizado, que deja el paquete KUAL en la raíz, e instalar desde `Update Your Kindle`.

### KUAL muestra `Application Error`

Comprobar que se usó Hotfix 2.3.7 y KUAL de NiLuJe. No instalar Hotfix 2.5.0 ni PEKI en esta combinación. No resetear: conservar Modo avión y revisar los registros.

### KOReader no aparece en KUAL

Conectar USB sólo después de salir de KOReader y comprobar:

```text
/Volumes/Kindle/koreader/reader.lua
/Volumes/Kindle/extensions/koreader/menu.json
```

Para este firmware el archivo debe llamarse `koreader-kindlepw2-...zip`.

### macOS muestra “Disk Not Ejected Properly”

Si el script mostró `EXPULSION_OK`, el volumen fue expulsado mediante `diskutil` y se puede desconectar. Si falta esa línea, volver a conectar, esperar el montaje y expulsar correctamente.

## Actualizar, revertir o resetear en el futuro

Antes de instalar firmware o hacer un reset de fábrica:

1. abrir `KUAL`;
2. abrir `Rename OTA Binaries`;
3. elegir **`Restore`**;
4. esperar el reinicio;
5. confirmar que la actualización que se quiere instalar sea compatible con las aplicaciones;
6. recién entonces actualizar o resetear.

Una actualización puede cerrar el jailbreak o cambiar de soft-float a hard-float. En firmware 5.16.3 o superior, por ejemplo, KOReader requiere `kindlehf`, no el paquete de esta guía.

## Fuentes principales y evidencia comunitaria

- [WinterBreak2: documentación](https://kindlemodding.org/jailbreaking/WinterBreak2/)
- [WinterBreak2 v1.0.0](https://github.com/KindleModding/Winterbreak2/releases/tag/v1.0.0)
- [Tabla de modelos y firmware](https://kindlemodding.org/kindle-models.html)
- [Hotfix v2.3.7](https://github.com/KindleModding/Hotfix/releases/tag/v2.3.7)
- [KUAL/MRPI y snapshots de NiLuJe](https://www.mobileread.com/forums/showthread.php?t=225030)
- [Bloqueo OTA](https://kindlemodding.org/jailbreaking/post-jailbreak/disable-ota.html)
- [KOReader v2026.03](https://github.com/koreader/koreader/releases/tag/v2026.03)
- [Selección de paquete KOReader para Kindle](https://github.com/koreader/koreader/wiki/Installation-on-Kindle-devices)
- [KindleForge 4.1.0](https://github.com/KindleTweaks/KindleForge/releases/tag/v4.1.0)
- [Repositorio oficial de paquetes KindleForge](https://github.com/KindleTweaks/Repository)
- [Reporte PW3: esperar el mensaje final de WinterBreak2](https://www.reddit.com/r/kindlejailbreak/comments/1tk2vjc/having_trouble_while_following_the_winterbreak2/)
- [Reporte PW3 5.16.2.1.1: Hotfix 2.5.0 y KUAL](https://www.reddit.com/r/kindlejailbreak/comments/1ukv8ly/kual_application_error_on_pw3_516211_after_clean/)

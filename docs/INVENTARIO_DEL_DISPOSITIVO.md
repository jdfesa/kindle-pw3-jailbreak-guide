# Inventario del dispositivo de prueba

Estado registrado el **21 de julio de 2026**.

Este archivo describe el Kindle concreto utilizado para validar la guía. No es una lista de componentes obligatorios ni una recomendación de instalar todo el catálogo.

## Dispositivo

| Campo | Valor |
|---|---|
| Modelo | Kindle Paperwhite 3, 7.ª generación, 2015 |
| Prefijo de serie publicado | `G090G1` |
| Firmware | 5.16.2.1.1 |
| ABI | `soft-float` (`sf`) |
| Jailbreak | WinterBreak2, confirmado mediante apertura de KUAL |
| Hotfix | Universal Hotfix 2.3.7 |

## Protección y componentes base

| Componente | Estado | Verificación o función |
|---|---|---|
| KUAL de NiLuJe | Instalado y probado | Abre correctamente desde Library |
| Rename OTA Binaries | Ejecutado | Se eligió `Rename` y el Kindle reinició |
| UpdateBlock Status | Instalado mediante KindleForge | El archivo existe como `documents/updateblock.sh`; en Library aparece como **Check OTAs**. Falta registrar el resultado que muestre al abrirlo |
| KOReader 2026.03 `kindlepw2` | Instalado y probado | Abre mediante `KUAL → KOReader → Start KOReader` |
| KindleForge 4.1.0 | Instalado y probado | Catálogo gráfico operativo en este PW3 `sf` |

`UpdateBlock Status` es el nombre del paquete en KindleForge, pero su lanzador declara `# Name: Check OTAs`. Por eso debe buscarse **Check OTAs** en Library. Es un verificador y no sustituye a `Rename OTA Binaries`. Hasta registrar su resultado, la evidencia disponible de protección OTA es la ejecución confirmada de `Rename` y el reinicio posterior.

## Aplicaciones instaladas desde KindleForge

| Aplicación | Estado registrado | Finalidad | Observaciones |
|---|---|---|---|
| KNotes | Instalada | Notas simples | Compatible `hf`/`sf`; prueba funcional pendiente de documentar |
| KPomo | Instalada | Temporizador Pomodoro | Compatible `hf`/`sf`; prueba funcional pendiente de documentar |
| KWordle | Instalada | Juego tipo Wordle | Compatible `hf`/`sf`; prueba funcional pendiente de documentar |
| KAnki | Instalada | Tarjetas de estudio | Compatible `hf`/`sf`; probar primero con un mazo pequeño |
| kTerm | Instalada | Terminal local GTK+ | Compatible `hf`/`sf`; no es necesario para usar el SFTP integrado de KOReader |
| KindleFetch | Instalada | Descarga de libros desde un catálogo externo | Depende de kTerm; ver advertencias abajo |

## Dónde aparece cada aplicación

La inspección USB del 21 de julio de 2026 confirmó dos superficies distintas:

| Superficie | Entradas | Archivos de lanzamiento |
|---|---|---|
| Library | Check OTAs, KindleForge, KNotes, KPomo, KWordle y KAnki | `/mnt/us/documents/*.sh` |
| KUAL | KOReader, kTerm y KindleFetch | `/mnt/us/extensions/*/menu.json` |

No se deben mover las carpetas `KNotes`, `KPomo`, `KWordle` ni `KAnki`: sus lanzadores contienen rutas absolutas bajo `/mnt/us/documents/`. Una carpeta creada por USB tampoco se convierte automáticamente en una Collection de Library.

Para evitar modificar esas rutas se añadió un submenú propio, **`KUAL → Installed Apps`**, que sólo enlaza los lanzadores existentes. Su fuente reproducible está en [`kindle-tools/installed-apps`](../kindle-tools/installed-apps/README.md). Esto agrupa los accesos en KUAL sin duplicar ni reubicar aplicaciones.

KindleForge no expone en su registro una versión independiente para todas estas aplicaciones. Por eso el inventario conserva el nombre del catálogo y la fecha de instalación, sin inventar números de versión.

## Estado de las pruebas

La palabra **instalada** indica que el propietario confirmó la instalación desde KindleForge. No significa todavía que se hayan comprobado en cada aplicación:

1. apertura y salida normal;
2. suspensión y reanudación;
3. comportamiento después de reiniciar;
4. consumo de batería;
5. ausencia de nuevos documentos o volcados `KPPMainAppV2`.

Después de probar una aplicación conviene actualizar este inventario con el resultado. Si una aplicación produce errores, desinstalar primero la última incorporada y verificar que KUAL y KOReader continúen abriendo.

## Transferencia de libros por red

No hace falta instalar otro servidor sólo por tener kTerm. KOReader ya incluye SSH/SFTP:

```text
KOReader → menú superior → engranaje → Network → SSH server
```

El puerto predeterminado documentado por KOReader es `2222`. Debe utilizarse autenticación por clave y mantenerse desactivada la opción `Login without password (DANGEROUS)` salvo durante una prueba breve y controlada en una red local.

Fuente: [documentación SSH oficial de KOReader](https://github.com/koreader/koreader/wiki/SSH).

## Advertencia sobre KindleFetch

KindleFetch quedó instalado por decisión del propietario, pero no forma parte de la configuración recomendada de la guía:

- depende de `kTerm`;
- el catálogo de KindleForge indica que descarga desde Anna's Archive;
- su instalador descarga y ejecuta otro script remoto;
- las fuentes ofrecidas pueden tener restricciones legales según la obra y la jurisdicción.

Utilizar únicamente contenido cuya descarga sea legal y autorizada. Para archivos propios son preferibles USB, SFTP de KOReader, Calibre, OPDS o almacenamiento WebDAV/FTP controlado por el usuario.

Fuentes: [registro oficial de KindleForge](https://github.com/KindleTweaks/Repository/blob/main/registry.json) e [instalador de KindleFetch](https://github.com/KindleTweaks/Repository/blob/main/KindleFetch/install.sh).

## No reinstalar desde KindleForge

- **KOReader:** ya está instalado y probado. La entrada del catálogo no detecta necesariamente instalaciones manuales y puede sobrescribir los mismos directorios.
- **KUAL:** ya está instalado y es la prueba principal de que el jailbreak persiste.
- **HotfixUpdater:** no reemplazar el Hotfix 2.3.7 estable de esta ejecución sin una razón y un procedimiento de recuperación.

## Mantenimiento del inventario

Al instalar, actualizar o retirar una aplicación, registrar:

```text
fecha — nombre — acción — resultado — forma de apertura — errores observados
```

No anotar claves SSH, contraseñas, direcciones IP privadas, nombres de redes Wi‑Fi ni el número de serie completo.

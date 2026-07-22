# Inventario del dispositivo de prueba

Estado registrado el **22 de julio de 2026**.

## Personalización local

| Componente | Estado | Ubicación | Alcance |
|---|---|---|---|
| Fondo `library-mountain-pw3.png` | Instalado y confirmado visualmente durante el autoinicio | `/mnt/us/koreader/screensavers/` | Pantalla de reposo e inicio de KOReader |
| User patch de screensaver | Instalado; falta probar una suspensión aislada | `/mnt/us/koreader/patches/` | Habilita el fondo en equipos con Special Offers |
| Night Mode temprano | Instalado y confirmado visualmente | `/mnt/us/koreader/patches/` | Home oscura desde el inicio de KOReader |
| Home de biblioteca | Instalada y confirmada visualmente | `/mnt/us/koreader/patches/` | Abre en `/mnt/us/documents/Library` |

La interfaz nativa de Amazon no fue parcheada. El aviso de registro requiere
registro o un parche KPP de mayor riesgo. KPP queda aplazado hasta terminar la
prueba de USBNetwork automático durante un arranque completo.

El script `11-personalizar-koreader.sh` terminó con
`KOREADER_PERSONALIZADO_OK`, comprobó la imagen, el user patch y las claves de
configuración, y expulsó el volumen correctamente. La ilustración y la Home
oscura ya se confirmaron; sólo falta aislar la prueba de suspensión.

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
| KOReader 2026.03 `kindlepw2` | Instalado y probado | Autoinicio local habilitado; KUAL permanece como entrada manual |
| KindleForge 4.1.0 | Instalado y probado | Catálogo gráfico operativo en este PW3 `sf` |
| SSH de KOReader por Wi-Fi | Instalado y probado | Puerto `2222`, clave dedicada, PID independiente |
| USBNetwork 0.22.N-r19297 | Instalado y probado manualmente | Puerto `22`; Airplane Mode y reversión USBMS comprobados; `auto` pendiente de prueba |

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

El archivo quedó copiado en `/mnt/us/extensions/installed_apps/menu.json` y fue validado antes de expulsar el volumen. El SHA-256 de la fuente y de la copia fue:

```text
657617a5460b735dedeb602eccf4ec74275bef3a388f6eb6282d5851a6bbe111
```

El Kindle se expulsó correctamente desde macOS. Queda pendiente abrir KUAL sin USB y confirmar visualmente que `Installed Apps` aparece y que sus accesos funcionan. Esa prueba está descrita en el [backlog experimental](../experiments/BACKLOG.md).

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

Se creó una clave dedicada ECDSA P-256 para KOReader:

```text
~/.ssh/id_ecdsa_kindle_pw3
SHA256:NkyP/krpXihdUjU30hQr0xUa8busmxcb/vT5AzwbkTA
```

La clave pública está instalada en
`/mnt/us/koreader/settings/SSH/authorized_keys`. Se comprobó autenticación sólo
por clave, usuario `root`, transferencia con SHA-256 y persistencia tras reiniciar
KOReader. La privada quedó respaldada de forma cifrada en
`Dropbox/99_Archive/kindle-pw3-jailbreak-guide/ssh/`; no está en Git.

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

# Aplicaciones compatibles y recomendadas

Dispositivo de referencia: PW3, firmware 5.16.2.1.1, ABI `soft-float`, KUAL de NiLuJe y Hotfix 2.3.7.

## Lo que ya está instalado

### KOReader 2026.03

Es la ampliación principal para lectura. Incluye soporte para PDF, DjVu, EPUB, FB2, MOBI, DOC, RTF, HTML, CBZ/CBT y TXT; reflujo de PDF con K2pdfopt, márgenes y tipografía configurables, diccionarios StarDict, OPDS, integración con Calibre, Wallabag, Wikipedia, traducción, exportación de notas, FTP y SSH opcionales.

Mucho de lo que suele describirse como “más aplicaciones” ya viene como plugin dentro de KOReader. Conviene explorar primero `Top menu → Tools → Plugin management` antes de instalar software externo.

Fuente: [proyecto oficial KOReader](https://github.com/koreader/koreader).

### KindleForge 4.1.0

Es un catálogo gráfico para instalar y desinstalar aplicaciones. Está copiado como opción, pero su proyecto está en modo mantenimiento. Funciona con la pila clásica de jailbreak utilizada aquí; no se debe actualizar el hotfix de este PW3 desde KindleForge.

Fuentes: [KindleForge](https://github.com/KindleTweaks/KindleForge) y [repositorio de paquetes](https://github.com/KindleTweaks/Repository).

## Instalar primero

### UpdateBlock Status

Comprueba si `otaupd` y `otav3` están renombrados. Es la primera utilidad recomendada antes de dejar Wi‑Fi encendido.

### KNotes

Aplicación sencilla para notas. El registro oficial declara soporte `hf` y `sf`, por lo que incluye este PW3.

### KPomo

Temporizador Pomodoro pensado para pantalla e‑ink. Compatible con `sf`.

## Aplicaciones razonables para probar

| Aplicación | Uso | Compatibilidad declarada | Comentario |
|---|---|---|---|
| `KWordle` | Juego Wordle | `hf`, `sf` | Ligera y reversible |
| `KAnki` | Tarjetas Anki | `hf`, `sf` | Útil para estudio; probar con un mazo pequeño |
| `RAnki` | Backend Anki completo | `hf`, `sf` | Más pesado que KAnki |
| `Kreate` | Dibujo sencillo | `hf`, `sf` | La pantalla no tiene lápiz; usar con expectativas modestas |
| `KShips` | Batalla naval | `hf`, `sf` | Juego sencillo |
| `Gargoyle` | Aventuras de texto | `hf`, `sf` | Apropiado para e‑ink |
| `GNOME Games Suite` | Juegos clásicos | `hf`, `sf` | Puede consumir más espacio |
| `Gambatte-K2` | Emulador Game Boy | `hf`, `sf` | La latencia de e‑ink limita juegos rápidos |
| `kTerm` | Terminal local | `hf`, `sf` | Sólo para diagnóstico o desarrollo |

La compatibilidad declarada proviene del [`registry.json` oficial de KindleForge](https://github.com/KindleTweaks/Repository/blob/main/registry.json). Que una aplicación declare `sf` no garantiza que cada función sea cómoda en un PW3; instalar de una en una y probar suspensión, salida y reinicio.

## No instalar en este PW3

### HotfixUpdater

No usarlo. Este dispositivo quedó estable con Hotfix 2.3.7; una actualización automática a otra versión puede volver a producir `Application Error` en KUAL.

### KUAL y KOReader desde KindleForge

Ya están instalados y verificados. Reinstalarlos no agrega funciones y complica el diagnóstico.

### KinAMP y LARKPlayer

El registro oficial los marca únicamente `hf`. Este PW3/5.16.2.1.1 es `sf`, por lo que no son compatibles. Además, este modelo no ofrece una experiencia de audio equivalente a Kindles modernos.

### Alpine Linux

Declara `sf`, pero es un entorno completo, pesado y con más posibilidades de dejar procesos activos. No aporta mejoras a la lectura y no es una instalación inicial recomendable.

### KindleFetch

Depende de kTerm y descarga libros desde un catálogo externo con situación legal variable. No se recomienda como parte de una configuración reproducible; usar archivos propios, Calibre, OPDS o fuentes autorizadas.

### KPM, JarLauncher, Textadept y Wordgrinder

Son herramientas para usuarios técnicos y añaden dependencias. Instalarlas sólo cuando exista un caso concreto y después de un backup actualizado.

## Método de prueba seguro

1. Confirmar `UpdateBlock Status`.
2. Instalar una sola aplicación.
3. Abrirla, suspender el Kindle, reanudar y salir normalmente.
4. Reiniciar el Kindle una vez.
5. Comprobar KUAL y KOReader.
6. Sólo entonces instalar la siguiente.

Si aparece un nuevo documento `KPPMainAppV2`, desinstalar la última aplicación antes de borrar el volcado. No resetear de fábrica como primera respuesta.

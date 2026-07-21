# Kindle Paperwhite 3: WinterBreak2 verificado en macOS

Procedimiento reproducible para liberar un **Kindle Paperwhite 3 (7.ª generación, 2015)** con firmware **5.16.2.1.1** desde macOS, conservar los libros e instalar KUAL, bloqueo OTA, KOReader y KindleForge.

Esta documentación proviene de una ejecución real sobre un PW3 con prefijo de serie `G090G1`. La ruta que funcionó fue:

```text
WinterBreak2 → Hotfix 2.3.7 → KUAL directo por Update Your Kindle
→ Rename OTA Binaries → KOReader kindlepw2 → restauración del backup
```

El intento previo con LanguageBreak no funcionó de forma confiable en este dispositivo y no forma parte del procedimiento. La guía explica el fallo para evitar que otra persona repita horas de ciclos de Demo Mode.

## Empezar aquí

1. Leer completa la [guía detallada](docs/GUIA_COMPLETA.md) antes de conectar el Kindle.
2. Descargar los paquetes indicados en [paquetes/README.md](winterbreak2-pw3/paquetes/README.md).
3. Ejecutar `./winterbreak2-pw3/scripts/00-verificar-paquetes.sh`.
4. Seguir la guía sin saltar comprobaciones ni cambiar el estado del cable.

Toda la documentación está indexada en [docs/README.md](docs/README.md). Las aplicaciones adicionales compatibles están explicadas en [docs/APLICACIONES_COMPATIBLES.md](docs/APLICACIONES_COMPATIBLES.md).

## Qué no contiene este repositorio

- Los libros y documentos del usuario están en `backup/`, ignorados por Git.
- Los paquetes de jailbreak y aplicaciones son propiedad de sus respectivos proyectos y están ignorados por Git.
- No se incluyen números de serie completos, credenciales Wi‑Fi ni registros personales del dispositivo.

## Alcance estricto

Los scripts rechazan un firmware distinto cuando macOS permite leer `system/version.txt`. No se deben reutilizar sin investigación en otro modelo o firmware. Un paquete incorrecto puede provocar pérdida de datos o dejar el Kindle sin arrancar.

# Hoja de ruta experimental

Cada fase debe completarse y documentarse antes de avanzar. El jailbreak funcional no debe usarse como entorno de prueba destructivo.

## Fase 0 — Línea base

- Registrar espacio libre, batería y firmware.
- Confirmar que KUAL y KOReader abren.
- Confirmar el resultado de `Check OTAs`.
- Conservar una copia de cualquier archivo propio que se vaya a modificar.

**Criterio de salida:** el lector funciona igual que antes del experimento.

## Fase 1 — Prototipo WAF mínimo

- Elegir nombre y APP_ID únicos.
- Mostrar una pantalla estática con botón `Quit`.
- Añadir temas claro y oscuro sólo dentro de la aplicación.
- Instalar en una carpeta aislada.
- Probar apertura, salida, suspensión y reinicio.

**Criterio de salida:** diez aperturas sin core dump ni bloqueo de la interfaz.

## Fase 2 — Panel de sólo lectura

- Mostrar batería y espacio disponible.
- Mostrar el estado de la protección OTA sin cambiarlo.
- Añadir accesos a KOReader y aplicaciones instaladas.
- Actualizar datos únicamente por acción del usuario.

**Criterio de salida:** ninguna escritura fuera de la carpeta de la aplicación y ningún refresco continuo.

## Fase 3 — Personalización

- Tamaño de texto y densidad de controles.
- Orden configurable de accesos.
- Tema claro/oscuro persistente.
- Documentar personalización segura de KOReader: Night Mode, fuentes, márgenes, gestos, perfiles y screensaver.

**Criterio de salida:** configuración recuperable borrando un único archivo propio.

## Fase 4 — Prueba opcional de Rust

- Preparar toolchain cruzado soft-float.
- Compilar `hello-world` para `armv7-unknown-linux-gnueabi` y, por separado, evaluar MUSL estático.
- Registrar `file`, tamaño, dependencias y resultado real en el Kindle.
- No conectar todavía el binario con la interfaz principal.

**Criterio de salida:** ejecución repetible tras reiniciar y desinstalación por borrado de una carpeta.

## Fase 5 — Empaquetado y recuperación

- Crear instalador local versionado con hashes.
- Crear desinstalador.
- Añadir prueba de modelo/firmware/ABI.
- Documentar recuperación si el lanzador falla.

**Criterio de salida:** una persona puede instalar y retirar la app siguiendo instrucciones sin modificar la guía de jailbreak.

## Funciones deliberadamente pospuestas

- modo oscuro global del sistema Amazon;
- reemplazo de Home o del lector nativo;
- daemon siempre activo;
- actualización automática desde Internet;
- escritura sobre la partición del firmware;
- interfaz nativa completa en Rust.

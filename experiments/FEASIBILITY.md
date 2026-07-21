# Viabilidad de una aplicación propia en el PW3

Equipo objetivo de esta investigación:

```text
Kindle Paperwhite 3 (7.ª generación, 2015)
Firmware 5.16.2.1.1
ABI ARM soft-float
Jailbreak WinterBreak2 + Hotfix 2.3.7
KUAL y KOReader operativos
```

## Resumen

Sí es posible crear una aplicación propia. La opción con menor riesgo para la primera versión es una **WAF/Mesquite local escrita con HTML, CSS y JavaScript ES5**, siguiendo la misma estructura que ya funciona en KNotes, KPomo, KAnki y KWordle sobre este dispositivo concreto.

También se puede crear una extensión de KUAL para comandos sencillos o un plugin Lua de KOReader para funciones integradas con la lectura. Rust es viable como experimento de backend o utilidad de línea de comandos, pero no es la mejor base para la primera interfaz gráfica.

## Matriz de viabilidad

| Idea | Estado | Enfoque recomendado | Límites |
|---|---|---|---|
| Modo oscuro dentro de nuestra app | Viable | CSS de alto contraste | Sólo afecta nuestra interfaz |
| Modo nocturno de lectura | Ya disponible | KOReader → Night Mode | No cambia Home ni el lector de Amazon |
| Panel con batería, espacio y estado OTA | Viable con pruebas | WAF + helper de shell de sólo lectura | Validar cada propiedad LIPC en este firmware |
| Lanzador de apps instaladas | Viable | Menú KUAL | Ya se implementó `Installed Apps` |
| Preferencias, botones grandes y temas | Viable | HTML/CSS/ES5 | Diseñar para e-ink y evitar animaciones |
| Utilidades pequeñas del sistema | Viable | Extensión KUAL en shell | Mantenerlas reversibles y sin daemon |
| Integración dentro de KOReader | Viable | Plugin Lua | Sólo existe dentro de KOReader |
| Backend compilado en Rust | Experimental | `armv7-unknown-linux-gnueabi` | ABI, glibc y kernel antiguos requieren prueba real |
| GUI nativa completa en Rust | Posible, no recomendada para v1 | Framebuffer/input + FBInk | Mucha complejidad y mayor superficie de fallo |
| Modo oscuro global de Amazon Home/Reader | No validado; fuera de v1 | Parches de framework o inversión global | Riesgo de ghosting, fallos de refresco y roturas tras reinicios |
| Luz cálida | No viable por software | Requiere LEDs de temperatura variable | El PW3 no tiene ese hardware |
| Reemplazar Home o el lector de Amazon | Fuera de alcance | — | Modifica componentes sensibles del sistema |

## Qué significa “modo oscuro”

Hay tres cosas diferentes:

1. **Nuestra aplicación:** fondo negro y texto blanco mediante CSS. Es viable y reversible.
2. **Lectura en KOReader:** `Night Mode` ya invierte los colores y puede automatizarse. Es la solución recomendada para libros y PDF.
3. **Todo el sistema Amazon:** Home, Library, diálogos y lector nativo. No se considera seguro ni estable para la primera versión.

En una pantalla e-ink el tema oscuro no garantiza menor consumo. Los cambios grandes de negro pueden exigir refrescos completos y producir más ghosting; por eso la interfaz debe limitar animaciones, transiciones y repintados continuos.

## Rust: posible, pero no como primera interfaz

Los binarios instalados y funcionales en este equipo son ARM EABI5 soft-float. El objetivo Rust coherente es `armv7-unknown-linux-gnueabi`, no `gnueabihf`. Sin embargo, la documentación actual del objetivo supone como referencia Linux 3.2 y glibc 2.17, mientras que componentes del Kindle declaran compatibilidad con kernels 2.6.31/3.0.35. Compilar no prueba por sí solo que el binario vaya a ejecutar.

Antes de adoptar Rust se necesita un experimento mínimo que:

1. compile fuera del Kindle;
2. se copie a una carpeta aislada en `/mnt/us/extensions/`;
3. ejecute `hello-world` y una consulta de sólo lectura;
4. registre salida y código de retorno;
5. pueda eliminarse sin tocar `/var/local` ni la partición raíz.

Un objetivo MUSL estático podría reducir la dependencia de glibc, pero sigue necesitando verificar syscalls disponibles en el kernel del dispositivo.

## Fuentes técnicas

- [Mesquito: desarrollo](https://kindlemodding.org/mesquito/development/): limitaciones del motor web y compatibilidad aproximada con Safari 5.
- [Mesquito: tutorial y manifiesto](https://kindlemodding.org/mesquito/development/tutorial.html).
- [WAF y Mesquite](https://kindlemodding.org/wafs-and-mesquite/).
- [KOReader User Guide](https://koreader.rocks/user_guide/): Night Mode y configuración del lector.
- [Rust `armv7-unknown-linux-gnueabi`](https://doc.rust-lang.org/rustc/platform-support/armv7-unknown-linux-gnueabi.html).
- [Rust ARM Linux targets](https://doc.rust-lang.org/rustc/platform-support/arm-linux.html).
- [KindleModding en GitHub](https://github.com/orgs/KindleModding/repositories): SDK, toolchains y FBInk.

Las observaciones sobre rutas, ABI y aplicaciones instaladas se verificaron localmente en el PW3 descrito; no deben generalizarse automáticamente a otro modelo o firmware.

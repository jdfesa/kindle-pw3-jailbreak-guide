# Arquitectura propuesta para `PW3 Dashboard`

## Decisión inicial

Construir la primera versión como aplicación WAF local:

```text
Lanzador .sh en Library o KUAL
        ↓
registro de un APP_ID propio
        ↓
/usr/bin/mesquite carga file:///mnt/us/documents/PW3Dashboard/
        ↓
HTML + CSS + JavaScript ES5
```

Esta arquitectura no instala Mesquito ni reemplaza componentes del sistema. Utiliza el runtime `/usr/bin/mesquite` que ya emplean con éxito las aplicaciones instaladas en este mismo Kindle.

## Componentes previstos

```text
PW3Dashboard.sh                 lanzador y registro de APP_ID
PW3Dashboard/config.xml         manifiesto WAF
PW3Dashboard/index.html         estructura de la interfaz
PW3Dashboard/css/app.css        temas claro/oscuro para la app
PW3Dashboard/js/app.js          lógica ES5, sin toolchain obligatorio
PW3Dashboard/assets/            iconos monocromos y fuentes opcionales
```

Si una función necesita información del sistema, debe agregarse un helper pequeño y auditado. La interfaz no debe ejecutar comandos arbitrarios ni aceptar entradas sin validar.

## Compatibilidad web

El motor disponible es antiguo. La implementación debe asumir aproximadamente Safari 5:

- JavaScript ES5;
- `var` en lugar de `let`/`const` si no existe transpilación comprobada;
- sin arrow functions ni parámetros por defecto;
- sin frameworks modernos pesados;
- sin animaciones continuas, sombras complejas ni gradientes;
- controles táctiles grandes y contraste alto;
- refresco deliberado, no un reloj que repinte cada segundo.

## Tema oscuro local

El tema puede implementarse con dos clases CSS en el nodo raíz. La preferencia debe persistirse únicamente dentro de la carpeta de la aplicación o mediante almacenamiento web probado. La primera versión no intentará invertir el framebuffer ni modificar estilos de Amazon.

## Cuándo usar otra tecnología

- **KUAL + shell:** para un toggle, diagnóstico o lanzador de una sola acción.
- **Plugin Lua de KOReader:** para funciones que sólo tienen sentido durante la lectura.
- **Rust/C:** para un helper que realmente necesite rendimiento o acceso nativo, después de validar ABI y kernel.
- **FBInk:** para dibujar directamente sobre e-ink en una utilidad nativa, aceptando la complejidad adicional.

## Límites de seguridad

- No escribir en `/` ni modificar archivos del firmware.
- No dejar servicios permanentes activos.
- No tocar los binarios OTA renombrados.
- No guardar contraseñas, claves Wi‑Fi ni claves SSH en el repositorio.
- No usar instaladores que ejecuten scripts remotos sin fijar versión y hash.
- Toda instalación debe tener una desinstalación explícita y reversible.

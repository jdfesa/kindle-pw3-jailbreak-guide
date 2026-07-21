# Seguridad, privacidad y publicación

## Datos excluidos de Git

El archivo [`.gitignore`](../.gitignore) excluye:

- `backup/` y `backups/`, porque contienen libros, anotaciones y bases personales;
- todos los paquetes binarios de terceros;
- logs del Kindle;
- metadatos de macOS;
- archivos `.env`, claves, certificados y carpetas privadas;
- restos locales del intento LanguageBreak.

Antes de publicar, ejecutar:

```bash
git status --short --ignored
git ls-files
```

Revisar que no aparezcan:

- números de serie completos;
- nombres o contraseñas de redes Wi‑Fi;
- nombres de cuenta Amazon;
- libros o diccionarios con licencia;
- `My Clippings.txt`;
- capturas donde se vean rutas personales o redes cercanas;
- `winterbreak.log` o volcados KPP.

## Binarios de terceros

El repositorio publica enlaces, versiones y SHA‑256, no redistribuye archivos. Esto reduce tamaño, evita confundir autoría y obliga a descargar desde el proyecto original.

Los hashes verifican que el archivo descargado coincide con el utilizado en la prueba, pero no constituyen una auditoría de seguridad de esos proyectos.

## Riesgo de actualizaciones

`Rename OTA Binaries` renombra herramientas internas de actualización. Mientras está activo:

- no instalar firmware manualmente;
- no hacer reset de fábrica como método de diagnóstico;
- antes de actualizar, ejecutar `KUAL → Rename OTA Binaries → Restore`.

El bloqueo evita actualizaciones automáticas normales, pero no es una garantía absoluta frente a toda modificación posible de Amazon o una actualización forzada por otro medio.

## Wi‑Fi

Mantener Modo avión durante todas las fases salvo:

- cargar la página de WinterBreak2;
- usar KindleForge después de activar el bloqueo OTA;
- funciones de red de KOReader elegidas conscientemente.

No publicar los nombres de red usados durante la prueba.

## Acceso avanzado

kTerm, SSH, FTP y Alpine Linux amplían mucho la superficie del dispositivo. No habilitarlos permanentemente sin contraseña, necesidad concreta y una forma de desactivarlos.


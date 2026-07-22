# Uso local y personalización sin Amazon

Dispositivo de referencia: Kindle Paperwhite 3, firmware `5.16.2.1.1`.

## ¿Es obligatorio registrar el Kindle?

No para leer archivos locales con KOReader. Los libros pueden copiarse por USB,
Calibre o el servidor SSH de KOReader y abrirse desde su explorador de archivos.

La interfaz nativa `Home`/`Library` sí fue diseñada alrededor de una cuenta de
Amazon. En un dispositivo no registrado puede mostrar la solicitud de registro
y el aviso `Cloud Not Available` aunque existan libros locales. El jailbreak no
elimina automáticamente esas decisiones de interfaz.

## Flujo recomendado

1. Mantener modo avión y el bloqueo OTA.
2. Dejar que el autoinicio abra KOReader; conservar
   `KUAL → KOReader → Start KOReader` como entrada manual.
3. Organizar libros desde `/mnt/us/documents` o una carpeta propia mediante
   Calibre, USB o SSH.
4. Dejar KOReader abierto al suspender el dispositivo para conservar su fondo
   personalizado.

El registro en Amazon sólo resulta necesario si se desea una experiencia
normal de la interfaz nativa, sincronización o servicios de Amazon. Registrar el
equipo no es requisito para KOReader y tampoco elimina el jailbreak, pero exige
conectividad y debe hacerse únicamente después de comprobar el bloqueo OTA.

## Fondo de reposo instalado

La imagen `assets/screensavers/library-mountain-pw3.png` tiene `1072 × 1448`,
escala de grises y 16 niveles optimizados para la pantalla de 300 ppp del PW3.
El script `11-personalizar-koreader.sh` la copia a:

```text
/mnt/us/koreader/screensavers/library-mountain-pw3.png
```

También instala un user patch de KOReader que habilita su pantalla de reposo
cuando el firmware informa `Special Offers`. Es reversible y sólo modifica el
almacenamiento visible por USB.

## Interfaz oscura y biblioteca limpia

La configuración reutilizable instalada en este PW3 aplica dos fases:

1. `1-local-first-defaults.lua` escribe `night_mode=true` antes de que KOReader
   inicialice la pantalla. Esto evita comenzar en claro y cambiar de tema unos
   segundos después.
2. `2-library-home.lua` fija `/mnt/us/documents/Library` como HOME bloqueada y
   activa el mosaico de portadas con progreso.

El 22 de julio de 2026 se verificaron el log sin errores, las preferencias
persistidas y la interfaz real: KOReader abrió automáticamente con Home en modo
oscuro. El mismo enfoque sirve para otro Kindle compatible con KOReader, pero la
ruta de biblioteca y el comportamiento de refresco deben probarse en su modelo.

La inversión es de KOReader, no una modificación global del firmware de Amazon.
Así queda contenida, reversible y no afecta KUAL ni las pantallas de recuperación.

## Por qué no se modificó KPP

`KPP_Patch` puede ocultar el aviso de registro, los carruseles comerciales y el
botón de la tienda. Sin embargo, reemplaza o enlaza el bytecode de la aplicación
principal del Kindle. El proyecto advierte que un parche incompatible puede
dejar la interfaz en blanco y exige SSH de recuperación disponible durante el
arranque.

Antes de considerarlo en este PW3 se debe:

1. instalar y verificar USBNetwork/SSH;
2. confirmar acceso durante el arranque;
3. extraer y respaldar el bytecode original;
4. probar el parche sólo mediante un `bind mount` temporal;
5. reiniciar para revertir ante cualquier fallo.

Fuentes:

- [Kindle Modding FAQ](https://kindlemodding.org/jailbreaking/jailbreak-faq.html)
- [KOReader para Kindle](https://kindlemodding.org/jailbreaking/post-jailbreak/koreader.html)
- [KPP Patch](https://github.com/KindleModding/KPP_Patch)
- [KOReader](https://github.com/koreader/koreader)

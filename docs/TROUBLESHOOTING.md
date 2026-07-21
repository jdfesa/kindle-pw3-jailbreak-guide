# Troubleshooting

Las respuestas corresponden al PW3 `G090G1` con firmware 5.16.2.1.1. Regla general: **Modo avión, no resetear, no mantener Power y no repetir una fase sin diagnóstico**.

## Finder no muestra el Kindle

1. Salir completamente de KOReader.
2. Usar un cable micro‑USB con datos, no sólo carga.
3. Desconectar y volver a conectar una vez.
4. Esperar hasta 30 segundos.
5. Revisar `diskutil list`.
6. Si está reiniciándose o actualizando, esperar sin forzar el montaje.

## macOS muestra “Disk Not Ejected Properly”

- Si el script ya mostró `EXPULSION_OK`, la expulsión fue solicitada correctamente y se puede desconectar.
- Si falta esa línea, volver a montar el Kindle y ejecutar `diskutil eject /Volumes/Kindle`.

## El espacio libre no queda entre 50 y 90 MB

Volver a ejecutar `02-rellenar-espacio.sh`, elegir valor personalizado `70` y después ejecutar `03-verificar-y-expulsar.sh`. No encender Wi‑Fi hasta que el verificador acepte el valor.

## WinterBreak2 descarga algo pero no muestra el final

No cuenta como éxito. Esperar hasta 90 segundos sin salir de la página. La salida aceptada es:

```text
*** Finished installing jailbreak! ***
*** Please Install HOTFIX now ***
```

Si no aparece, activar Modo avión, volver a Home, conectar USB y conservar `winterbreak.log`. No instalar el hotfix todavía.

## `04-copiar-hotfix.sh` rechaza el log

El script se detiene si falta la frase final o aparece `ERR -`. No editar el log para eludir la comprobación.

## `Update Your Kindle` está deshabilitado

1. Mantener Modo avión.
2. Conectar USB.
3. Confirmar que el `.bin` está en la raíz, no en `documents` ni `mrpackages`.
4. Confirmar que no hay dos paquetes `.bin` compitiendo.
5. Sincronizar y expulsar correctamente.
6. Desconectar y volver a abrir Settings.

## Aparece `Generating core dump file for process KPPMainAppV2`

En la prueba ocurrió al reiniciar la interfaz después de `Run Hotfix`.

1. Pulsar `Close`.
2. No resetear.
3. Continuar con KUAL directo.
4. Si KUAL abre, los libros KPP son volcados descartables.
5. Eliminarlos con `09-limpiar-y-restaurar-backup.sh`.

## `;log` espera y vuelve a Home

Fue exactamente el comportamiento observado aun cuando el hotfix sí había terminado. No demuestra un fallo. Continuar con KUAL directo y usar la apertura de KUAL como prueba.

## `;log mrpi` no ejecuta nada

También ocurrió en la prueba. El paquete siguió en `mrpackages` y el log quedó vacío. No repetir ni resetear.

Usar `05-copiar-kual-mrpi.sh`: la versión corregida pone `Update_KUALBooklet_hotfix_c6ac782_install.bin` en la raíz. Después usar `Update Your Kindle`.

## KUAL da `Application Error`

Comprobar estas versiones:

```text
Hotfix 2.3.7
KUAL-c6ac782-20250419 de NiLuJe
Firmware 5.16.2.1.1
```

No actualizar el hotfix mediante KindleForge. Los reportes consultados relacionan Hotfix 2.5.0 y PEKI con errores en algunos PW3.

## KUAL abre con sólo tres opciones

Es correcto si muestra algo similar a:

```text
Sort menu 123
Quit
/
```

Eso confirma que el launcher ejecuta. Las opciones adicionales aparecen al copiar extensiones válidas en `/extensions`.

## KOReader no aparece en KUAL

Comprobar por USB, con KOReader cerrado:

```text
/Volumes/Kindle/koreader/reader.lua
/Volumes/Kindle/extensions/koreader/menu.json
```

Si falta alguno, repetir `08-copiar-koreader.sh`. No usar `kindlehf` en 5.16.2.1.1.

## KOReader no abre bien AZW3 o KFX

KOReader se orienta a EPUB, PDF, DjVu, FB2, CBZ y otros formatos. El soporte de formatos propietarios Amazon es limitado. Abrirlos con el lector Amazon o convertir una copia autorizada a EPUB mediante Calibre.

## Conectar USB mientras KOReader está abierto

No hacerlo en modo almacenamiento. Salir de KOReader primero. El proyecto advierte que USBMS con KOReader ejecutándose no está soportado.

## Los libros restaurados tardan en aparecer

El Kindle está indexando. Mantenerlo cargando, desconectado del Mac, durante varios minutos. No volver a copiar los mismos libros mientras indexa.

## Vuelven a aparecer archivos KPP

La última aplicación ejecutada probablemente cerró de forma anormal. Antes de borrar el volcado:

1. anotar su fecha;
2. identificar la última aplicación instalada;
3. desinstalar esa aplicación;
4. reiniciar;
5. confirmar KUAL y KOReader.

## Quiero actualizar o resetear

1. Abrir KUAL.
2. `Rename OTA Binaries → Restore`.
3. Esperar el reinicio.
4. Hacer un backup nuevo.
5. Investigar si el nuevo firmware conserva jailbreak y qué ABI usa.

No resetear con los binarios OTA todavía renombrados.


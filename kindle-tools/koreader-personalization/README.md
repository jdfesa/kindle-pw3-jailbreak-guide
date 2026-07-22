# Personalización segura de KOReader

Esta personalización está limitada a la partición USB visible del Kindle. No
reemplaza archivos de `/app`, no remonta la raíz en lectura-escritura y no
modifica KPP.

## Resultado

- habilita la pantalla de reposo propia de KOReader aunque el Kindle conserve
  la marca `Special Offers`;
- selecciona `library-mountain-pw3.png` como imagen de reposo;
- mantiene oculto el mensaje superpuesto de suspensión;
- inicia KOReader siempre en Night Mode, antes de inicializar la pantalla;
- desactiva el plugin SSH interno para que no compita con el servicio de
  recuperación independiente;
- conserva una copia de la configuración anterior de KOReader.

La imagen aparece cuando KOReader está abierto y se suspende el dispositivo.
Al salir de KOReader, la interfaz nativa de Amazon vuelve a controlar la
pantalla de reposo.

`1-local-first-defaults.lua` se ejecuta antes de que KOReader cree su variable
global de preferencias. Por eso abre y vuelca explícitamente el mismo archivo,
fija `night_mode=true`, fuerza las opciones SSH a autenticación por clave y
desactiva el plugin `SSH`. El servidor automático sigue perteneciendo a
`/etc/upstart/koreader-ssh.conf`.

`2-library-home.lua` convierte `/mnt/us/documents/Library` en la carpeta HOME de
KOReader, impide subir accidentalmente a las carpetas técnicas y selecciona una
cuadrícula de portadas con progreso. Se ejecuta al iniciar KOReader y no mueve
ningún libro por sí solo. Para recuperar el navegador sin restricciones basta
retirar el parche y reiniciar KOReader.

## Revertir

1. Salir de KOReader y conectar el Kindle por USB.
2. Eliminar `koreader/patches/2-enable-screensaver-on-special-offers.lua`.
3. Eliminar `koreader/patches/1-local-first-defaults.lua` si también se desea
   restaurar el tema diurno y el plugin SSH interno.
4. Restaurar `koreader/settings.reader.lua.pre-custom-screensaver.bak` como
   `koreader/settings.reader.lua`.

No aplicar el proyecto `KPP_Patch` sin SSH de recuperación operativo durante
el arranque. Su propio README advierte que un parche incompatible puede dejar
la interfaz principal en blanco.

## Autoinicio opcional

`koreader-autostart.conf` es un trabajo de Upstart para el PW3 con firmware
5.16.2.1.1. Espera a que el framework y KPP terminen de iniciar, muestra durante
dos segundos la ilustración del proyecto y abre KOReader. Sólo actúa si existe:

```text
/mnt/us/ENABLE_KOREADER_AUTOSTART
```

Por lo tanto, si KOReader ocasionara algún problema, conectar el Kindle por USB
y borrar ese archivo desactiva el autoinicio para el siguiente arranque. El
trabajo instalado en `/etc/upstart/koreader.conf` queda inerte sin el marcador.
El trabajo espera hasta cinco minutos si `/mnt/us` está exportado a una
computadora durante el arranque; al desconectar el cable puede continuar sin
otro reinicio.

La idea se contrastó con una configuración comunitaria probada en la misma
combinación de dispositivo y firmware:

- <https://gist.github.com/SuleMareVientu/822b2b51d1ea043ce2b190669c0df38b>

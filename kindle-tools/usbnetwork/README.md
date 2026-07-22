# USBNetwork como recuperación física

## Paquete seleccionado

- proyecto: USBNetwork de NiLuJe;
- versión: `0.22.N-r19297`;
- archivo externo: `kindle-usbnet-0.22.N-r19297.tar.xz`;
- tamaño comprobado: `46.154.104` bytes;
- SHA-256: `cf971557d42cc0a6d7699f1c743108c681fa41e3d67ee5802a91932d130d4032`;
- MD5/ETag oficial: `f5490b89a372d8469c1f696a2fb0cb9c`;
- instalador elegido: `Update_usbnet_0.22.N_install_pw2_and_up.bin`;
- SHA-256 del instalador: `3997468395e48b1ff3d3a4f728818f207553814efdf02a272da95f2a6456acbf`.

El archivo externo no se versiona. La [publicación oficial de
NiLuJe](https://www.mobileread.com/forums/showpost.php?p=2658944&postcount=1)
clasifica este paquete para Kindle 5 e incluye PW3. KindleTool en el propio
dispositivo confirmó el sobre firmado, `PackageVersion=0.22.N-r19297` y el
destino `Kindle PaperWhite 3 (2015) WiFi`.

## Decisiones locales

`configure-usbnetwork.sh` deja:

- Kindle en `192.168.15.244` y host en `192.168.15.201/24`;
- USB Ethernet manual durante la primera prueba;
- SSH de USBNetwork bloqueado sobre Wi-Fi;
- Dropbear, sin activar OpenSSH;
- la misma clave pública dedicada que usa el SSH de KOReader;
- `auto` ausente durante la primera prueba y habilitado sólo después de demostrar
  conexión física, Airplane Mode y reversión a USB Mass Storage.

El servidor Wi-Fi local y USBNetwork son contingencias distintas. El primero
facilita mantenimiento normal; el segundo debe funcionar aunque KPP o la
interfaz gráfica no arranquen.

## Secuencia de aceptación

1. Instalar el `.bin` mediante MRPI y confirmar que fue consumido.
2. Ejecutar `/mnt/us/system/tools/configure-usbnetwork.sh` por SSH Wi-Fi.
3. Con el cable desconectado, activar `USBNetwork` desde KUAL.
4. Conectar el cable y localizar la nueva interfaz Ethernet en macOS.
5. Asignar al Mac `192.168.15.201` con máscara `255.255.255.0`.
6. Entrar por clave a `root@192.168.15.244` y registrar la huella de host.
7. Apagar Wi-Fi en el Kindle y repetir la conexión por cable.
8. En PW3, desconectar físicamente el cable, alternar a USB Mass Storage y
   volver a conectarlo para comprobar que el almacenamiento sigue accesible.
9. Sólo entonces crear `/mnt/us/usbnet/auto` y repetir un reinicio controlado.

En el dispositivo de referencia, `auto` se creó desde el USB Mass Storage ya
validado, al mismo tiempo que se restauró `ENABLE_KOREADER_AUTOSTART`. El volumen
se sincronizó y expulsó antes del reinicio; la validación posterior debe hacerse
con Airplane Mode para demostrar que el acceso no depende de Wi-Fi.

El primer intento posterior a un reinicio físico forzado enumeró RNDIS, pero
Dropbear no escuchaba en el puerto 22. No se considera una prueba aprobada. Para
la siguiente validación se usa `Restart` desde el menú con el cable desconectado,
se espera el arranque completo y recién entonces se conecta USB. El botón
mantenido queda reservado para un equipo que no responde.

No aplicar `KPP_Patch` hasta completar los nueve puntos. El marcador `auto`
hace que USBNetwork esté disponible antes del framework, que es lo necesario
para recuperar un KPP incompatible.

### Regla de cambio de modo en PW3

El helper KUAL de esta versión bloquea `Toggle USBNetwork` si detecta el PW3
conectado. Para cambiar tanto de USB Mass Storage a USBNetwork como para volver,
primero se desconecta físicamente el cable, se toca el toggle, se comprueba el
estado y recién entonces se reconecta. El mensaje esperado ante una operación
incorrecta es `must not be plugged in to safely do that`.

En la prueba real, la primera vuelta mostró el estado intermedio
`usbnet, sshd down?`: el gadget RNDIS seguía visible pero SSH no escuchaba. La
recuperación comprobada fue desconectar, dejar el estado en `disabled`, reiniciar
con el cable todavía fuera, esperar la Home nativa y recién entonces reconectar.
USB Mass Storage volvió a montarse sin modificar la biblioteca.

### Interacción con el autoinicio de KOReader

No lanzar MRPI directamente desde una sesión SSH cuando
`ENABLE_KOREADER_AUTOSTART` esté activo. MRPI detiene y reinicia la interfaz; el
trabajo de KOReader puede reaccionar en medio de esa transición y dejar la
ilustración visible indefinidamente.

Procedimiento comprobable:

1. mover el marcador a `ENABLE_KOREADER_AUTOSTART.disabled-for-mrpi`;
2. detener KOReader y comprobar que el SSH independiente sigue activo;
3. ejecutar `KUAL → Helper → Install MR Packages`;
4. auditar instalación, log y raíz en sólo lectura;
5. restaurar el marcador y arrancar KOReader únicamente al final.

## Reversión

- Quitar `usbnet/auto` vuelve a dejar USB Mass Storage como modo de arranque.
- El menú KUAL alterna manualmente entre USBNetwork y USB Mass Storage.
- `Update_usbnet_0.22.N_uninstall.bin` es el desinstalador oficial; no usarlo
  como primer intento de recuperación.
- La configuración anterior queda en
  `/mnt/us/system/usbnetwork-install-2026-07-22/config-before-local-first/`.

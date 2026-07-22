# Bitácora de la ejecución real

Esta página distingue lo comprobado de lo inferido. Para ejecutar el procedimiento usar [GUIA_COMPLETA.md](GUIA_COMPLETA.md).

## 22 de julio de 2026 — biblioteca inglesa y Night Mode

- La migración inicial movió 72 elementos hacia una biblioteca estructurada.
  Conservó 113 libros, pero no escribió `SUCCESS` porque su primer validador
  incluía todos los archivos de `documents`.
- Se compararon por separado los manifiestos: los 113 hashes de libros eran
  idénticos, no faltaba ningún hash y sólo habían aparecido dos reportes de
  fallo `KPPMainAppV2` de la interfaz nativa.
- Los dos reportes se conservaron en
  `library-migrations/2026-07-21-v1/incidental-kpp-crash/` y se cerró la
  auditoría v1 con evidencia explícita.
- A pedido del propietario se adoptaron nombres estructurales en inglés. La
  simulación enumeró 13 renombrados y la ejecución real terminó con
  `LIBRARY_ENGLISH_NAMES_OK`.
- El resultado contiene 111 libros bajo `/mnt/us/documents/Library` y dos
  diccionarios deliberadamente separados. El total sigue siendo 113 y el
  conjunto SHA-256 anterior y posterior es idéntico.
- `2-library-home.lua` se actualizó para abrir `Library`; el mantenimiento usa
  `90_Inbox` como único punto de ingreso.
- Se instaló `1-local-first-defaults.lua`: Night Mode se fija antes de
  inicializar la pantalla y el plugin SSH de KOReader queda desactivado.
- `koreader-ssh.conf` se actualizó para usar el PID independiente
  `/var/run/koreader-ssh-boot.pid`. Se guardó la versión anterior, se comprobó
  identidad SHA-256 del archivo instalado y `/dev/root` volvió a sólo lectura.
- Se ordenó un reinicio final. En este PW3 el intervalo normal observado entre
  `reboot` y KOReader utilizable es de uno a dos minutos; antes de ese plazo un
  timeout de red no se considera fallo. El propietario confirmó que el equipo
  seguía avanzando y KOReader terminó de abrir automáticamente.
- El SSH reapareció sin intervención: `koreader-ssh` quedó `start/running`, su
  PID coincidió con `/var/run/koreader-ssh-boot.pid` y no existió
  `/tmp/dropbear_koreader.pid`. Esto confirma la independencia del plugin.
- La primera versión de `1-local-first-defaults.lua` intentó usar
  `G_reader_settings` antes de que KOReader la creara; el log registró el fallo
  y Night Mode no se aplicó en ese arranque. Se corrigió usando directamente
  `luasettings` y `DataStorage`, con `flush()` antes de inicializar la pantalla.
- Se reinició únicamente KOReader. El SSH mantuvo el mismo PID, ambos parches se
  aplicaron sin advertencias y el archivo persistido confirmó
  `night_mode=true`, HOME/última ruta en `Library`, plugin SSH desactivado y
  autenticación sólo por clave.
- El propietario confirmó visualmente que la pantalla Home de KOReader abrió en
  modo oscuro y que el resultado era el buscado. Night Mode queda, por lo tanto,
  probado tanto en configuración como en la interfaz real del PW3.
- Se descargó el snapshot oficial `kindle-usbnet-0.22.N-r19297`. Una primera
  transferencia truncada y su reanudación fallaron `xz -t`, por lo que se
  rechazaron. La descarga limpia midió exactamente 46.154.104 bytes, pasó
  `xz -t` y produjo SHA-256
  `cf971557d42cc0a6d7699f1c743108c681fa41e3d67ee5802a91932d130d4032`.
- KindleTool en el PW3 confirmó que
  `Update_usbnet_0.22.N_install_pw2_and_up.bin` era un sobre firmado destinado,
  entre otros, a `Kindle PaperWhite 3 (2015) WiFi`. El `.bin` coincidió en ambos
  extremos con SHA-256
  `3997468395e48b1ff3d3a4f728818f207553814efdf02a272da95f2a6456acbf`.
- El primer intento de lanzar MRPI directamente desde la misma sesión SSH no
  fue válido para esta configuración: al reiniciar la interfaz, el autoinicio
  de KOReader mostró la ilustración y quedó detenido allí. Después de superar
  ampliamente el margen normal se realizó un reinicio forzado controlado.
- El reinicio recuperó KOReader, el SSH independiente y la raíz en sólo lectura.
  La auditoría confirmó que USBNetwork no se había instalado parcialmente:
  `/mnt/us/usbnet` y sus trabajos Upstart no existían, y el `.bin` seguía intacto
  con el mismo hash.
- Se decidió que MRPI debe ejecutarse desde KUAL con el autoinicio apartado
  temporalmente. El marcador se movió, sin borrarlo, a
  `ENABLE_KOREADER_AUTOSTART.disabled-for-mrpi`; KOReader se detuvo y el SSH
  independiente permaneció activo.
- Al detener KOReader desde Upstart quedó visible su último framebuffer aunque
  el proceso ya no existía. La orden nativa de Home no refrescó la pantalla y se
  realizó un reinicio controlado; con el marcador apartado el equipo volvió a
  la interfaz nativa.
- El propietario ejecutó `KUAL → Helper → Install MR Packages`. MRPI mostró
  `Running install.sh`, terminó en `Success` y reinició el dispositivo.
- La auditoría posterior confirmó USBNetwork `0.22.N @ r19297`, `.bin`
  consumido, `usbnet.conf` y `usbnet-preinit.conf` instalados, log terminado en
  `Done!`, opciones manuales/USB-only y `/dev/root` en sólo lectura.
- `configure-usbnetwork.sh` copió una clave pública, dejó
  `KINDLE_IP=192.168.15.244`, bloqueó el SSH de USBNetwork sobre Wi-Fi y mantuvo
  ausente el marcador `auto` para la primera prueba.
- macOS detectó `RNDIS/Ethernet Gadget` como `en4`; se asignó únicamente a esa
  interfaz `192.168.15.201/24`. La ruta a `192.168.15.244` quedó por `en4`, tres
  pings no tuvieron pérdidas y SSH por clave en el puerto 22 devolvió
  `uid=0(root)`.
- Huella ED25519 del servidor USBNetwork:
  `SHA256:L1PEfxfu1pOG8ZC+o/YrSzK3/1v1ZpAAlxIuLD2s0TA`. Se guardó usando
  `HostKeyAlias=kindle-pw3-usbnet`, separada de la huella de KOReader.
- Con Airplane Mode activo, el PW3 conservó únicamente la ruta `usb0`; se
  repitieron ping, autenticación por clave y transferencia. El archivo remoto
  coincidió con SHA-256
  `4d36a039b8bc4963460a585c7e2f5cecec5acb6c0bde92421c5050ac5a71f84d`.
- El primer intento de volver a USB Mass Storage se hizo con el cable conectado
  y no cambió el modo. La inspección del helper confirmó que en PW3 KUAL lo
  bloquea con `must not be plugged in to safely do that`; el procedimiento se
  corrigió para desconectar, alternar y volver a conectar.
- Después del cambio apareció un estado intermedio
  `USBNetwork: enabled (usbnet, sshd down?)`: RNDIS seguía enumerado pero el
  puerto 22 estaba cerrado. Se dejó el modo en `disabled` con el cable fuera y
  se reinició normalmente, todavía sin `auto`.
- Tras esperar la Home nativa y reconectar, macOS montó el dispositivo como
  USB Mass Storage en `/Volumes/Kindle`; la interfaz RNDIS ya no existía. La
  biblioteca, la configuración de USBNetwork y el marcador apartado de KOReader
  seguían presentes. Esto valida la reversión física antes de activar `auto`.
- Desde ese USB Mass Storage validado se creó `usbnet/auto`, se restauró
  `ENABLE_KOREADER_AUTOSTART` y se expulsó el volumen mediante macOS antes de
  retirar el cable.
- El primer arranque posterior se hizo manteniendo el botón físico. Terminó en
  la Home nativa sin mostrar la ilustración local ni abrir KOReader. USB Ethernet
  apareció como `en4`, pero el puerto 22 rechazó la conexión; por lo tanto, ese
  intento no valida ni el autoinicio de KOReader ni `usbnet/auto`.
- Como el equipo respondía, se desconectó el cable y se usó el `Restart` normal
  del menú. Después del margen esperado, el propietario confirmó la ilustración
  local y el ingreso automático a KOReader. El autoinicio queda validado para un
  reinicio normal; la recuperación después de un reinicio físico forzado y el
  SSH automático de USBNetwork continúan pendientes.
- Se registró en video un reinicio normal completo: logo y barra de progreso,
  ilustración local y apertura automática de la Home de KOReader en Night Mode.
  La [grabación pública de 45 segundos](https://github.com/user-attachments/assets/e8df19a6-e2ad-48f9-b62b-c21c69aceccb)
  se normalizó a H.264 con píxeles cuadrados y se publicó sin audio ambiente.
- Criterio operativo: usar `Restart` siempre que la interfaz responda y reservar
  el botón mantenido para un bloqueo real. No encadenar reinicios forzados para
  probar servicios.

## 21 de julio de 2026 — uso local y fondo de KOReader

- El Kindle no registrado mostraba la solicitud de registro en `Home` y el
  aviso `Cloud Not Available` al entrar en `Library`.
- Se confirmó que el almacenamiento local seguía intacto y que KOReader 2026.03
  identificaba el equipo como `KindlePaperWhite3`.
- Se descartó aplicar `KPP_Patch`: su documentación exige SSH de recuperación
  durante el arranque porque un bytecode incompatible puede dejar KPP en blanco.
- Se generó una ilustración monocroma original y se optimizó a `1072 × 1448`,
  escala de grises de 16 niveles.
- `11-personalizar-koreader.sh` copió la imagen, instaló un user patch reversible
  y configuró KOReader para mostrarla al suspenderse.
- Se conservó
  `settings.reader.lua.pre-custom-screensaver.bak` para restauración.
- El script validó las copias y terminó con `KOREADER_PERSONALIZADO_OK` y
  `EXPULSION_OK`. La comprobación visual en el dispositivo queda pendiente.
- Se creó la clave ECDSA P-256 dedicada `id_ecdsa_kindle_pw3`, con huella
  `SHA256:NkyP/krpXihdUjU30hQr0xUa8busmxcb/vT5AzwbkTA`.
- La privada se respaldó cifrada con AES-256-CBC/PBKDF2 bajo
  `Dropbox/99_Archive/kindle-pw3-jailbreak-guide/ssh/`. La contraseña de
  recuperación se conservó separada del archivo cifrado y del equipo de
  administración; la copia se verificó mediante descifrado temporal y
  comparación con la clave activa.
- Se localizó el SSH de KOReader en la red local, se ingresó temporalmente como
  `root` y se instaló la clave pública en
  `/mnt/us/koreader/settings/SSH/authorized_keys`.
- La autenticación forzada por clave, sin contraseña, devolvió
  `KINDLE_SSH_KEY_AUTH_OK` y `uid=0(root)`. Se repitió después de activar
  `Login with key only`; el acceso por contraseña fue rechazado y una prueba
  SFTP conservó su SHA-256.
- Se instaló el alias local `ssh kindle-pw3`.
- Se instaló `/etc/upstart/koreader.conf`, basado en una configuración probada
  en PW3/5.16.2.1.1. El marcador visible
  `/mnt/us/ENABLE_KOREADER_AUTOSTART` habilita el arranque automático, muestra
  brevemente la ilustración y abre KOReader. La raíz se devolvió a solo lectura.
- Se ordenó un reinicio de prueba. El Kindle no volvió automáticamente al Wi-Fi;
  la pantalla indicó que estaba conectado por USB y no se inició KOReader. La
  causa fue que `/mnt/us`, donde viven el marcador, KOReader y la imagen, estaba
  exportado a la computadora durante el arranque.
- Se corrigió `koreader.conf` para esperar hasta cinco minutos a que `/mnt/us`
  vuelva al dispositivo en lugar de terminar silenciosamente.
- Se instaló `/etc/upstart/koreader-ssh.conf`: inicia el Dropbear de KOReader en
  el puerto `2222`, en modo `key only`, durante el arranque y sin depender de
  que la interfaz de KOReader haya abierto. También espera hasta cinco minutos
  si `/mnt/us` está exportado por USB.
- La versión anterior de `koreader.conf` quedó en
  `/mnt/us/koreader/system-backups/2026-07-21-before-boot-services/`; ambos
  trabajos instalados coinciden con sus fuentes y la raíz volvió a solo lectura.
- Se repitió el reinicio con el cable físicamente desconectado. La ilustración
  apareció correctamente; `koreader` y `koreader-ssh` quedaron en estado
  `start/running`, el puerto `2222` apareció automáticamente y el alias entró por
  clave. El arranque completo tardó algo más de un minuto.
- Se inventarió la biblioteca sin mover archivos: 113 libros, 80 carpetas de
  primer nivel y 135 directorios `.sdr`. La diferencia indica metadatos o
  restos de libros anteriores que deben auditarse antes de reorganizar.

## Estado inicial y backup

- Se detectó un PW3/7.ª generación con prefijo `G090G1` y firmware 5.16.2.1.1.
- Se creó un backup del almacenamiento accesible.
- Incluyó MOBI, AZW/AZW3, PDF, diccionarios, `My Clippings` y metadatos `.sdr`.
- Dos entradas originales dañadas no pudieron leerse; se conservaron los demás archivos accesibles.

## Intento LanguageBreak descartado

- Se entró en Demo Mode y se repitieron fases de `Sideload Content`, `Resell Device` y la ventana USB corta.
- El dispositivo volvió varias veces al selector de idioma, `Register Demo` o la lista de redes.
- La segunda copia llegó a verificarse en macOS, pero la secuencia final no produjo un jailbreak estable.
- Hubo `Application Error`, una pantalla blanca y ciclos de configuración.

Conclusión: era una ruta innecesariamente frágil para este equipo. Sus archivos se retiraron del Kindle y del repositorio público.

## WinterBreak2 exitoso

- Se copió WinterBreak2 v1.0.0.
- `Filler.sh` dejó 70 MB libres.
- Se abrió `https://winterbreak2.now.sh/` desde el navegador.
- Durante el diagnóstico el jailbreak se ejecutó más de una vez; `winterbreak.log` registró cuatro finales exitosos y ningún `ERR -`.
- La pantalla mostró `Finished installing jailbreak` y `Please Install HOTFIX now`.

## Hotfix

- Se instaló Hotfix 2.3.7 por `Update Your Kindle`.
- Se abrió `Run Hotfix` una vez.
- Apareció salida tipo terminal y la interfaz reinició.
- El reinicio generó un core dump de `KPPMainAppV2`; se cerró el cuadro.
- Buscar `;log` regresó silenciosamente a Home.

Conclusión: `;log` no fue una prueba útil en este firmware.

## KUAL: intento MRPI y solución directa

- Se copiaron MRPI y KUAL de NiLuJe.
- `;log mrpi` no lanzó MRPI; el paquete quedó sin consumir.
- Se movió `Update_KUALBooklet_hotfix_c6ac782_install.bin` a la raíz.
- Se instaló desde `Advanced Options → Update Your Kindle`.
- Después del reinicio apareció `KUAL` en Library y abrió su menú.

Esa apertura fue la confirmación definitiva del jailbreak.

## Protección OTA y aplicaciones

- Se instaló `Rename OTA Binaries` y se eligió `Rename`; el Kindle reinició.
- Se eliminó `fill_disk` y se recuperaron unos 3,1 GB.
- Se copió KOReader 2026.03 `kindlepw2`.
- KOReader abrió correctamente desde KUAL.

## Limpieza y restauración

- Se eliminaron `jb.sh`, `patchedUks.sqsh`, `winterbreak2/`, `winterbreak.log`, `Run Hotfix` y dos grupos KPP.
- Se retiraron los marcadores cero bytes que LanguageBreak dejó en `documents/dictionaries`.
- Se restauraron 351 archivos útiles; junto con KUAL quedaron 352 archivos en `documents`.
- La comparación por checksum no mostró diferencias de contenido. Las diferencias reportadas fueron timestamps FAT.
- Después de libros, KOReader y KindleForge quedaron unos 2,3 GB libres.

## Aplicación adicional

- Se descargó KindleForge 4.1.0 desde su publicación oficial.
- SHA‑256 comprobado: `43033781974e63d0ce0f46b87b40e9424fdcb5c29b7f23a2b460c1f32e77c7ed`.
- Se verificó `UtildSF`, requerido por este firmware soft-float.
- Se copió a `documents` para su registro y prueba posterior.

## Instalaciones posteriores mediante KindleForge

El 21 de julio de 2026, el propietario confirmó la instalación de las siguientes entradas del catálogo:

- `UpdateBlock Status`;
- `KNotes`;
- `KPomo`;
- `KWordle`;
- `KAnki`;
- `kTerm`;
- `KindleFetch`, junto con su dependencia `kTerm`.

La confirmación recibida acredita la instalación, no una prueba funcional completa de cada aplicación. El resultado textual de `UpdateBlock Status` todavía no fue registrado. El detalle actualizado se mantiene en [INVENTARIO_DEL_DISPOSITIVO.md](INVENTARIO_DEL_DISPOSITIVO.md).

## Organización posterior de aplicaciones

La inspección directa por USB confirmó que `UpdateBlock Status` se instala como `documents/updateblock.sh`, cuyo nombre visible es **Check OTAs**. También confirmó que las aplicaciones WAF instaladas usan rutas absolutas dentro de `documents`; moverlas para ordenarlas habría roto sus lanzadores.

Se preparó entonces `KUAL → Installed Apps`: un menú de accesos que no mueve, duplica ni modifica las aplicaciones de terceros. `menu.json` se copió a `/mnt/us/extensions/installed_apps/`; el JSON se validó, se comprobó que existieran sus nueve destinos y la copia produjo el mismo SHA-256 que la fuente. Después se ejecutó `sync` y macOS expulsó correctamente el volumen.

La prueba visual sin USB se pospuso por decisión del propietario. No debe registrarse el menú como probado hasta confirmar que aparece en KUAL y abre los lanzadores esperados. Las tareas pendientes quedaron ordenadas en [`experiments/BACKLOG.md`](../experiments/BACKLOG.md).

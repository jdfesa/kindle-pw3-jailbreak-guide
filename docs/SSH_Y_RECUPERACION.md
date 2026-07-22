# SSH, transferencia y recuperación

Dispositivo de referencia: Kindle Paperwhite 3, firmware `5.16.2.1.1`.

## Dos accesos con finalidades distintas

| Canal | Cuándo funciona | Puerto habitual | Uso |
|---|---|---:|---|
| Dropbear de KOReader por Wi‑Fi | Durante el arranque local y con KOReader | `2222` | Libros, SFTP y configuración local |
| USBNetwork/Dropbear del sistema | Validado manualmente; falta validar `auto` | `22` | Recuperación previa a cambios de KPP |

No se debe confundir una prueba exitosa de KOReader con una vía de recuperación
del sistema. El parche de la interfaz principal sólo se evaluará después de
probar el segundo canal.

El dispositivo tiene además un trabajo local `/etc/upstart/koreader-ssh.conf`
que inicia en el arranque el Dropbear incluido con KOReader, en modo `key only`.
Esto permite administración Wi-Fi antes de abrir KOReader, siempre que `/mnt/us`
esté montado y la red se conecte. No sustituye la prueba posterior de
USBNetwork, porque depende de Wi-Fi y del contenido de `/mnt/us`.

El 22 de julio se separó su PID a
`/var/run/koreader-ssh-boot.pid`. El plugin `SSH` de KOReader usa
`/tmp/dropbear_koreader.pid`; por eso se desactiva mediante
`1-local-first-defaults.lua`. La separación evita que cerrar KOReader mate el
servidor de recuperación y evita dos Dropbear compitiendo por el puerto `2222`.

La prueba posterior al reinicio confirmó que el trabajo automático y KOReader
quedaron `start/running`, que el PID pertenecía sólo al servicio de arranque y
que reiniciar únicamente KOReader no cortaba la sesión SSH.

En este PW3 antiguo el arranque completo tarda normalmente entre uno y dos
minutos. No diagnosticar un fallo de SSH antes de que KOReader haya terminado de
abrir y el equipo se haya asociado otra vez al Wi-Fi.

## Identidad

KOReader ejecuta Dropbear y utiliza `root`. No se crea otro usuario porque el
firmware y las extensiones esperan esa cuenta. El acceso queda restringido por
una clave ECDSA dedicada:

```text
~/.ssh/id_ecdsa_kindle_pw3
SHA256:NkyP/krpXihdUjU30hQr0xUa8busmxcb/vT5AzwbkTA
```

La privada permanece fuera de Git. La pública se instala en:

```text
/mnt/us/koreader/settings/SSH/authorized_keys
```

## Prueba real del 21 de julio de 2026

- KOReader anunció una dirección privada en la red local y aceptó conexiones
  en el puerto `2222`. La IP no se registra porque puede cambiar por DHCP.
- El primer acceso temporal devolvió `uid=0(root)`.
- La clave pública dedicada se agregó a `authorized_keys` sin sobrescribir
  entradas previas; después de la operación el archivo contenía una entrada.
- Una conexión forzada a `publickey`, con contraseña e interacción desactivadas
  en el cliente, devolvió `KINDLE_SSH_KEY_AUTH_OK` y `uid=0(root)`.
- Huella ED25519 observada del servidor SSH de KOReader:
  `SHA256:XWQpmFfktU2VIlMpIuKir1w3gu4dwqNq+dn5eCvjy3k`.
- Después de reiniciar el servidor con `Login without password` desactivado y
  `Login with key only` activado, la clave volvió a entrar como `root`.
- Un intento que deshabilitó `publickey` en el cliente fue rechazado; el servidor
  anunció solamente `publickey` como método disponible.
- Una transferencia SFTP temporal a `/mnt/us/documents` conservó el SHA-256
  `261b99fc9612401e1a900cf08d30f83da6a4b7fad5efef37d72c96e7c0cf659f` y el
  archivo de prueba fue retirado.
- El alias local `kindle-pw3` fija usuario, puerto, identidad y huella del host.
  La IP es DHCP; si cambia, sólo hay que actualizar `HostName` en
  `~/.ssh/config`.

## Política de seguridad

- `Login without password (DANGEROUS)` sólo puede habilitarse durante el primer
  acceso, en una red local confiable, y debe deshabilitarse enseguida.
- No exponer los puertos `2222` ni `22` en el router.
- No usar reenvío de agente ni X11.
- El servicio no enciende el Wi-Fi. Para uso diario se puede dejar el radio
  apagado; Dropbear sólo resulta accesible cuando el usuario conecta la red.
- No activar manualmente el plugin SSH de KOReader: el servicio Upstart es el
  propietario exclusivo del puerto `2222`.
- Registrar IP, fecha, huella de host y prueba ejecutada; no registrar claves
  privadas ni contraseñas.

## Criterios de aceptación

El SSH de KOReader queda validado cuando:

1. anuncia una IP local;
2. acepta la clave ECDSA y rechaza el acceso sin ella;
3. `whoami` devuelve `root`;
4. `/mnt/us` es accesible;
5. una transferencia pequeña por SFTP o por tubería SSH conserva su SHA‑256.

Los cinco criterios quedaron comprobados el 21 de julio de 2026. Uso diario:

```bash
ssh kindle-pw3
sftp kindle-pw3
```

USBNetwork queda validado por separado cuando el acceso funciona durante un
reinicio controlado y permite leer y restaurar el bytecode original de KPP.

## USBNetwork instalado

El 22 de julio de 2026 se instaló USBNetwork `0.22.N-r19297` mediante MRPI. Su
configuración inicial mantiene:

```text
KINDLE_IP=192.168.15.244
USE_WIFI="false"
USE_WIFI_SSHD_ONLY="false"
USE_OPENSSH="false"
```

macOS detectó el gadget Ethernet, recibió manualmente `192.168.15.201/24` y
entró por clave a `root@192.168.15.244:22`. La huella ED25519 observada fue:

```text
SHA256:L1PEfxfu1pOG8ZC+o/YrSzK3/1v1ZpAAlxIuLD2s0TA
```

El alias de huella usa `HostKeyAlias=kindle-pw3-usbnet` para no mezclarla con
el servidor de KOReader. Con Airplane Mode activo se repitieron ruta, ping,
autenticación y transferencia, y el SHA-256 coincidió en ambos extremos.

También se comprobó la reversión a USB Mass Storage: en este PW3, después de un
primer estado intermedio (`usbnet, sshd down?`), fue necesario dejar el modo en
`disabled`, reiniciar con el cable desconectado y conectarlo sólo cuando apareció
la Home nativa. macOS volvió a montar `/Volumes/Kindle` y la interfaz RNDIS dejó
de existir. Antes de declarar el canal apto para KPP sólo falta repetir la prueba
con `usbnet/auto` durante un reinicio.

Fuentes:

- [SSH de KOReader](https://github.com/koreader/koreader/wiki/SSH)
- [Advertencias de KPP Patch](https://github.com/KindleModding/KPP_Patch)

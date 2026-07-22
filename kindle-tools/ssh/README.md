# SSH seguro para el PW3

La cuenta del sistema utilizada por KOReader es `root`. No se crea otro usuario
porque el Kindle es un sistema embebido y los scripts/homebrew esperan las rutas
y permisos de esa cuenta. La seguridad se obtiene mediante una clave dedicada,
no mediante una contraseña compartida.

## Clave del equipo de administración

```text
Privada: ~/.ssh/id_ecdsa_kindle_pw3
Pública: ~/.ssh/id_ecdsa_kindle_pw3.pub
Huella:  SHA256:NkyP/krpXihdUjU30hQr0xUa8busmxcb/vT5AzwbkTA
Tipo:    ECDSA P-256
```

La clave privada queda fuera del repositorio. Nunca copiarla al Kindle ni
publicarla. El repositorio sólo registra su ruta y huella para poder auditar qué
clave fue autorizada.

## SSH de KOReader por Wi‑Fi

1. Abrir KOReader.
2. Ir a `Engranaje → Network → SSH server`.
3. Para el primer acceso únicamente, activar `Login without password
   (DANGEROUS)` y luego `SSH server`.
4. Anotar la IP mostrada por KOReader. El puerto predeterminado es `2222` y el
   usuario es `root`.
5. Instalar la clave pública en
   `/mnt/us/koreader/settings/SSH/authorized_keys`.
6. Desactivar el servidor, desactivar inmediatamente el acceso sin contraseña
   y volver a activarlo.
7. Verificar el acceso por clave antes de considerar la configuración cerrada.

Configuración recomendada para `~/.ssh/config`, una vez conocida la IP:

```sshconfig
Host kindle-pw3
    HostName IP_DEL_KINDLE
    User root
    Port 2222
    IdentityFile ~/.ssh/id_ecdsa_kindle_pw3
    IdentitiesOnly yes
    RequestTTY no
    ForwardAgent no
    ForwardX11 no
```

## Alcance de recuperación

El Dropbear incluido con KOReader sirve para libros, configuración y
mantenimiento normal. En este dispositivo un trabajo Upstart lo mantiene
independiente del proceso de KOReader, pero depende de Wi-Fi y de `/mnt/us`; por
eso **no** alcanza por sí solo para recuperar una interfaz KPP rota.

USBNetwork/Dropbear ya fue probado manualmente con Airplane Mode y acceso a la
raíz. Antes de parchear KPP falta verificar su marcador `auto` durante un
arranque completo.

Fuente principal: [documentación SSH de KOReader](https://github.com/koreader/koreader/wiki/SSH).

## Inicio automático local

`koreader-ssh-autostart.conf` inicia en cada arranque el Dropbear incluido con
KOReader, siempre en el puerto `2222` y con `key only`. Espera hasta cinco
minutos si la partición `/mnt/us` está temporalmente exportada por USB. Usa el
PID exclusivo `/var/run/koreader-ssh-boot.pid`; el plugin SSH interno queda
desactivado mediante el user patch local para evitar dos servidores en el mismo
puerto.

Se instala como `/etc/upstart/koreader-ssh.conf`. Es un acceso por Wi-Fi para
administración local; USBNetwork sigue siendo la vía física separada que debe
completar su prueba de arranque antes de modificar KPP.

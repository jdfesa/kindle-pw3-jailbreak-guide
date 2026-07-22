# Secretos y respaldos externos

## Regla del proyecto

Las claves, credenciales, datos completos del dispositivo y cualquier archivo
que no deba publicarse cumplen dos condiciones:

1. quedan excluidos explícitamente mediante `.gitignore` y nunca se agregan a
   Git;
2. tienen una copia identificable bajo
   `Dropbox/99_Archive/kindle-pw3-jailbreak-guide/`.

El respaldo externo replica únicamente material necesario para recuperación.
No se copia el repositorio completo ni contenido público que ya esté protegido
por Git y GitHub.

## Estructura

```text
Dropbox/99_Archive/kindle-pw3-jailbreak-guide/
└── ssh/
    ├── README.txt
    ├── id_ecdsa_kindle_pw3.KEYCHAIN_DEPENDENT_PROVISIONAL.enc
    ├── id_ecdsa_kindle_pw3.enc
    └── id_ecdsa_kindle_pw3.pub
```

`id_ecdsa_kindle_pw3.enc` es el respaldo definitivo actual. El provisional se
conserva sólo como evidencia y no debe ser la fuente de recuperación porque su
contraseña dependía inicialmente del Llavero de macOS.

La clave privada debe conservar permisos `0600` en el equipo local. A Dropbox
se copia cifrada con AES-256-CBC y PBKDF2. La contraseña de recuperación **no
puede depender del Llavero de macOS**: esta máquina es un Hackintosh inestable y
una falla podría volver inaccesibles tanto el equipo como el Llavero. La
contraseña debe conservarse fuera de esta computadora, por ejemplo escrita en
papel y guardada en un lugar seguro o en un gestor independiente.

El primer respaldo del 21 de julio de 2026 terminó con
`SSH_BACKUP_ENCRYPTED_OK`, pero su contraseña quedó inicialmente en el Llavero.
Después de registrar que el Hackintosh no es una fuente de recuperación fiable,
ese archivo pasó a considerarse **provisional**. Se generó luego el respaldo
definitivo con una contraseña conservada en Bitwarden, fuera del Llavero. El
script comprobó la copia cifrada descifrándola en un directorio temporal y
comparándola con la clave activa.

Como la contraseña definitiva también fue comunicada durante la sesión de
configuración, conviene rotarla cuando resulte práctico. Esto no invalida la
copia actual ni obliga a depender del Llavero.

```bash
./kindle-tools/ssh/backup-private-key-to-dropbox.sh
```

El script solicita y confirma la contraseña sin mostrarla, verifica el archivo
descifrándolo en un directorio temporal y no almacena la contraseña. La
recuperación se ensaya con `restore-private-key-from-dropbox.sh`, que crea una
clave con sufijo `.recovered` y nunca sobrescribe la activa.

## Verificación

La copia pública debe producir esta huella:

```text
SHA256:NkyP/krpXihdUjU30hQr0xUa8busmxcb/vT5AzwbkTA
```

Si se rota la clave, se actualizan juntos:

- `~/.ssh/`;
- `authorized_keys` del Kindle;
- la carpeta de Dropbox;
- la huella documentada;
- cualquier entrada aplicable de `~/.ssh/config`.

Nunca se elimina la clave anterior del Kindle hasta comprobar que la nueva
funciona. Después de verificarla, se retira la anterior y se archiva con fecha o
se destruye conscientemente.

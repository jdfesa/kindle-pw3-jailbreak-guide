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
    ├── id_ecdsa_kindle_pw3.enc
    └── id_ecdsa_kindle_pw3.pub
```

La clave privada debe conservar permisos `0600` en el equipo local. A Dropbox
se copia cifrada con AES-256-CBC y PBKDF2. La contraseña de recuperación **no
puede depender únicamente del Llavero de macOS** ni quedar almacenada junto al
archivo cifrado. Debe conservarse en un medio independiente del equipo de
administración, como un gestor de contraseñas o una copia física protegida.

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

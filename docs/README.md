# Documentación

Índice público del procedimiento verificado.

## Lectura obligatoria

1. [Modelo, firmware y alcance](MODELO_Y_FIRMWARE.md)
2. [Uso local y personalización sin Amazon](PERSONALIZACION_Y_USO_SIN_AMAZON.md)
3. [SSH, transferencia y recuperación](SSH_Y_RECUPERACION.md)
4. [Guía completa paso a paso](GUIA_COMPLETA.md)
5. [Troubleshooting](TROUBLESHOOTING.md)
6. [Seguridad, privacidad y publicación](SEGURIDAD_Y_PRIVACIDAD.md)
7. [Secretos y respaldos externos](SECRETOS_Y_RESPALDOS.md)
8. [USBNetwork como recuperación física](../kindle-tools/usbnetwork/README.md)

## Después del jailbreak

- [Inventario del dispositivo de prueba](INVENTARIO_DEL_DISPOSITIVO.md)
- [Organización de la biblioteca local](ORGANIZACION_BIBLIOTECA.md)
- [Aplicaciones compatibles](APLICACIONES_COMPATIBLES.md)
- [Bitácora de la ejecución real](HISTORIAL_DE_LA_PRUEBA.md)
- [Paquetes, fuentes y hashes](../winterbreak2-pw3/paquetes/README.md)

## Scripts

| Script | Finalidad | Termina expulsando |
|---|---|---|
| `00-verificar-paquetes.sh` | Validar todos los SHA‑256 | No usa el Kindle |
| `00-crear-backup.sh` | Copiar el almacenamiento accesible | No; permite seguir con fase 1 |
| `01-copiar-winterbreak2.sh` | Copiar el exploit | No; sigue conectado |
| `02-rellenar-espacio.sh` | Dejar 70 MB libres | No; sigue conectado |
| `03-verificar-y-expulsar.sh` | Verificar ventana de espacio | Sí |
| `04-copiar-hotfix.sh` | Validar log y copiar Hotfix 2.3.7 | Sí |
| `05-copiar-kual-mrpi.sh` | Copiar MRPI y KUAL directo | Sí |
| `06-copiar-bloqueo-ota.sh` | Copiar Rename OTA Binaries | Sí |
| `07-quitar-relleno.sh` | Eliminar sólo `fill_disk` | Sí |
| `08-copiar-koreader.sh` | Instalar KOReader `kindlepw2` | Sí |
| `09-limpiar-y-restaurar-backup.sh` | Limpiar instaladores y devolver libros | Sí |
| `10-copiar-kindleforge.sh` | Instalar gestor opcional | Sí |
| `11-personalizar-koreader.sh` | Instalar fondo y pantalla de reposo local | Sí |
| `12-instalar-clave-ssh-koreader.sh` | Autorizar la clave ECDSA para KOReader | Sí |

Cuando un script imprime `EXPULSION_OK`, recién entonces se desconecta físicamente el cable.

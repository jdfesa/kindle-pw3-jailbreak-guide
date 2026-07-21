# Documentación

Índice público del procedimiento verificado.

## Lectura obligatoria

1. [Modelo, firmware y alcance](MODELO_Y_FIRMWARE.md)
2. [Guía completa paso a paso](GUIA_COMPLETA.md)
3. [Troubleshooting](TROUBLESHOOTING.md)
4. [Seguridad, privacidad y publicación](SEGURIDAD_Y_PRIVACIDAD.md)

## Después del jailbreak

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

Cuando un script imprime `EXPULSION_OK`, recién entonces se desconecta físicamente el cable.


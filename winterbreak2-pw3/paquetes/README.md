# Paquetes de terceros

Los binarios no se publican en este repositorio. Deben descargarse desde sus proyectos originales y colocarse en esta carpeta con los nombres exactos de la tabla.

Después de descargarlos, ejecutar desde la raíz del repositorio:

```bash
./winterbreak2-pw3/scripts/00-verificar-paquetes.sh
```

No continuar si un hash no coincide.

| Nombre local obligatorio | Fuente | SHA‑256 |
|---|---|---|
| `wb2-v1.0.0.zip` | [WinterBreak2 v1.0.0](https://github.com/KindleModding/Winterbreak2/releases/tag/v1.0.0) | `932ff113c414c9b0109b98d7f4b96da20815364fb4905e4483581b881b2ae2e2` |
| `Filler.sh` | [Kindle-Filler-Disk](https://github.com/iiroak/Kindle-Filler-Disk) | `81fc6bf4f41638584b53041d41139984be13c6391ba0e949c9b93bec5b04ee0c` |
| `Update_hotfix_universal-v2.3.7.bin` | [Hotfix v2.3.7](https://github.com/KindleModding/Hotfix/releases/tag/v2.3.7) | `2f895b2c96a6f8232c2648b500e09463738d6e117323199f5f67d523730c9779` |
| `KUAL-c6ac782-20250419.tar.xz` | [Snapshots de NiLuJe](https://www.mobileread.com/forums/showthread.php?t=225030) | `8dace9db8ff7b7de80662a48e830296990e978efc71c281efde43b370bc7afe3` |
| `kual-mrinstaller-1.7.N-r19303.tar.xz` | [Snapshots de NiLuJe](https://www.mobileread.com/forums/showthread.php?t=225030) | `36b3c28a44ad1a91609cc82d2bb9836ad6d7125ba1f63596307bf93f17a9255e` |
| `renameotabin.zip` | [Guía Disable OTA](https://kindlemodding.org/jailbreaking/post-jailbreak/disable-ota.html) | `d2d333620420096e040e2f195c05bebfc97bdeeb5adf26b04c21a254e48ac439` |
| `koreader-kindlepw2-v2026.03.zip` | [KOReader v2026.03](https://github.com/koreader/koreader/releases/tag/v2026.03) | `46e969bb13765b2630b5e14aa2e7fa2445ec551ccaa47db3efe644d0e34944b0` |

KindleForge es opcional. `10-copiar-kindleforge.sh` descarga automáticamente la publicación oficial 4.1.0 y exige este hash:

```text
43033781974e63d0ce0f46b87b40e9424fdcb5c29b7f23a2b460c1f32e77c7ed
```

Fuente: [KindleForge 4.1.0](https://github.com/KindleTweaks/KindleForge/releases/tag/v4.1.0).

## Motivo para fijar versiones

- WinterBreak2 sólo se probó aquí en `v1.0.0`.
- Hotfix 2.3.7 evitó el `Application Error` observado con 2.5.0 en este PW3.
- El paquete KUAL de NiLuJe se instaló correctamente por `Update Your Kindle`.
- KOReader `kindlepw2` es el destino oficial para dispositivos PW2 o posteriores con firmware hasta 5.16.2.1.1.

Actualizar una dependencia exige volver a verificar el procedimiento; no reemplazar archivos silenciosamente conservando el mismo nombre.


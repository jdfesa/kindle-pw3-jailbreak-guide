# Bitácora de la ejecución real

Esta página distingue lo comprobado de lo inferido. Para ejecutar el procedimiento usar [GUIA_COMPLETA.md](GUIA_COMPLETA.md).

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


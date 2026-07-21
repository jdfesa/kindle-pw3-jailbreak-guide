# Modelo, firmware y alcance

## Equipo utilizado

| Campo | Valor |
|---|---|
| Familia | Kindle Paperwhite |
| Generación comercial | 7.ª generación |
| Nombre comunitario | PW3 |
| Año | 2015 |
| Prefijo de serie | `G090G1` |
| Variante | Wi‑Fi |
| Firmware durante el jailbreak | `5.16.2.1.1` |
| Arquitectura de aplicaciones | ARM `soft-float` |
| Computadora | macOS |
| Montaje USB | `/Volumes/Kindle` |
| Método exitoso | WinterBreak2 v1.0.0 |
| Fecha de la prueba | 21 de julio de 2026 |

`G090G1` es un prefijo público usado para identificar el modelo, no el número de serie completo. El número completo se omite deliberadamente.

## Por qué WinterBreak2 es compatible

La documentación de Kindle Modding indica que WinterBreak2 funciona en firmware anterior a 5.16.4 y no necesita registro de Amazon. El PW3 probado ejecutaba 5.16.2.1.1, dentro de ese intervalo.

Fuentes:

- [WinterBreak2](https://kindlemodding.org/jailbreaking/WinterBreak2/)
- [Tabla de modelos Kindle](https://kindlemodding.org/kindle-models.html)
- [Actualizaciones oficiales de software Kindle](https://digprjsurvey.amazon.com/csad/help/node/GKMQC26VQQMM8XSW?theme=light)

## Consecuencia de la versión 5.16.2.1.1

KOReader clasifica PW2 y dispositivos táctiles posteriores con firmware hasta 5.16.2 como destino `kindlepw2`. A partir de 5.16.3 se utiliza `kindlehf`. Por eso esta guía fija:

```text
koreader-kindlepw2-v2026.03.zip
```

Fuente: [instalación oficial de KOReader en Kindle](https://github.com/koreader/koreader/wiki/Installation-on-Kindle-devices).

## Equipos que no deben seguirla literalmente

- Cualquier Kindle cuyo prefijo no corresponda a PW3.
- PW3 con firmware diferente sin investigar primero ese firmware.
- Firmware 5.16.3 o superior usando el paquete KOReader de esta guía.
- Dispositivos con jailbreak `hdnext`, SpringBreak o AdBreak: su pila de paquetes es distinta.

Los scripts validan 5.16.2.1.1 si macOS expone `system/version.txt`. Esa comprobación no sustituye la verificación manual del modelo.


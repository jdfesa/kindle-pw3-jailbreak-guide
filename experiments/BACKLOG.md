# Backlog operativo y de desarrollo

Última actualización: **22 de julio de 2026**.

Este archivo conserva lo que falta hacer para que la próxima sesión empiece sin repetir diagnósticos. No forma parte de la guía de jailbreak y ninguna tarea pendiente invalida la liberación ya confirmada.

## Convenciones

- `[ ]`: pendiente.
- `[x]`: comprobado con evidencia.
- **P0**: validar antes de instalar o desarrollar algo nuevo.
- **P1**: siguiente trabajo útil y de bajo riesgo.
- **P2**: desarrollo posterior.
- **Bloqueada**: depende de completar otra tarea o tomar una decisión.

Al cerrar una tarea se debe anotar fecha, resultado, forma de prueba y cualquier error. No publicar IP privadas, redes Wi-Fi, claves SSH, contraseñas ni el número de serie completo.

## Estado ya confirmado

- [x] WinterBreak2, Hotfix 2.3.7 y KUAL operativos.
- [x] `Rename OTA Binaries → Rename` ejecutado y Kindle reiniciado.
- [x] KOReader y KindleForge abren correctamente.
- [x] Aplicaciones instaladas localizadas por USB sin mover sus rutas.
- [x] Menú fuente `kindle-tools/installed-apps/menu.json` validado como JSON.
- [x] Nueve destinos del menú existentes en el Kindle.
- [x] Menú copiado a `/mnt/us/extensions/installed_apps/menu.json`.
- [x] Fuente y copia con SHA-256 `657617a5460b735dedeb602eccf4ec74275bef3a388f6eb6282d5851a6bbe111`.
- [x] Escrituras sincronizadas y volumen expulsado correctamente desde macOS.
- [x] Biblioteca organizada y migrada a categorías estructurales en inglés.
- [x] 113 hashes de libros idénticos antes y después; 111 libros en `Library`
  y dos diccionarios separados.
- [x] `Library` fijada como HOME bloqueada de KOReader con mosaico de portadas.
- [x] Night Mode fijado mediante un user patch temprano.
- [x] Servicio SSH separado del plugin de KOReader mediante PID propio.

## P0 — Próxima sesión: validación sin USB

### 0. Confirmar el autoinicio determinista de KOReader

- [x] Reiniciar desde el menú con el cable físicamente desconectado.
- [x] Aceptar como normal el logo de Kindle y la barra del firmware.
- [x] Confirmar que luego aparece la ilustración local.
- [x] Confirmar que KOReader abre automáticamente dentro del
  margen normal de uno a dos minutos.
- [ ] Repetir en otra sesión la contingencia de reinicio físico forzado; no usarla
  como método normal ni declararla aprobada con la prueba anterior.
- [ ] Si queda en Home nativa, no encadenar reinicios: comprobar primero
  `ENABLE_KOREADER_AUTOSTART`, el trabajo Upstart `koreader` y sus logs mediante
  USBNetwork.

**Resultado normal aprobado:** la Home nativa puede verse brevemente, pero no
queda como estado final; la secuencia termina en KOReader sin intervención.
La misma garantía después de mantener el botón físico continúa pendiente.

### 1. Comprobar el nuevo menú de KUAL

- [ ] Desconectar físicamente el cable si todavía estuviera conectado.
- [ ] Abrir `KUAL` desde Library.
- [ ] Confirmar que aparece `Installed Apps`.
- [ ] Confirmar que contiene: KOReader, KindleForge, KNotes, KPomo, KAnki, KWordle, Check OTA Protection, kTerm y KindleFetch.

Si no aparece, salir completamente de KUAL y abrirlo otra vez. No reinstalar KUAL ni reiniciar de fábrica. Si sigue ausente, conectar por USB y comprobar únicamente que exista `/mnt/us/extensions/installed_apps/menu.json`.

**Criterio de aceptación:** el submenú aparece después de una apertura normal de KUAL y no modifica los menús originales de KOReader, kTerm o KindleFetch.

### 2. Confirmar la protección OTA

- [ ] Desde `KUAL → Installed Apps`, ejecutar `Check OTA Protection`.
- [ ] Fotografiar o transcribir literalmente el mensaje.
- [ ] Registrar el resultado en `docs/INVENTARIO_DEL_DISPOSITIVO.md`.

Resultado esperado si la protección sigue activa:

```text
OTA blocking is enabled.
Your Kindle will NOT update.
Your jailbreak is safe.
```

Si muestra que el bloqueo está desactivado, no conectar Wi-Fi ni intentar repararlo improvisando: registrar el mensaje y revisar primero `Rename OTA Binaries`.

**Criterio de aceptación:** mensaje exacto registrado y coherente con los binarios OTA renombrados.

### 3. Prueba mínima de los accesos

- [ ] Abrir KOReader y salir normalmente.
- [ ] Abrir KindleForge y salir sin instalar nada.
- [ ] Abrir KNotes, crear una nota temporal, cerrarla y volver a abrirla.
- [ ] Abrir KPomo y comprobar que la pantalla responde.
- [ ] Abrir KAnki sin importar todavía un mazo grande.
- [ ] Abrir KWordle y volver a KUAL.
- [ ] Abrir kTerm y salir sin ejecutar comandos de sistema.
- [ ] No probar KindleFetch en esta ronda; está instalado pero no recomendado.
- [ ] Revisar Library y confirmar que no aparecieron nuevos volcados `KPPMainAppV2`.

**Criterio de aceptación:** cada aplicación probada abre y cierra una vez, KUAL y KOReader siguen funcionando y no aparecen core dumps nuevos.

## P1 — Orden y uso diario

### Collection opcional en Library

- [ ] Si se desea limpiar visualmente Library, crear manualmente una Collection llamada `Applications`.
- [ ] Añadir KUAL, Check OTAs, KindleForge, KNotes, KPomo, KAnki y KWordle.
- [ ] Confirmar que los libros continúan visibles en su ubicación habitual.

No mover carpetas por USB y no editar automáticamente la base de datos de Collections.

### Transferencia de libros por red

- [x] Instalar la clave ECDSA dedicada en KOReader.
- [x] Activar temporalmente el servidor SSH de KOReader en una red local confiable.
- [x] Configurar autenticación por clave y registrar la huella del host.
- [x] Mantener desactivado `Login without password (DANGEROUS)`.
- [x] Transferir un archivo de prueba por SFTP al puerto `2222` y comparar su SHA-256.
- [x] Confirmar después del reinicio que el servicio usa
  `/var/run/koreader-ssh-boot.pid` y no crea
  `/tmp/dropbear_koreader.pid`.
- [x] Investigar USBNetwork sólo después de cerrar la prueba anterior.
- [x] Instalar USBNetwork `0.22.N-r19297` mediante MRPI y verificar raíz `ro`.
- [x] Probar ruta, ping y autenticación por clave sobre USB Ethernet manual.
- [x] Repetir la conexión y una transferencia con Wi-Fi apagado.
- [x] Volver a USB Mass Storage y comprobar el almacenamiento.
- [ ] Verificar el `usbnet/auto` ya activado durante el próximo arranque antes
  de tocar KPP.

### Pulido de la biblioteca

- [x] Usar nombres estructurales en inglés y conservar nombres propios/títulos
  en su idioma original.
- [x] Reservar `90_Inbox` como entrada de libros nuevos.
- [ ] Verificar visualmente progreso e historial de varios libros leídos.
- [ ] Normalizar autores duplicados y nombres con codificación dañada sin borrar
  `.sdr` ni fusionar carpetas hasta comprobar los metadatos.

### Inventario funcional

- [ ] Registrar para cada aplicación: fecha, apertura, salida, suspensión, reinicio y errores.
- [ ] Anotar versiones cuando la propia aplicación las muestre; no inferirlas del catálogo.
- [ ] Decidir si KindleFetch se conserva o se desinstala después de revisar sus riesgos.

## P2 — Aplicación propia `PW3 Dashboard`

### Definición

- [ ] Elegir nombre definitivo y un `APP_ID` único.
- [ ] Definir tres funciones imprescindibles para la versión 1.
- [ ] Mantener fuera de alcance el modo oscuro global, el reemplazo de Home y cualquier escritura en la partición del sistema.

Propuesta inicial:

1. tema claro/oscuro sólo dentro de la aplicación;
2. panel de batería, espacio libre y estado OTA de sólo lectura;
3. accesos a aplicaciones instaladas y ayuda de transferencia SFTP.

### Prototipo WAF/Mesquite

- [ ] Crear estructura HTML/CSS/JavaScript ES5 según `ARCHITECTURE.md`.
- [ ] Añadir un botón `Quit` visible y controles grandes para e-ink.
- [ ] Evitar animaciones, relojes por segundo y refrescos continuos.
- [ ] Instalar en una carpeta aislada y reversible.
- [ ] Probar diez aperturas, suspensión, reanudación y reinicio.
- [ ] Confirmar ausencia de core dumps y regresiones en KUAL/KOReader.

### Personalización posterior

- [ ] Persistir la preferencia de tema sin escribir fuera de la aplicación.
- [ ] Permitir ordenar accesos.
- [ ] Documentar Night Mode, perfiles, fuentes, márgenes, gestos y screensaver de KOReader.
- [ ] Medir ghosting y número de refrescos completos con ambos temas.

### Experimento Rust, bloqueado hasta estabilizar la WAF

- [ ] Preparar compilación cruzada `armv7-unknown-linux-gnueabi` soft-float.
- [ ] Probar un binario `hello-world` aislado.
- [ ] Registrar dependencias, kernel mínimo y compatibilidad real de glibc.
- [ ] Evaluar por separado MUSL estático.
- [ ] Usar Rust sólo como helper si ofrece una ventaja concreta frente a shell/JavaScript.

**Criterio para desbloquear esta fase:** prototipo WAF estable y necesidad técnica documentada que justifique un binario nativo.

## Cierre de cada sesión

- [ ] Actualizar este backlog y el inventario con evidencia real.
- [ ] Ejecutar validaciones de formato y enlaces.
- [ ] Comprobar que no haya datos personales ni binarios de terceros versionados.
- [ ] Dejar `git status` limpio.
- [ ] Crear un commit descriptivo y publicar `main`.

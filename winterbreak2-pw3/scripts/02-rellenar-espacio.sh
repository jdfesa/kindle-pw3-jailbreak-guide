#!/bin/bash

set -euo pipefail
source "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/_common.sh"

require_kindle
verify_sha256 "$PACKAGES_DIR/Filler.sh" '81fc6bf4f41638584b53041d41139984be13c6391ba0e949c9b93bec5b04ee0c'

printf '\nEn el programa que sigue elegir exactamente:\n'
printf '  1) Opcion 1: Fill the device\n'
printf '  2) Opcion 4: Custom value\n'
printf '  3) Escribir 70 como espacio libre\n'
printf '  4) Confirmar con y\n'
printf '  5) Al terminar, pulsar Enter una vez\n\n'

/bin/bash "$PACKAGES_DIR/Filler.sh"

printf '\nRELLENO_TERMINADO\n'
printf 'USB: DEJAR CONECTADO.\n'
printf 'Siguiente comando: ./scripts/03-verificar-y-expulsar.sh\n'


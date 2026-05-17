#!/bin/sh
set -eu

if [ -z "${GIT_REPO_URL:-}" ]; then
  echo "[theme-sync] ERROR: GIT_REPO_URL no esta definido. Edita el archivo .env."
  exit 1
fi

GIT_BRANCH="${GIT_BRANCH:-main}"
THEME_SOURCE_PATH="${THEME_SOURCE_PATH:-src/theme}"
THEME_NAME="${THEME_NAME:-webfusion-home}"
REPO_DIR="/tmp/source-repo"
DEST_DIR="/var/www/html/wp-content/themes/${THEME_NAME}"

echo "[theme-sync] Instalando herramientas dentro del contenedor..."
apk add --no-cache git rsync >/dev/null

echo "[theme-sync] Clonando repositorio: ${GIT_REPO_URL}"
rm -rf "${REPO_DIR}"
git clone --depth 1 --branch "${GIT_BRANCH}" "${GIT_REPO_URL}" "${REPO_DIR}"

if [ ! -d "${REPO_DIR}/${THEME_SOURCE_PATH}" ]; then
  echo "[theme-sync] ERROR: No existe la carpeta ${THEME_SOURCE_PATH} dentro del repositorio."
  echo "[theme-sync] Revisa THEME_SOURCE_PATH en .env."
  exit 1
fi

echo "[theme-sync] Esperando a que exista el directorio de temas de WordPress..."
for i in $(seq 1 60); do
  if [ -d "/var/www/html/wp-content/themes" ]; then
    break
  fi
  sleep 2
done

mkdir -p "${DEST_DIR}"

echo "[theme-sync] Copiando archivos PHP del tema a ${DEST_DIR}"
rsync -av --delete "${REPO_DIR}/${THEME_SOURCE_PATH}/" "${DEST_DIR}/"

# 33:33 es www-data dentro de la imagen oficial de WordPress.
chown -R 33:33 "${DEST_DIR}" 2>/dev/null || true

echo "[theme-sync] Sincronizacion finalizada correctamente."

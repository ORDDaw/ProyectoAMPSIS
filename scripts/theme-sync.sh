#!/bin/sh
set -e

echo "[theme-sync] Instalando herramientas dentro del contenedor..."
apk add --no-cache git rsync >/dev/null

if [ -z "$GIT_REPO_URL" ]; then
  echo "[theme-sync] ERROR: GIT_REPO_URL no esta definido."
  exit 1
fi

GIT_BRANCH="${GIT_BRANCH:-main}"
THEMES_SOURCE_PATH="${THEMES_SOURCE_PATH:-src/themes}"
ACTIVE_THEME="${ACTIVE_THEME:-webfusion-home}"

SOURCE_REPO="/tmp/source-repo"
WORDPRESS_THEMES_DIR="/var/www/html/wp-content/themes"

rm -rf "$SOURCE_REPO"

echo "[theme-sync] Clonando repositorio: $GIT_REPO_URL"
git clone --depth 1 --branch "$GIT_BRANCH" "$GIT_REPO_URL" "$SOURCE_REPO"

echo "[theme-sync] Ultimo commit descargado:"
git -C "$SOURCE_REPO" log -1 --oneline

if [ ! -d "$SOURCE_REPO/$THEMES_SOURCE_PATH" ]; then
  echo "[theme-sync] ERROR: No existe la carpeta $THEMES_SOURCE_PATH dentro del repositorio."
  echo "[theme-sync] Revisa THEMES_SOURCE_PATH en .env."
  exit 1
fi

echo "[theme-sync] Esperando a que exista el directorio de temas de WordPress..."
for i in $(seq 1 60); do
  if [ -d "$WORDPRESS_THEMES_DIR" ]; then
    break
  fi
  sleep 2
done

if [ ! -d "$WORDPRESS_THEMES_DIR" ]; then
  echo "[theme-sync] ERROR: No existe $WORDPRESS_THEMES_DIR"
  exit 1
fi

echo "[theme-sync] Copiando todos los temas a $WORDPRESS_THEMES_DIR..."
rsync -av --delete "$SOURCE_REPO/$THEMES_SOURCE_PATH"/ "$WORDPRESS_THEMES_DIR"/

echo "[theme-sync] Temas disponibles copiados:"
ls -1 "$WORDPRESS_THEMES_DIR"

echo "[theme-sync] Sincronizacion finalizada correctamente."
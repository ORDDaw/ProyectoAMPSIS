# Proyecto AMPSIS - Despliegue automatizado de WordPress

** Hecho por Ismael Cuadrado, Óscar Roldán y Daniel Antolín **

## 1. Objetivo

Este proyecto implementa un entorno reproducible para desplegar y actualizar la pagina principal de un sitio WordPress usando:

- GitHub como sistema de control de versiones.
- Vagrant para crear una maquina virtual Ubuntu.
- Docker y Docker Compose para gestionar los contenedores.
- Un contenedor Git llamado `theme-sync` para clonar el repositorio y copiar los archivos PHP al directorio de WordPress.

La actualizacion del contenido se realiza con un unico comando:


vagrant provision


## 2.Arquitectura

Servicios definidos en `docker-compose.yml`:

| Servicio | Funcion |
| --- | --- |
| `db` | Base de datos MySQL para WordPress. |
| `wordpress` | Servidor Apache con WordPress. |
| `theme-sync` | Contenedor que instala Git, clona el repositorio GitHub y copia el tema PHP. |
| `wp-cli` | Contenedor auxiliar para instalar WordPress y activar el tema automaticamente. |

## 3. Estructura del repositorio



   Vagrantfile
   docker-compose.yml
   .env.example
   .gitignore
   README.md
   scripts/
      theme-sync.sh
   src/
      theme/
         front-page.php
         functions.php
         index.php
         style.css


## 4. Requisitos previos

En el ordenador local deben estar instalados:

- VirtualBox.
- Vagrant.
- Git.

No es necesario instalar Docker en el ordenador local, porque Docker se instala automaticamente dentro de la maquina virtual.

## 5. Preparacion del repositorio GitHub

Crear un repositorio en GitHub y subir este proyecto:

```bash
git init
git add .
git commit -m "Proyecto WordPress automatizado"
git branch -M main
git remote add origin "link del repositorio" ( en nuestro caso ->https://github.com/ORDDaw/ProyectoAMPSIS.git)
git push -u origin main
```

## 6. Configuracion

Crear el archivo `.env` a partir del ejemplo:

```bash
cp .env.example .env
```

Editar esta linea:

```env
GIT_REPO_URL="link del repositorio"
```

Debe quedar con la URL real del repositorio GitHub. Ejemplo:

```env
GIT_REPO_URL=https://github.com/ORDDaw/ProyectoAMPSIS.git
```

## 7. Despliegue inicial

Ejecutar:

```bash
vagrant up
```

Durante el despliegue se realizan automaticamente estas acciones:

1. Se crea una maquina virtual Ubuntu.
2. Se instala Docker y Docker Compose.
3. Se levantan los contenedores de MySQL y WordPress.
4. El contenedor `theme-sync` clona el repositorio GitHub.
5. Se copian los archivos PHP desde `src/theme` a `wp-content/themes/webfusion-home`.
6. WP-CLI instala WordPress y activa el tema `webfusion-home`.

Al finalizar, la web estara disponible en:

```text
http://localhost:8080
```

El panel de administracion estara disponible en:

```text
http://localhost:8080/wp-admin
```

Credenciales de prueba:

```text
Usuario: admin
Password: admin1234
```

## 8. Actualizacion automatica del contenido

Modificar cualquier archivo del tema, por ejemplo:

El index.php está en caso de que no haber niguna otra página, 
la página que wordpress usará por defecto es front-page.php.
Para que salga el contenido editado hay que modificar el front-page.

```text
src/theme/index.php
```

Subir los cambios a GitHub:

```bash
git add .
git commit -m "Actualiza pagina principal"
git push origin main
```

Despues ejecutar:

```bash
vagrant provision
```

El aprovisionamiento realizara automaticamente:

1. Arranque o comprobacion de los contenedores.
2. Ejecucion del contenedor `theme-sync`.
3. Clonado actualizado del repositorio GitHub.
4. Copia del contenido PHP al tema de WordPress.
5. Activacion del tema con WP-CLI.

No es necesario copiar archivos manualmente dentro de la maquina virtual ni dentro del contenedor WordPress.

## 9. Comandos utiles

Ver contenedores activos:

```bash
vagrant ssh
cd /vagrant
docker compose ps
```

Ver logs de WordPress:

```bash
docker compose logs -f wordpress
```

Ejecutar de nuevo solo la sincronizacion Git:

```bash
docker compose run --rm theme-sync
```

Detener la maquina virtual:

```bash
vagrant halt
```

Eliminar la maquina virtual:

```bash
vagrant destroy
```



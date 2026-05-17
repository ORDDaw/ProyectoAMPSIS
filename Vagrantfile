Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  # Configuracion de hardware para VirtualBox
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.cpus = 2
    vb.name = "Proyecto AMPSIS"
  end

  # Descargar Docker y Docker Compose automaticamente al hacer vagrant up
  config.vm.provision "shell", inline: <<-SHELL
    set -e

    if ! command -v docker >/dev/null 2>&1; then
      echo "[Vagrant] Instalando Docker y Docker Compose..."
      apt-get update
      apt-get install -y ca-certificates curl gnupg lsb-release
      install -m 0755 -d /etc/apt/keyrings

      if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        chmod a+r /etc/apt/keyrings/docker.gpg
      fi

      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

      apt-get update
      apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      usermod -aG docker vagrant
      systemctl enable docker
      systemctl start docker
    else
      echo "[Vagrant] Docker ya esta instalado."
    fi

    docker --version
    docker compose version
  SHELL

  # Actualizacion automatica: se ejecuta en vagrant up y tambien en vagrant provision
  config.vm.provision "shell", run: "always", inline: <<-SHELL
    set -e
    cd /vagrant

    echo "[Vagrant] Iniciando aprovisionamiento del proyecto..."

    if [ ! -f .env ]; then
      cp .env.example .env
      echo "[Vagrant] Se ha creado .env desde .env.example."
      echo "[Vagrant] Edita GIT_REPO_URL en .env con la URL real de tu repositorio GitHub y ejecuta: vagrant provision"
      exit 1
    fi

    REPO_URL=$(grep '^GIT_REPO_URL=' .env | cut -d '=' -f2-)

    if [ -z "$REPO_URL" ] || echo "$REPO_URL" | grep -Eq "USUARIO|TU-USUARIO|REPOSITORIO"; then
      echo "[Vagrant] ERROR: Debes editar .env y cambiar GIT_REPO_URL por la URL real de tu repositorio GitHub."
      exit 1
    fi

    echo "[Vagrant] Levantando base de datos y WordPress..."
    docker compose up -d db wordpress

    echo "[Vagrant] Esperando a que WordPress cree los directorios internos..."
    for i in $(seq 1 60); do
      if docker compose exec -T wordpress test -d /var/www/html/wp-content/themes >/dev/null 2>&1; then
        break
      fi
      sleep 2
    done

    echo "[Vagrant] Ejecutando contenedor Git para sincronizar el tema desde GitHub..."
    docker compose run --rm theme-sync

    echo "[Vagrant] Esperando a que la base de datos este disponible..."
    for i in $(seq 1 60); do
      DB_CONTAINER=$(docker compose ps -q db)
      DB_STATUS=$(docker inspect --format='{{if .State.Health}}{{.State.Health.Status}}{{else}}starting{{end}}' "$DB_CONTAINER" 2>/dev/null || echo "starting")
      if [ "$DB_STATUS" = "healthy" ]; then
        break
      fi
      sleep 2
    done

    echo "[Vagrant] Instalando o actualizando WordPress con WP-CLI..."
    if ! docker compose run --rm wp-cli wp --allow-root --path=/var/www/html core is-installed >/dev/null 2>&1; then
      docker compose run --rm wp-cli wp --allow-root --path=/var/www/html core install \
        --url="http://localhost:8080" \
        --title="WebFusion Digital" \
        --admin_user="admin" \
        --admin_password="admin1234" \
        --admin_email="admin@example.com" \
        --skip-email
    fi

    docker compose run --rm wp-cli wp --allow-root --path=/var/www/html theme activate webfusion-home
    docker compose run --rm wp-cli wp --allow-root --path=/var/www/html option update blogdescription "Despliegue automatizado con Vagrant, Docker y GitHub"

    echo "[Vagrant] Proyecto desplegado correctamente."
    echo "[Vagrant] Web: http://localhost:8080"
    echo "[Vagrant] Admin: http://localhost:8080/wp-admin"
    echo "[Vagrant] Usuario: admin | Password: admin1234"
  SHELL
end

#!/bin/bash

# Script de despliegue para VPS
# Uso: ./deploy.sh

set -e

echo "🚀 Iniciando despliegue del Sistema de Grúas..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para imprimir mensajes
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar si estamos en el directorio correcto
if [ ! -f "app.py" ]; then
    print_error "No se encontró app.py. Asegúrate de estar en el directorio del proyecto."
    exit 1
fi

# 1. Actualizar sistema
print_status "Actualizando sistema..."
sudo apt update && sudo apt upgrade -y

# 2. Instalar dependencias del sistema
print_status "Instalando dependencias del sistema..."
sudo apt install -y python3 python3-pip python3-venv postgresql postgresql-contrib nginx git

# 3. Crear usuario para la aplicación
print_status "Creando usuario de la aplicación..."
sudo useradd -m -s /bin/bash gruas || true
sudo usermod -aG www-data gruas

# 4. Crear directorio de la aplicación
print_status "Configurando directorio de la aplicación..."
sudo mkdir -p /app/gruas
sudo chown -R gruas:gruas /app/gruas

# 5. Copiar archivos de la aplicación
print_status "Copiando archivos de la aplicación..."
sudo cp -r . /app/gruas/
sudo chown -R gruas:gruas /app/gruas

# 6. Configurar PostgreSQL
print_status "Configurando PostgreSQL..."
sudo -u postgres psql -c "CREATE DATABASE gruas_db;" || true
sudo -u postgres psql -c "CREATE USER gruas_user WITH PASSWORD 'gruas_password';" || true
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE gruas_db TO gruas_user;" || true

# 7. Configurar entorno virtual
print_status "Configurando entorno virtual..."
sudo -u gruas bash -c "cd /app/gruas && python3 -m venv venv"
sudo -u gruas bash -c "cd /app/gruas && source venv/bin/activate && pip install --upgrade pip"
sudo -u gruas bash -c "cd /app/gruas && source venv/bin/activate && pip install -r requirements.txt"

# 8. Configurar variables de entorno
print_status "Configurando variables de entorno..."
sudo -u gruas bash -c "cd /app/gruas && cp env.example .env"
print_warning "IMPORTANTE: Edita el archivo /app/gruas/.env con tus configuraciones reales"

# 9. Inicializar base de datos
print_status "Inicializando base de datos..."
sudo -u gruas bash -c "cd /app/gruas && source venv/bin/activate && python app.py" || true

# 10. Configurar Nginx
print_status "Configurando Nginx..."
sudo cp nginx.conf /etc/nginx/sites-available/gruas
sudo ln -sf /etc/nginx/sites-available/gruas /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx

# 11. Crear servicio systemd
print_status "Creando servicio systemd..."
sudo tee /etc/systemd/system/gruas.service > /dev/null <<EOF
[Unit]
Description=Sistema de Gestión de Grúas
After=network.target postgresql.service

[Service]
Type=exec
User=gruas
Group=gruas
WorkingDirectory=/app/gruas
Environment=PATH=/app/gruas/venv/bin
ExecStart=/app/gruas/venv/bin/gunicorn --config gunicorn.conf.py wsgi:app
ExecReload=/bin/kill -s HUP \$MAINPID
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# 12. Habilitar y iniciar servicios
print_status "Habilitando servicios..."
sudo systemctl daemon-reload
sudo systemctl enable gruas
sudo systemctl start gruas
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo systemctl enable nginx
sudo systemctl start nginx

# 13. Configurar firewall
print_status "Configurando firewall..."
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable

# 14. Verificar estado
print_status "Verificando estado de los servicios..."
sudo systemctl status gruas --no-pager
sudo systemctl status nginx --no-pager
sudo systemctl status postgresql --no-pager

print_status "✅ Despliegue completado!"
print_warning "Recuerda:"
print_warning "1. Editar /app/gruas/.env con tus configuraciones reales"
print_warning "2. Configurar tu dominio en /etc/nginx/sites-available/gruas"
print_warning "3. Obtener certificado SSL con Let's Encrypt"
print_warning "4. Reiniciar servicios: sudo systemctl restart gruas nginx"

echo ""
print_status "🌐 Tu aplicación debería estar disponible en: http://tu-servidor-ip"
#!/bin/bash

# Script de despliegue para cuando usas SCP
# Uso: ./deploy-scp.sh

set -e

APP_DIR="$(pwd)"
SERVICE_USER="$(whoami)"

echo "🚀 Iniciando despliegue del Sistema de Grúas (SCP)..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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
sudo apt install -y python3 python3-pip python3-venv postgresql postgresql-contrib nginx git unzip

# 3. Crear usuario para la aplicación
print_status "Creando usuario de la aplicación..."
sudo useradd -m -s /bin/bash $SERVICE_USER || true
sudo usermod -aG www-data $SERVICE_USER

# 4. Crear directorios necesarios
print_status "Creando directorios..."
sudo mkdir -p $APP_DIR
sudo mkdir -p /home/$SERVICE_USER/app
sudo mkdir -p /var/log/gruas
sudo chown -R $SERVICE_USER:$SERVICE_USER $APP_DIR
sudo chown -R $SERVICE_USER:$SERVICE_USER /home/$SERVICE_USER/app

# 5. Si hay archivo comprimido, descomprimirlo
if [ -f "programa.zip" ]; then
    print_status "Descomprimiendo archivos..."
    unzip -o programa.zip -d $APP_DIR/
    sudo chown -R $SERVICE_USER:$SERVICE_USER $APP_DIR
fi

# 6. Configurar PostgreSQL
print_status "Configurando PostgreSQL..."
sudo -u postgres psql -c "CREATE DATABASE gruas_db;" || true
sudo -u postgres psql -c "CREATE USER gruas_user WITH PASSWORD 'gruas_password';" || true
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE gruas_db TO gruas_user;" || true

# 7. Configurar entorno virtual
print_status "Configurando entorno virtual..."
sudo -u $SERVICE_USER bash -c "cd $APP_DIR && python3 -m venv venv"
sudo -u $SERVICE_USER bash -c "cd $APP_DIR && source venv/bin/activate && pip install --upgrade pip"
sudo -u $SERVICE_USER bash -c "cd $APP_DIR && source venv/bin/activate && pip install -r requirements.txt"

# 8. Configurar variables de entorno
print_status "Configurando variables de entorno..."
if [ ! -f "$APP_DIR/.env" ]; then
    sudo -u $SERVICE_USER bash -c "cd $APP_DIR && cp env.example .env"
    print_warning "IMPORTANTE: Edita el archivo $APP_DIR/.env con tus configuraciones reales"
fi

# 9. Crear directorios de uploads
print_status "Creando directorios de archivos..."
sudo -u $SERVICE_USER bash -c "mkdir -p $APP_DIR/static/uploads $APP_DIR/static/qr_codes"

# 10. Inicializar base de datos
print_status "Inicializando base de datos..."
sudo -u $SERVICE_USER bash -c "cd $APP_DIR && source venv/bin/activate && python -c 'from app import app, db; app.app_context().push(); db.create_all()'"

# 11. Configurar Nginx
print_status "Configurando Nginx..."
sudo tee /etc/nginx/sites-available/gruas > /dev/null <<EOF
server {
    listen 80;
    server_name _;  # Cambiar por tu dominio
    
    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
    }
    
    location /static/ {
        alias $APP_DIR/static/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    location /uploads/ {
        alias $APP_DIR/static/uploads/;
        expires 30d;
        add_header Cache-Control "public";
    }
    
    location /qr_codes/ {
        alias $APP_DIR/static/qr_codes/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    client_max_body_size 16M;
    
    access_log /var/log/nginx/gruas_access.log;
    error_log /var/log/nginx/gruas_error.log;
}
EOF

sudo ln -sf /etc/nginx/sites-available/gruas /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx

# 12. Crear servicio systemd
print_status "Creando servicio systemd..."
sudo tee /etc/systemd/system/gruas.service > /dev/null <<EOF
[Unit]
Description=Sistema de Gestión de Grúas
After=network.target postgresql.service

[Service]
Type=exec
User=$SERVICE_USER
Group=$SERVICE_USER
WorkingDirectory=$APP_DIR
Environment=PATH=$APP_DIR/venv/bin
ExecStart=$APP_DIR/venv/bin/gunicorn --config gunicorn.conf.py wsgi:app
ExecReload=/bin/kill -s HUP \$MAINPID
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# 13. Habilitar y iniciar servicios
print_status "Habilitando servicios..."
sudo systemctl daemon-reload
sudo systemctl enable gruas
sudo systemctl start gruas
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo systemctl enable nginx
sudo systemctl start nginx

# 14. Configurar firewall
print_status "Configurando firewall..."
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable

# 15. Verificar estado
print_status "Verificando estado de los servicios..."
sudo systemctl status gruas --no-pager
sudo systemctl status nginx --no-pager
sudo systemctl status postgresql --no-pager

print_status "✅ Despliegue completado!"
print_warning "Recuerda:"
print_warning "1. Editar $APP_DIR/.env con tus configuraciones reales"
print_warning "2. Configurar tu dominio en /etc/nginx/sites-available/gruas"
print_warning "3. Obtener certificado SSL con Let's Encrypt"
print_warning "4. Reiniciar servicios: sudo systemctl restart gruas nginx"

echo ""
print_status "🌐 Tu aplicación debería estar disponible en: http://$(curl -s ifconfig.me)"

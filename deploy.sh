#!/bin/bash

# Script de despliegue para VPS
# Uso: ./deploy.sh

echo "🚀 Iniciando despliegue de GRÚAS CRANES S.A.S"
echo "=============================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con color
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar si Python está instalado
if ! command -v python3 &> /dev/null; then
    print_error "Python3 no está instalado. Instálalo primero."
    exit 1
fi

# Verificar si pip está instalado
if ! command -v pip3 &> /dev/null; then
    print_error "pip3 no está instalado. Instálalo primero."
    exit 1
fi

print_status "Creando directorio de la aplicación..."
mkdir -p /opt/gruas-cranes
cd /opt/gruas-cranes

print_status "Copiando archivos de la aplicación..."
# Aquí copiarías los archivos de tu repositorio
# cp -r /ruta/a/tu/proyecto/* .

print_status "Creando entorno virtual..."
python3 -m venv venv
source venv/bin/activate

print_status "Instalando dependencias..."
pip install --upgrade pip
pip install -r requirements.txt

print_status "Configurando variables de entorno..."
cat > .env << EOF
SECRET_KEY=$(python3 -c 'import secrets; print(secrets.token_hex(32))')
FLASK_DEBUG=False
FLASK_HOST=0.0.0.0
FLASK_PORT=5000
EOF

print_status "Creando usuario del sistema..."
sudo useradd -r -s /bin/false gruas-cranes || true

print_status "Configurando permisos..."
sudo chown -R gruas-cranes:gruas-cranes /opt/gruas-cranes
sudo chmod +x /opt/gruas-cranes/deploy.sh

print_status "Creando servicio systemd..."
sudo tee /etc/systemd/system/gruas-cranes.service > /dev/null << EOF
[Unit]
Description=GRÚAS CRANES S.A.S Web Application
After=network.target

[Service]
Type=notify
User=gruas-cranes
Group=gruas-cranes
WorkingDirectory=/opt/gruas-cranes
Environment=PATH=/opt/gruas-cranes/venv/bin
ExecStart=/opt/gruas-cranes/venv/bin/gunicorn --config gunicorn.conf.py wsgi:app
ExecReload=/bin/kill -s HUP \$MAINPID
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

print_status "Recargando systemd..."
sudo systemctl daemon-reload

print_status "Habilitando servicio..."
sudo systemctl enable gruas-cranes

print_status "Iniciando servicio..."
sudo systemctl start gruas-cranes

print_status "Verificando estado del servicio..."
sleep 3
if sudo systemctl is-active --quiet gruas-cranes; then
    print_success "¡Servicio iniciado correctamente!"
else
    print_error "Error al iniciar el servicio"
    sudo systemctl status gruas-cranes
    exit 1
fi

print_status "Configurando Nginx (opcional)..."
if command -v nginx &> /dev/null; then
    print_warning "Nginx detectado. Configurando proxy reverso..."
    
    sudo tee /etc/nginx/sites-available/gruas-cranes > /dev/null << EOF
server {
    listen 80;
    server_name tu-dominio.com www.tu-dominio.com;
    
    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
    
    location /static {
        alias /opt/gruas-cranes/static;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

    sudo ln -sf /etc/nginx/sites-available/gruas-cranes /etc/nginx/sites-enabled/
    sudo nginx -t && sudo systemctl reload nginx
    print_success "Nginx configurado correctamente"
else
    print_warning "Nginx no detectado. La aplicación estará disponible en el puerto 5000"
fi

print_success "🎉 ¡Despliegue completado exitosamente!"
print_status "La aplicación está disponible en:"
print_status "  - Local: http://localhost:5000"
print_status "  - Red: http://$(hostname -I | awk '{print $1}'):5000"
print_status ""
print_status "Comandos útiles:"
print_status "  - Ver logs: sudo journalctl -u gruas-cranes -f"
print_status "  - Reiniciar: sudo systemctl restart gruas-cranes"
print_status "  - Estado: sudo systemctl status gruas-cranes"
print_status ""
print_status "Credenciales de prueba:"
print_status "  - Admin: admin / admin123"
print_status "  - Operador: operador / operador123"

#!/bin/bash
# Script de despliegue para VPS Ubuntu
# Sistema de Gestión de Grúas

echo "🚀 DESPLEGANDO SISTEMA DE GESTIÓN DE GRÚAS"
echo "=========================================="

# Variables
APP_DIR="/var/www/gruas"
APP_USER="www-data"
DB_NAME="gruas_db"
DB_USER="gruas_user"
DB_PASSWORD="gruas_password"

# Crear directorio de la aplicación
echo "📁 Creando directorio de aplicación..."
sudo mkdir -p $APP_DIR
sudo chown $USER:$USER $APP_DIR

# Copiar archivos de la aplicación
echo "📋 Copiando archivos de la aplicación..."
cp -r . $APP_DIR/
cd $APP_DIR

# Crear entorno virtual
echo "🐍 Creando entorno virtual..."
python3 -m venv venv
source venv/bin/activate

# Instalar dependencias
echo "📦 Instalando dependencias Python..."
pip install -r requirements.txt
pip install psycopg2-binary gunicorn

# Crear archivo .env
echo "⚙️ Creando archivo de configuración..."
cat > .env << EOF
SECRET_KEY=tu-clave-secreta-muy-segura-cambiar-en-produccion
DB_HOST=localhost
DB_PORT=5432
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
FLASK_ENV=production
EOF

# Crear base de datos
echo "🗄️ Creando estructura de base de datos..."
python -c "from app import app, db; app.app_context().push(); db.create_all(); print('Base de datos creada')"

# Configurar permisos
echo "🔐 Configurando permisos..."
sudo chown -R $APP_USER:$APP_USER $APP_DIR
sudo chmod -R 755 $APP_DIR

# Crear servicio systemd
echo "🔧 Creando servicio systemd..."
sudo tee /etc/systemd/system/gruas.service > /dev/null << EOF
[Unit]
Description=Gruas Cranes Web Application
After=network.target

[Service]
User=$APP_USER
Group=$APP_USER
WorkingDirectory=$APP_DIR
Environment=PATH=$APP_DIR/venv/bin
ExecStart=$APP_DIR/venv/bin/gunicorn --bind 127.0.0.1:5000 --workers 3 app:app
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Habilitar y iniciar servicio
echo "🚀 Iniciando servicio..."
sudo systemctl daemon-reload
sudo systemctl enable gruas
sudo systemctl start gruas

# Configurar Nginx
echo "🌐 Configurando Nginx..."
sudo tee /etc/nginx/sites-available/gruas > /dev/null << EOF
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
        alias $APP_DIR/static;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

# Habilitar sitio
sudo ln -s /etc/nginx/sites-available/gruas /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

echo "✅ Despliegue completado"
echo "🌐 Aplicación disponible en: http://tu-dominio.com"
echo "🔧 Para configurar SSL: sudo certbot --nginx -d tu-dominio.com"

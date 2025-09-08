#!/bin/bash
# Script de instalación para VPS Ubuntu
# Sistema de Gestión de Grúas

echo "🚀 INSTALANDO SISTEMA DE GESTIÓN DE GRÚAS EN UBUNTU"
echo "=================================================="

# Actualizar sistema
echo "📦 Actualizando sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar dependencias del sistema
echo "🔧 Instalando dependencias..."
sudo apt install -y python3 python3-pip python3-venv postgresql postgresql-contrib nginx git curl

# Instalar dependencias Python
echo "🐍 Instalando dependencias Python..."
pip3 install --user psycopg2-binary

# Configurar PostgreSQL
echo "🐘 Configurando PostgreSQL..."
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Crear base de datos y usuario
echo "📊 Creando base de datos..."
sudo -u postgres psql -c "CREATE DATABASE gruas_db;"
sudo -u postgres psql -c "CREATE USER gruas_user WITH PASSWORD 'gruas_password';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE gruas_db TO gruas_user;"
sudo -u postgres psql -c "ALTER USER gruas_user CREATEDB CREATEROLE SUPERUSER;"

# Configurar PostgreSQL para conexiones remotas
echo "🔌 Configurando conexiones remotas..."
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/*/main/postgresql.conf
sudo sed -i "s/#port = 5432/port = 5432/" /etc/postgresql/*/main/postgresql.conf

# Configurar pg_hba.conf
echo "host    all             all             0.0.0.0/0               md5" | sudo tee -a /etc/postgresql/*/main/pg_hba.conf

# Reiniciar PostgreSQL
sudo systemctl restart postgresql

# Crear directorio de la aplicación
echo "📁 Creando directorio de aplicación..."
sudo mkdir -p /var/www/gruas
sudo chown $USER:$USER /var/www/gruas

echo "✅ Instalación completada"
echo "🎯 Próximos pasos:"
echo "1. Subir archivos de la aplicación"
echo "2. Configurar variables de entorno"
echo "3. Instalar dependencias Python"
echo "4. Configurar Nginx"
echo "5. Configurar SSL (opcional)"

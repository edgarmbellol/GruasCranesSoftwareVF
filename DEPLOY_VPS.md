# 🚀 Guía de Despliegue en VPS - GRÚAS CRANES S.A.S

## 📋 **Problema de Códigos QR Resuelto**

Los códigos QR se generan con URLs locales (`192.168.x.x`) que no funcionan en VPS. Esta guía te muestra cómo solucionarlo.

## 🔧 **Configuración para VPS**

### **1. Configurar Variables de Entorno**

Crea un archivo `.env` en tu VPS:

```bash
# En tu VPS
nano .env
```

Contenido del archivo `.env`:
```env
# URL base del servidor (IMPORTANTE para códigos QR)
BASE_URL=https://tu-dominio.com
# o si no tienes dominio:
# BASE_URL=https://tu-ip-vps.com

# Clave secreta para sesiones
SECRET_KEY=tu-clave-secreta-muy-segura-aqui

# Base de datos (PostgreSQL recomendado para producción)
DATABASE_URL=postgresql://usuario:password@localhost:5432/gruas_cranes

# Configuración de archivos
UPLOAD_FOLDER=static/uploads
MAX_CONTENT_LENGTH=16777216

# Entorno de producción
FLASK_ENV=production
FLASK_DEBUG=False
```

### **2. Instalar Dependencias**

```bash
# Instalar dependencias Python
pip install -r requirements.txt

# Instalar PostgreSQL (Ubuntu/Debian)
sudo apt update
sudo apt install postgresql postgresql-contrib

# Crear base de datos
sudo -u postgres psql
CREATE DATABASE gruas_cranes;
CREATE USER gruas_user WITH PASSWORD 'tu_password_seguro';
GRANT ALL PRIVILEGES ON DATABASE gruas_cranes TO gruas_user;
\q
```

### **3. Configurar Base de Datos**

```bash
# Inicializar base de datos
python run.py

# O si usas Flask-Migrate:
flask db init
flask db migrate -m "Initial migration"
flask db upgrade
```

### **4. Regenerar Códigos QR**

**IMPORTANTE:** Después de configurar `BASE_URL`, regenera todos los códigos QR:

```bash
# Regenerar códigos QR con nueva URL
python regenerar_qr_vps.py
```

Este script:
- ✅ Lee la nueva `BASE_URL` del archivo `.env`
- ✅ Regenera todos los códigos QR existentes
- ✅ Los códigos QR ahora apuntan a tu VPS

### **5. Configurar Servidor Web (Nginx)**

```bash
# Instalar Nginx
sudo apt install nginx

# Crear configuración
sudo nano /etc/nginx/sites-available/gruas-cranes
```

Contenido de la configuración:
```nginx
server {
    listen 80;
    server_name tu-dominio.com;  # o tu-ip-vps.com

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /static {
        alias /ruta/a/tu/proyecto/static;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

```bash
# Activar configuración
sudo ln -s /etc/nginx/sites-available/gruas-cranes /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### **6. Configurar SSL (Opcional pero Recomendado)**

```bash
# Instalar Certbot
sudo apt install certbot python3-certbot-nginx

# Obtener certificado SSL
sudo certbot --nginx -d tu-dominio.com

# Renovar automáticamente
sudo crontab -e
# Agregar: 0 12 * * * /usr/bin/certbot renew --quiet
```

### **7. Ejecutar con Gunicorn**

```bash
# Instalar Gunicorn
pip install gunicorn

# Ejecutar aplicación
gunicorn --config gunicorn.conf.py wsgi:app

# O en background
nohup gunicorn --config gunicorn.conf.py wsgi:app > app.log 2>&1 &
```

### **8. Configurar Servicio Systemd**

```bash
# Crear servicio
sudo nano /etc/systemd/system/gruas-cranes.service
```

Contenido del servicio:
```ini
[Unit]
Description=GRÚAS CRANES S.A.S Web Application
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=/ruta/a/tu/proyecto
Environment=PATH=/ruta/a/tu/proyecto/venv/bin
ExecStart=/ruta/a/tu/proyecto/venv/bin/gunicorn --config gunicorn.conf.py wsgi:app
Restart=always

[Install]
WantedBy=multi-user.target
```

```bash
# Activar servicio
sudo systemctl daemon-reload
sudo systemctl enable gruas-cranes
sudo systemctl start gruas-cranes
sudo systemctl status gruas-cranes
```

## 🔍 **Verificar que Funciona**

### **1. Verificar Códigos QR**

1. Accede a tu VPS: `https://tu-dominio.com`
2. Ve a "QR Equipos"
3. Verifica que las URLs muestren tu dominio VPS
4. Escanea un código QR con tu móvil
5. Debe abrir el formulario en tu VPS

### **2. Verificar en Móvil**

Los códigos QR deben funcionar desde cualquier dispositivo:
- ✅ Escaneo desde móvil
- ✅ Acceso directo al formulario
- ✅ URL correcta del VPS

## 🛠️ **Comandos Útiles**

```bash
# Ver logs de la aplicación
tail -f app.log

# Reiniciar aplicación
sudo systemctl restart gruas-cranes

# Ver estado del servicio
sudo systemctl status gruas-cranes

# Regenerar QR si cambias de dominio
python regenerar_qr_vps.py

# Backup de base de datos
pg_dump gruas_cranes > backup_$(date +%Y%m%d).sql
```

## ⚠️ **Notas Importantes**

1. **Siempre regenera los QR** después de cambiar `BASE_URL`
2. **Usa HTTPS** en producción para seguridad
3. **Haz backup** de la base de datos regularmente
4. **Configura firewall** para proteger tu VPS
5. **Monitorea logs** para detectar problemas

## 🆘 **Solución de Problemas**

### **QR no funciona:**
```bash
# Verificar BASE_URL
echo $BASE_URL

# Regenerar QR
python regenerar_qr_vps.py

# Verificar logs
tail -f app.log
```

### **Aplicación no inicia:**
```bash
# Verificar dependencias
pip install -r requirements.txt

# Verificar base de datos
python run.py

# Verificar permisos
sudo chown -R www-data:www-data /ruta/a/tu/proyecto
```

---

**¡Listo!** 🎉 Tus códigos QR ahora funcionarán correctamente en tu VPS.

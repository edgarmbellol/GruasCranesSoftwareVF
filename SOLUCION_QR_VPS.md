# 🔧 Solución: Códigos QR no se muestran en VPS

## 🎯 **Problema Identificado**

En la VPS se muestra la URL correcta (`https://gestor.gruascranes.com/registro/1`) pero no se genera el código QR visual. Esto ocurre porque:

1. **Los códigos QR no se han generado** en el servidor VPS
2. **Falta la variable BASE_URL** configurada correctamente
3. **Permisos de directorio** pueden estar incorrectos

## 🚀 **Solución Rápida**

### **Paso 1: Verificar configuración**

```bash
# En tu VPS, verificar que existe el archivo .env
ls -la .env

# Si no existe, crearlo:
nano .env
```

Contenido del archivo `.env`:
```env
BASE_URL=https://gestor.gruascranes.com
SECRET_KEY=tu-clave-secreta-muy-segura
DATABASE_URL=postgresql://usuario:password@localhost:5432/gruas_cranes
```

### **Paso 2: Regenerar códigos QR**

```bash
# Opción 1: Script de diagnóstico completo
python diagnostico_qr.py

# Opción 2: Script simple de regeneración
python regenerar_qr_vps_simple.py

# Opción 3: Desde la aplicación web
# Ir a: https://gestor.gruascranes.com/regenerar-qr
```

### **Paso 3: Verificar permisos**

```bash
# Dar permisos correctos al directorio
sudo chown -R www-data:www-data static/
sudo chmod -R 755 static/

# O si usas otro usuario:
sudo chown -R tu-usuario:tu-usuario static/
sudo chmod -R 755 static/
```

### **Paso 4: Verificar que funciona**

1. Accede a: `https://gestor.gruascranes.com/qr-equipos`
2. Deberías ver los códigos QR generados
3. Prueba escanear uno con tu móvil

## 🔍 **Diagnóstico Detallado**

### **Verificar archivos QR generados:**

```bash
# Verificar que existen los archivos QR
ls -la static/qr_codes/

# Deberías ver archivos como:
# qr_equipo_1_BEU953.png
# qr_equipo_2_ABC123.png
# etc.
```

### **Verificar logs de la aplicación:**

```bash
# Ver logs de la aplicación
tail -f app.log

# O si usas systemd:
sudo journalctl -u gruas-cranes -f
```

### **Verificar desde el navegador:**

1. Abre: `https://gestor.gruascranes.com/static/qr_codes/qr_equipo_1_BEU953.png`
2. Deberías ver la imagen del código QR
3. Si da error 404, el archivo no existe

## 🛠️ **Solución Manual**

Si los scripts no funcionan, puedes regenerar manualmente:

```bash
# 1. Activar entorno virtual (si usas uno)
source venv/bin/activate

# 2. Ejecutar Python interactivo
python3

# 3. En Python:
from app import app, db, Equipo, generar_qr_equipo
import os
from dotenv import load_dotenv

load_dotenv()
with app.app_context():
    equipos = Equipo.query.filter_by(Estado='activo').all()
    for equipo in equipos:
        print(f"Generando QR para {equipo.Placa}...")
        qr_path = generar_qr_equipo(equipo.IdEquipo, equipo.Placa)
        print(f"QR generado: {qr_path}")
```

## ⚠️ **Problemas Comunes**

### **Error: "BASE_URL no configurada"**
```bash
# Solución: Configurar BASE_URL en .env
echo "BASE_URL=https://gestor.gruascranes.com" >> .env
```

### **Error: "Permission denied"**
```bash
# Solución: Corregir permisos
sudo chown -R www-data:www-data static/
sudo chmod -R 755 static/
```

### **Error: "No module named 'qrcode'"**
```bash
# Solución: Instalar dependencias
pip install -r requirements.txt
```

### **Error: "Directory not found"**
```bash
# Solución: Crear directorio manualmente
mkdir -p static/qr_codes
chmod 755 static/qr_codes
```

## ✅ **Verificación Final**

Después de seguir estos pasos:

1. ✅ Los códigos QR se generan correctamente
2. ✅ Se muestran en la página `/qr-equipos`
3. ✅ Se pueden escanear con el móvil
4. ✅ Redirigen al formulario correcto

## 🆘 **Si sigue sin funcionar**

1. **Verificar logs** de la aplicación
2. **Comprobar permisos** del directorio `static/`
3. **Verificar que** `python-dotenv` esté instalado
4. **Revisar** que la variable `BASE_URL` esté correcta
5. **Contactar** al administrador del servidor

---

**¡Listo!** 🎉 Con estos pasos, los códigos QR deberían funcionar correctamente en tu VPS.

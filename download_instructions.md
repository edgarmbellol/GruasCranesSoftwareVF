# 📥 Instrucciones para Descargar la Base de Datos

## 🚀 Opciones de Descarga

### 1. **Descarga Directa desde el Navegador**
Abre tu navegador y ve a:
```
http://31.97.146.193:5001/backups/gruas_db_backup_20250917_141823.tar.gz
```

### 2. **Descarga usando SCP (desde terminal)**
```bash
scp usuario@31.97.146.193:/home/mauricio/apps/flask_app/backups/gruas_db_backup_20250917_141823.tar.gz .
```

### 3. **Descarga usando wget/curl**
```bash
wget http://31.97.146.193:5001/backups/gruas_db_backup_20250917_141823.tar.gz
```

## 🔧 Restauración en tu Máquina Local

### 1. **Extraer el archivo comprimido**
```bash
tar -xzf gruas_db_backup_20250917_152916.tar.gz
```

### 2. **Crear la base de datos local**
```bash
createdb -U tu_usuario gruas_local
```

### 3. **Restaurar los datos (con parámetros específicos)**
```bash
psql -U tu_usuario -d gruas_local -f gruas_db_backup_20250917_152916.sql
```

### 4. **Parámetros incluidos en el backup:**
- `--encoding=UTF8` - Codificación UTF-8 forzada
- `--no-owner` - Sin información de propietario
- `--no-privileges` - Sin información de privilegios
- `--clean` - Limpia objetos antes de crear
- `--if-exists` - Evita errores si no existen objetos

## 📊 Información del Backup

- **Archivo SQL**: `gruas_db_backup_20250917_152916.sql` (52KB)
- **Archivo Comprimido**: `gruas_db_backup_20250917_152916.tar.gz` (15KB)
- **Fecha de Creación**: 17 de Septiembre de 2025, 15:29:16
- **Base de Datos Original**: gruas_db (Producción)
- **Parámetros**: UTF8, no-owner, no-privileges, clean, if-exists

## ⚠️ Notas Importantes

1. **Solo para Pruebas**: Este backup es solo para pruebas locales
2. **No Modificar Producción**: No uses este backup para modificar la base de datos de producción
3. **Datos Sensibles**: Contiene información real de la aplicación, úsala con cuidado
4. **Conexión**: Asegúrate de que el puerto 5001 esté abierto en el VPS

## 🆘 Si tienes problemas

1. **Verificar conexión**: `ping 31.97.146.193`
2. **Verificar puerto**: `telnet 31.97.146.193 5001`
3. **Verificar archivo**: El archivo debe existir en `/home/mauricio/apps/flask_app/backups/`

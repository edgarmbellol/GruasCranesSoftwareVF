# 🧹 Scripts de Limpieza de Base de Datos

Este directorio contiene scripts para limpiar la base de datos del Sistema de Gestión de Grúas, manteniendo solo los datos maestros.

## 📋 Datos Maestros (Se MANTIENEN)
- **Usuarios** - Incluyendo el usuario administrador
- **Tipos de Equipos** - Grúas, montacargas, etc.
- **Marcas** - Caterpillar, Liebherr, etc.
- **Estados de Equipos** - Operativo, mantenimiento, averiado
- **Cargos** - Operador, supervisor, etc.

## 🗑️ Datos Operativos (Se ELIMINAN)
- **Equipos** - Todos los equipos registrados
- **Registros de Horas** - Historial de trabajo
- **Clientes** - Información de clientes

## 🚀 Scripts Disponibles

### 1. Script Completo (`cleanup_database.py`)
Script interactivo con confirmación y reportes detallados.

```bash
# Ejecutar script completo
python3 cleanup_database.py

# O ejecutar directamente
./cleanup_database.py
```

**Características:**
- ✅ Confirmación interactiva
- ✅ Reporte antes y después
- ✅ Creación de archivo de backup
- ✅ Manejo de errores
- ✅ Logs detallados

### 2. Script Rápido (`quick_cleanup.py`)
Script con opciones específicas para limpieza selectiva.

```bash
# Ver estado actual
python3 quick_cleanup.py --status

# Eliminar solo equipos
python3 quick_cleanup.py --equipos

# Eliminar solo registros de horas
python3 quick_cleanup.py --registros

# Eliminar solo clientes
python3 quick_cleanup.py --clientes

# Eliminar todos los datos operativos
python3 quick_cleanup.py --all
```

## ⚠️ Advertencias Importantes

1. **BACKUP**: Siempre haz un backup de la base de datos antes de ejecutar estos scripts
2. **CONFIRMACIÓN**: El script completo solicita confirmación antes de proceder
3. **IRREVERSIBLE**: La eliminación de datos es irreversible
4. **USUARIOS**: Se mantienen todos los usuarios, incluyendo el administrador

## 🔧 Uso Recomendado

### Para Limpieza Completa (Recomendado)
```bash
# 1. Ver estado actual
python3 quick_cleanup.py --status

# 2. Ejecutar limpieza completa
python3 cleanup_database.py

# 3. Reiniciar aplicación
sudo systemctl restart gruas
```

### Para Limpieza Selectiva
```bash
# Eliminar solo equipos (mantener registros y clientes)
python3 quick_cleanup.py --equipos

# Eliminar solo registros de horas
python3 quick_cleanup.py --registros
```

## 📊 Ejemplo de Salida

```
🔧 Script de Limpieza de Base de Datos - Sistema de Grúas
============================================================
📊 Verificando estado actual de la base de datos...

📊 Estado ANTES de la limpieza:
============================================================
Tabla                 Registros  Estado         
------------------------------------------------------------
usuarios              5          ✅ MANTENER    
tipos_equipos         3          ✅ MANTENER    
marcas                4          ✅ MANTENER    
estado_equipos        3          ✅ MANTENER    
cargos                5          ✅ MANTENER    
------------------------------------------------------------
equipos               2          🗑️  ELIMINAR   
registro_horas        15         🗑️  ELIMINAR   
clientes              3          🗑️  ELIMINAR   
============================================================

🧹 Iniciando limpieza de la base de datos...
   🗑️  Eliminando registros de horas...
      ✅ 15 registros de horas eliminados
   🗑️  Eliminando equipos...
      ✅ 2 equipos eliminados
   🗑️  Eliminando clientes...
      ✅ 3 clientes eliminados
   ✅ Cambios confirmados en la base de datos

🎉 ¡Limpieza completada exitosamente!
```

## 🆘 Solución de Problemas

### Error: "No se encontró la aplicación Flask"
```bash
# Asegúrate de estar en el directorio correcto
cd /home/mauricio/apps/flask_app
python3 cleanup_database.py
```

### Error: "Permission denied"
```bash
# Hacer el script ejecutable
chmod +x cleanup_database.py
chmod +x quick_cleanup.py
```

### Error de base de datos
```bash
# Verificar que la aplicación esté funcionando
sudo systemctl status gruas

# Reiniciar la aplicación
sudo systemctl restart gruas
```

## 📁 Archivos Generados

- `backup_info_YYYYMMDD_HHMMSS.txt` - Información del backup creado
- Logs en la consola durante la ejecución

## 🔄 Después de la Limpieza

1. **Reiniciar la aplicación**: `sudo systemctl restart gruas`
2. **Verificar funcionamiento**: Acceder a la aplicación web
3. **Crear datos de prueba**: Usar la interfaz web para crear equipos de prueba
4. **Verificar usuarios**: Confirmar que el usuario admin sigue funcionando

---

**⚠️ IMPORTANTE**: Estos scripts están diseñados para entornos de desarrollo y testing. Para producción, considera hacer un backup completo de la base de datos antes de ejecutar cualquier limpieza.


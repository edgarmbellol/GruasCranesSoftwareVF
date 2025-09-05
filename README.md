# 🏗️ Sistema de Gestión de Grúas - GRÚAS CRANES S.A.S

Sistema web desarrollado en Flask para la gestión integral de equipos de grúas, control de horas de trabajo, seguimiento de operarios y administración de clientes.

## 🚀 Características Principales

### 👥 Gestión de Usuarios
- **Autenticación segura** con hash de contraseñas
- **Roles diferenciados**: Administrador y Empleado
- **Cambio de contraseñas** para todos los usuarios
- **Gestión completa** de usuarios (CRUD)

### 🏗️ Gestión de Equipos
- **Registro completo** de equipos de grúas
- **Códigos QR automáticos** para cada equipo
- **Estados operacionales** en tiempo real
- **Seguimiento de operarios** asignados

### ⏰ Control de Horas de Trabajo
- **Registro de entrada/salida** por empleado
- **Formularios inteligentes** que se adaptan al cargo
- **Validaciones en tiempo real** (fecha, hora, kilometraje, horómetro)
- **Evidencia fotográfica** obligatoria
- **Geolocalización automática**

### 📊 Reportes y Dashboard
- **Dashboard en tiempo real** con estadísticas operacionales
- **Reportes de horas por empleado** con vista de calendario
- **Estado de empleados** (trabajando/libre)
- **Estado de equipos** (operando/disponible)
- **Registros recientes** de actividad

### 🏢 Gestión de Clientes
- **CRUD completo** de clientes
- **Validación de NIT** único
- **Asociación con equipos** en operación

### 🗂️ Datos Maestros
- **Tipos de Equipos**: Categorización de grúas
- **Marcas**: Fabricantes de equipos
- **Estados de Equipos**: Operativo, Mantenimiento, Averiado, etc.
- **Cargos**: Operador, Aparejador, Supervisor, etc.

## 🛠️ Tecnologías Utilizadas

### Backend
- **Flask** - Framework web
- **SQLAlchemy** - ORM para base de datos
- **Werkzeug** - Seguridad y hash de contraseñas
- **WTForms** - Formularios y validación
- **Python-dateutil** - Manejo de fechas

### Frontend
- **Bootstrap 5** - Framework CSS
- **Font Awesome** - Iconografía
- **JavaScript Vanilla** - Interactividad
- **CSS3** - Estilos personalizados

### Base de Datos
- **SQLite** - Base de datos de desarrollo
- **MySQL/PostgreSQL** - Compatible para producción

### Funcionalidades Adicionales
- **QR Code Generation** - Códigos QR automáticos
- **Image Processing** - Procesamiento de imágenes
- **Geolocation API** - Ubicación automática
- **Responsive Design** - Optimizado para móviles

## 📱 Diseño Responsivo

El sistema está completamente optimizado para dispositivos móviles:
- **Formularios adaptativos** para pantallas táctiles
- **Navegación intuitiva** en dispositivos pequeños
- **Carga rápida** en conexiones lentas
- **Interfaz táctil** optimizada

## 🎨 Paleta de Colores

- **Verde Esmeralda** (#27AE60) - Color principal
- **Amarillo Maquinaria** (#F1C40F) - Acentos
- **Negro** (#111111) - Texto principal
- **Gris Acero** (#7F8C8D) - Elementos secundarios

## 🚀 Instalación y Configuración

### Requisitos Previos
- Python 3.8+
- pip (gestor de paquetes de Python)

### Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/edgarmbellol/SoftwareGruas.git
cd SoftwareGruas
```

2. **Crear entorno virtual**
```bash
python -m venv venv
# Windows
venv\Scripts\activate
# Linux/Mac
source venv/bin/activate
```

3. **Instalar dependencias**
```bash
pip install -r requirements.txt
```

4. **Inicializar datos de demostración (opcional)**
```bash
python init_demo_data.py
```
Esto creará:
- 3 empleados de prueba
- 3 clientes de prueba  
- 2 equipos adicionales
- Datos maestros básicos

5. **Configurar base de datos**
```bash
python run.py
```

6. **Acceder al sistema**
- URL: http://localhost:5000
- Usuario administrador: admin@gruas.com
- Contraseña: admin123

### 📊 Datos de Demostración

Si ejecutaste `init_demo_data.py`, tendrás estos usuarios adicionales:

| Email | Contraseña | Rol |
|-------|------------|-----|
| admin@gruas.com | admin123 | Administrador |
| juan.perez@empresa.com | 123456 | Empleado |
| maria.garcia@empresa.com | 123456 | Empleado |
| carlos.lopez@empresa.com | 123456 | Empleado |

### 🧹 Scripts de Limpieza

#### **Limpiar Registros de Horas**
```bash
# Ver estadísticas
python limpiar_registros.py stats

# Eliminar todos los registros
python limpiar_registros.py all

# Eliminar por rango de fechas
python limpiar_registros.py range 2024-01-01 2024-12-31
```

#### **Reset Completo (Emergencia)**
```bash
# Resetear toda la base de datos (mantiene solo admin y datos maestros)
python reset_database.py
```

#### **Backup y Restore**
```bash
# Crear backup
python backup_db.py backup

# Restaurar desde backup
python backup_db.py restore backups/gruas_cranes_backup_20240904_230500.db
```

## 📁 Estructura del Proyecto

```
SoftwareGruas/
├── app.py                 # Aplicación principal Flask
├── models.py              # Modelos de base de datos
├── forms.py               # Formularios WTForms
├── requirements.txt       # Dependencias Python
├── run.py                 # Script de inicio
├── static/                # Archivos estáticos
│   ├── css/              # Estilos CSS
│   ├── js/               # JavaScript
│   └── images/           # Imágenes
├── templates/             # Plantillas HTML
│   ├── base.html         # Plantilla base
│   ├── login.html        # Página de login
│   ├── dashboard.html    # Panel principal
│   └── [módulos]/        # Plantillas por módulo
└── uploads/              # Archivos subidos
```

## 🔧 Configuración para Producción

### Variables de Entorno
```bash
export FLASK_ENV=production
export DATABASE_URL=mysql://user:password@localhost/gruas_cranes
export SECRET_KEY=your-secret-key-here
```

### Servidor de Producción
```bash
gunicorn --config gunicorn.conf.py wsgi:app
```

## 👥 Roles y Permisos

### Administrador
- Gestión completa de usuarios
- Gestión de equipos
- Gestión de clientes
- Acceso a reportes
- Gestión de datos maestros
- Generación de códigos QR

### Empleado
- Registro de horas de trabajo
- Visualización de equipos disponibles
- Acceso a códigos QR (solo lectura)
- Cambio de contraseña personal

## 📊 Funcionalidades del Dashboard

### Estadísticas en Tiempo Real
- **Total de equipos** activos
- **Equipos operando** vs disponibles
- **Empleados trabajando** vs libres
- **Registros recientes** de actividad

### Estado de Empleados
- Lista de empleados con estado actual
- Equipo asignado (si está trabajando)
- Hora de entrada
- Cargo del empleado

### Estado de Equipos
- Lista de equipos con estado operacional
- Operador asignado (si está operando)
- Botón "Iniciar Trabajo" para equipos disponibles

## 🔒 Seguridad

- **Autenticación obligatoria** para todas las rutas
- **Hash seguro** de contraseñas con Werkzeug
- **Validación de sesiones** en cada request
- **Protección CSRF** en formularios
- **Validación de entrada** en frontend y backend

## 📱 Optimización Móvil

- **Formularios táctiles** optimizados
- **Carga de imágenes** con preview
- **Geolocalización automática**
- **Navegación intuitiva** en pantallas pequeñas
- **Validación en tiempo real**

## 🚀 Despliegue

### VPS/Cloud
1. Configurar servidor web (Nginx/Apache)
2. Instalar Python y dependencias
3. Configurar base de datos MySQL/PostgreSQL
4. Configurar SSL/HTTPS
5. Desplegar con Gunicorn

### Docker (Próximamente)
```bash
docker build -t software-gruas .
docker run -p 5000:5000 software-gruas
```

## 🤝 Contribución

1. Fork el proyecto
2. Crear rama para feature (`git checkout -b feature/AmazingFeature`)
3. Commit cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 👨‍💻 Desarrollador

**Edgar M. Bello**
- GitHub: [@edgarmbellol](https://github.com/edgarmbellol)
- Email: contacto@edgarmbello.com

## 📞 Soporte

Para soporte técnico o consultas:
- Crear un issue en GitHub
- Contactar al desarrollador

---

**GRÚAS CRANES S.A.S** - Sistema de Gestión Integral de Equipos de Construcción
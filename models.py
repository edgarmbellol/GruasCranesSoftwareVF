from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash

db = SQLAlchemy()

class User(db.Model):
    """Modelo de Usuario para el sistema de grúas"""
    __tablename__ = 'users'
    
    id = db.Column(db.Integer, primary_key=True)
    
    # Información personal
    tipo_documento = db.Column(db.String(20), nullable=False)  # CC, CE, NIT, etc.
    documento = db.Column(db.String(20), unique=True, nullable=False)
    nombre = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    celular = db.Column(db.String(15), nullable=False)
    contrasena_hash = db.Column(db.String(255), nullable=False)
    
    # Información del sistema
    fecha_creacion = db.Column(db.DateTime, default=datetime.utcnow)
    ultimo_login = db.Column(db.DateTime)
    estado = db.Column(db.String(20), default='activo')  # activo, inactivo, suspendido
    perfil_usuario = db.Column(db.String(20), nullable=False)  # administrador, empleado
    fecha_inactividad = db.Column(db.DateTime)
    
    def __init__(self, tipo_documento, documento, nombre, email, celular, 
                 contrasena, perfil_usuario='empleado'):
        self.tipo_documento = tipo_documento
        self.documento = documento
        self.nombre = nombre
        self.email = email
        self.celular = celular
        self.set_password(contrasena)
        self.perfil_usuario = perfil_usuario
        self.estado = 'activo'
    
    def set_password(self, password):
        """Encripta la contraseña"""
        self.contrasena_hash = generate_password_hash(password)
    
    def check_password(self, password):
        """Verifica la contraseña"""
        return check_password_hash(self.contrasena_hash, password)
    
    def update_last_login(self):
        """Actualiza el último login"""
        self.ultimo_login = datetime.utcnow()
        db.session.commit()
    
    def deactivate_user(self):
        """Desactiva el usuario"""
        self.estado = 'inactivo'
        self.fecha_inactividad = datetime.utcnow()
        db.session.commit()
    
    def activate_user(self):
        """Activa el usuario"""
        self.estado = 'activo'
        self.fecha_inactividad = None
        db.session.commit()
    
    def to_dict(self):
        """Convierte el objeto a diccionario para JSON"""
        return {
            'id': self.id,
            'tipo_documento': self.tipo_documento,
            'documento': self.documento,
            'nombre': self.nombre,
            'email': self.email,
            'celular': self.celular,
            'fecha_creacion': self.fecha_creacion.isoformat() if self.fecha_creacion else None,
            'ultimo_login': self.ultimo_login.isoformat() if self.ultimo_login else None,
            'estado': self.estado,
            'perfil_usuario': self.perfil_usuario,
            'fecha_inactividad': self.fecha_inactividad.isoformat() if self.fecha_inactividad else None
        }
    
    def __repr__(self):
        return f'<User {self.nombre} - {self.documento}>'

# ===== MODELOS PARA EQUIPOS =====

class TipoEquipo(db.Model):
    """Modelo para tipos de equipos (grúas, montacargas, etc.)"""
    __tablename__ = 'tipo_equipos'
    
    IdTipoEquipo = db.Column(db.Integer, primary_key=True)
    descripcion = db.Column(db.String(100), nullable=False)
    estado = db.Column(db.String(20), default='activo')
    
    # Relación con equipos
    equipos = db.relationship('Equipo', backref='tipo_equipo', lazy=True)
    
    def to_dict(self):
        return {
            'IdTipoEquipo': self.IdTipoEquipo,
            'descripcion': self.descripcion,
            'estado': self.estado
        }
    
    def __repr__(self):
        return f'<TipoEquipo {self.descripcion}>'

class Marca(db.Model):
    """Modelo para marcas de equipos"""
    __tablename__ = 'marcas'
    
    IdMarca = db.Column(db.Integer, primary_key=True)
    DescripcionMarca = db.Column(db.String(100), nullable=False)
    estado = db.Column(db.String(20), default='activo')
    
    # Relación con equipos
    equipos = db.relationship('Equipo', backref='marca', lazy=True)
    
    def to_dict(self):
        return {
            'IdMarca': self.IdMarca,
            'DescripcionMarca': self.DescripcionMarca,
            'estado': self.estado
        }
    
    def __repr__(self):
        return f'<Marca {self.DescripcionMarca}>'

class EstadoEquipo(db.Model):
    """Modelo para estados de equipos (operativo, mantenimiento, etc.)"""
    __tablename__ = 'estado_equipos'
    
    IdEstadoEquipo = db.Column(db.Integer, primary_key=True)
    Descripcion = db.Column(db.String(100), nullable=False)
    Estado = db.Column(db.String(20), default='activo')
    
    # Relación con equipos
    equipos = db.relationship('Equipo', backref='estado_equipo', lazy=True)
    
    def to_dict(self):
        return {
            'IdEstadoEquipo': self.IdEstadoEquipo,
            'Descripcion': self.Descripcion,
            'Estado': self.Estado
        }
    
    def __repr__(self):
        return f'<EstadoEquipo {self.Descripcion}>'

class Cargo(db.Model):
    """Modelo para cargos de empleados"""
    __tablename__ = 'cargos'
    
    IdCargo = db.Column(db.Integer, primary_key=True)
    descripcionCargo = db.Column(db.String(100), nullable=False)
    Estado = db.Column(db.String(20), default='activo')
    
    # Relación con usuarios (futura)
    # usuarios = db.relationship('User', backref='cargo', lazy=True)
    
    def to_dict(self):
        return {
            'IdCargo': self.IdCargo,
            'descripcionCargo': self.descripcionCargo,
            'Estado': self.Estado
        }
    
    def __repr__(self):
        return f'<Cargo {self.descripcionCargo}>'

class Cliente(db.Model):
    """Modelo para clientes"""
    __tablename__ = 'clientes'
    
    IdCliente = db.Column(db.Integer, primary_key=True)
    NombreCliente = db.Column(db.String(200), nullable=False)
    Nit = db.Column(db.String(20), unique=True, nullable=False)
    FechaCreacion = db.Column(db.DateTime, default=datetime.utcnow)
    UsuarioCrea = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    Estado = db.Column(db.String(20), default='activo')
    UsuarioInactiva = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    FechaInactiva = db.Column(db.DateTime, nullable=True)
    
    # Relaciones
    usuario_crea = db.relationship('User', foreign_keys=[UsuarioCrea], backref='clientes_creados')
    usuario_inactiva = db.relationship('User', foreign_keys=[UsuarioInactiva], backref='clientes_inactivados')
    
    def to_dict(self):
        return {
            'IdCliente': self.IdCliente,
            'NombreCliente': self.NombreCliente,
            'Nit': self.Nit,
            'FechaCreacion': self.FechaCreacion.isoformat() if self.FechaCreacion else None,
            'UsuarioCrea': self.UsuarioCrea,
            'Estado': self.Estado,
            'UsuarioInactiva': self.UsuarioInactiva,
            'FechaInactiva': self.FechaInactiva.isoformat() if self.FechaInactiva else None
        }
    
    def inactivar(self, usuario_id):
        """Inactivar cliente"""
        self.Estado = 'inactivo'
        self.UsuarioInactiva = usuario_id
        self.FechaInactiva = datetime.utcnow()
    
    def activar(self):
        """Activar cliente"""
        self.Estado = 'activo'
        self.UsuarioInactiva = None
        self.FechaInactiva = None
    
    def __repr__(self):
        return f'<Cliente {self.NombreCliente}>'

class RegistroHoras(db.Model):
    """Modelo para registro de horas de trabajo en grúas"""
    __tablename__ = 'registro_horas'
    
    IdRegistro = db.Column(db.Integer, primary_key=True)
    IdEquipo = db.Column(db.Integer, db.ForeignKey('equipos.IdEquipo'), nullable=False)
    IdEmpleado = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    IdCargo = db.Column(db.Integer, db.ForeignKey('cargos.IdCargo'), nullable=False)
    IdCliente = db.Column(db.Integer, db.ForeignKey('clientes.IdCliente'), nullable=True)
    IdEstadoEquipo = db.Column(db.Integer, db.ForeignKey('estado_equipos.IdEstadoEquipo'), nullable=False)
    
    # Fechas y horas
    FechaAutomatica = db.Column(db.DateTime, default=datetime.utcnow)
    FechaEmpleado = db.Column(db.Date, nullable=False)
    HoraEmpleado = db.Column(db.Time, nullable=False)
    
    # Datos del equipo (solo para operadores)
    Kilometraje = db.Column(db.Float, nullable=True)
    Horometro = db.Column(db.Float, nullable=True)
    
    # Imágenes
    FotoKilometraje = db.Column(db.String(255), nullable=True)
    FotoHorometro = db.Column(db.String(255), nullable=True)
    FotoGrua = db.Column(db.String(255), nullable=True)
    
    # Información adicional
    Observacion = db.Column(db.Text, nullable=True)
    Ubicacion = db.Column(db.String(255), nullable=True)
    Latitud = db.Column(db.Float, nullable=True)
    Longitud = db.Column(db.Float, nullable=True)
    
    # Control de entrada/salida
    TipoRegistro = db.Column(db.String(20), nullable=False)  # 'entrada' o 'salida'
    FechaCreacion = db.Column(db.DateTime, default=datetime.utcnow)
    
    # Relaciones
    equipo = db.relationship('Equipo', backref='registros_horas')
    empleado = db.relationship('User', backref='registros_horas')
    cargo = db.relationship('Cargo', backref='registros_horas')
    cliente = db.relationship('Cliente', backref='registros_horas')
    estado_equipo = db.relationship('EstadoEquipo', backref='registros_horas')
    
    def to_dict(self):
        return {
            'IdRegistro': self.IdRegistro,
            'IdEquipo': self.IdEquipo,
            'IdEmpleado': self.IdEmpleado,
            'IdCargo': self.IdCargo,
            'IdCliente': self.IdCliente,
            'IdEstadoEquipo': self.IdEstadoEquipo,
            'FechaAutomatica': self.FechaAutomatica.isoformat() if self.FechaAutomatica else None,
            'FechaEmpleado': self.FechaEmpleado.isoformat() if self.FechaEmpleado else None,
            'HoraEmpleado': self.HoraEmpleado.isoformat() if self.HoraEmpleado else None,
            'Kilometraje': self.Kilometraje,
            'Horometro': self.Horometro,
            'FotoKilometraje': self.FotoKilometraje,
            'FotoHorometro': self.FotoHorometro,
            'FotoGrua': self.FotoGrua,
            'Observacion': self.Observacion,
            'Ubicacion': self.Ubicacion,
            'Latitud': self.Latitud,
            'Longitud': self.Longitud,
            'TipoRegistro': self.TipoRegistro,
            'FechaCreacion': self.FechaCreacion.isoformat() if self.FechaCreacion else None
        }
    
    def es_operador(self):
        """Verifica si el cargo es operador"""
        return self.cargo and 'operador' in self.cargo.descripcionCargo.lower()
    
    def __repr__(self):
        return f'<RegistroHoras {self.empleado.nombre if self.empleado else "N/A"} - {self.TipoRegistro}>'

class Equipo(db.Model):
    """Modelo principal para equipos"""
    __tablename__ = 'equipos'
    
    IdEquipo = db.Column(db.Integer, primary_key=True)
    
    # Información básica del equipo
    IdTipoEquipo = db.Column(db.Integer, db.ForeignKey('tipo_equipos.IdTipoEquipo'), nullable=False)
    Placa = db.Column(db.String(20), unique=True, nullable=False)
    Capacidad = db.Column(db.Float, nullable=False)  # Capacidad en toneladas
    IdMarca = db.Column(db.Integer, db.ForeignKey('marcas.IdMarca'), nullable=False)
    Referencia = db.Column(db.String(100), nullable=True)
    Color = db.Column(db.String(50), nullable=True)
    Modelo = db.Column(db.String(100), nullable=True)
    CentroCostos = db.Column(db.String(100), nullable=True)
    Estado = db.Column(db.String(20), default='activo')  # activo, inactivo
    IdEstadoEquipo = db.Column(db.Integer, db.ForeignKey('estado_equipos.IdEstadoEquipo'), nullable=False)
    
    # Información de auditoría
    FechaCreacion = db.Column(db.DateTime, default=datetime.utcnow)
    UsuarioCreacion = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    FechaInactivacion = db.Column(db.DateTime, nullable=True)
    UsuarioInactivacion = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    
    # Relaciones
    usuario_creacion = db.relationship('User', foreign_keys=[UsuarioCreacion], backref='equipos_creados')
    usuario_inactivacion = db.relationship('User', foreign_keys=[UsuarioInactivacion], backref='equipos_inactivados')
    
    def __init__(self, IdTipoEquipo, Placa, Capacidad, IdMarca, IdEstadoEquipo, 
                 UsuarioCreacion, Referencia=None, Color=None, Modelo=None, 
                 CentroCostos=None):
        self.IdTipoEquipo = IdTipoEquipo
        self.Placa = Placa
        self.Capacidad = Capacidad
        self.IdMarca = IdMarca
        self.IdEstadoEquipo = IdEstadoEquipo
        self.UsuarioCreacion = UsuarioCreacion
        self.Referencia = Referencia
        self.Color = Color
        self.Modelo = Modelo
        self.CentroCostos = CentroCostos
        self.Estado = 'activo'
    
    def inactivar_equipo(self, usuario_id):
        """Inactiva el equipo"""
        self.Estado = 'inactivo'
        self.FechaInactivacion = datetime.utcnow()
        self.UsuarioInactivacion = usuario_id
        db.session.commit()
    
    def activar_equipo(self):
        """Activa el equipo"""
        self.Estado = 'activo'
        self.FechaInactivacion = None
        self.UsuarioInactivacion = None
        db.session.commit()
    
    def to_dict(self):
        """Convierte el objeto a diccionario para JSON"""
        return {
            'IdEquipo': self.IdEquipo,
            'IdTipoEquipo': self.IdTipoEquipo,
            'Placa': self.Placa,
            'Capacidad': self.Capacidad,
            'IdMarca': self.IdMarca,
            'Referencia': self.Referencia,
            'Color': self.Color,
            'Modelo': self.Modelo,
            'CentroCostos': self.CentroCostos,
            'Estado': self.Estado,
            'IdEstadoEquipo': self.IdEstadoEquipo,
            'FechaCreacion': self.FechaCreacion.isoformat() if self.FechaCreacion else None,
            'UsuarioCreacion': self.UsuarioCreacion,
            'FechaInactivacion': self.FechaInactivacion.isoformat() if self.FechaInactivacion else None,
            'UsuarioInactivacion': self.UsuarioInactivacion,
            'tipo_equipo': self.tipo_equipo.descripcion if self.tipo_equipo else None,
            'marca': self.marca.DescripcionMarca if self.marca else None,
            'estado_equipo': self.estado_equipo.Descripcion if self.estado_equipo else None
        }
    
    def esta_operando(self):
        """Verifica si el equipo está siendo operado actualmente (al menos un empleado trabajando)"""
        # Buscar TODAS las entradas para este equipo
        entradas = RegistroHoras.query.filter_by(
            IdEquipo=self.IdEquipo,
            TipoRegistro='entrada'
        ).all()
        
        # Para cada entrada, verificar si tiene salida correspondiente
        entradas_sin_salida = []
        for entrada in entradas:
            salida_correspondiente = RegistroHoras.query.filter(
                RegistroHoras.IdEquipo == self.IdEquipo,
                RegistroHoras.IdEmpleado == entrada.IdEmpleado,
                RegistroHoras.TipoRegistro == 'salida',
                RegistroHoras.FechaCreacion > entrada.FechaCreacion
            ).first()
            
            if not salida_correspondiente:
                entradas_sin_salida.append(entrada)
        
        esta_operando = len(entradas_sin_salida) > 0
        print(f"DEBUG MODELO: Equipo {self.Placa} - Entradas sin salida: {len(entradas_sin_salida)}, Operando: {esta_operando}")
        
        return esta_operando
    
    def obtener_operadores_actuales(self):
        """Obtiene todos los operadores actuales del equipo si está siendo operado"""
        if not self.esta_operando():
            return []
            
        # Buscar todas las entradas sin salida para este equipo
        entradas = RegistroHoras.query.filter_by(
            IdEquipo=self.IdEquipo,
            TipoRegistro='entrada'
        ).all()
        
        operadores_actuales = []
        for entrada in entradas:
            salida_correspondiente = RegistroHoras.query.filter(
                RegistroHoras.IdEquipo == self.IdEquipo,
                RegistroHoras.IdEmpleado == entrada.IdEmpleado,
                RegistroHoras.TipoRegistro == 'salida',
                RegistroHoras.FechaCreacion > entrada.FechaCreacion
            ).first()
            
            if not salida_correspondiente:
                # Incluir información del cargo y entrada
                operador_info = {
                    'empleado': entrada.empleado,
                    'cargo': entrada.cargo,
                    'entrada': entrada
                }
                operadores_actuales.append(operador_info)
        
        return operadores_actuales
    
    def obtener_entrada_actual(self):
        """Obtiene el registro de entrada actual si el equipo está siendo operado"""
        if not self.esta_operando():
            return None
            
        return RegistroHoras.query.filter_by(
            IdEquipo=self.IdEquipo,
            TipoRegistro='entrada'
        ).filter(
            ~RegistroHoras.IdRegistro.in_(
                db.session.query(RegistroHoras.IdRegistro).filter_by(
                    IdEquipo=self.IdEquipo,
                    TipoRegistro='salida'
                )
            )
        ).first()
    
    def __repr__(self):
        return f'<Equipo {self.Placa} - {self.tipo_equipo.descripcion if self.tipo_equipo else "Sin tipo"}>'

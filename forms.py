from flask_wtf import FlaskForm
from flask_wtf.file import FileField, FileAllowed
from wtforms import StringField, PasswordField, SelectField, SubmitField, BooleanField, FloatField, TextAreaField, DateField, TimeField
from wtforms.validators import DataRequired, Email, Length, EqualTo, ValidationError, NumberRange, Optional, Regexp
from models import User, Equipo, TipoEquipo, Marca, EstadoEquipo, Cargo, Cliente, RegistroHoras
from validators import ImageFileValidator

class UserForm(FlaskForm):
    """Formulario para crear/editar usuarios"""
    
    # Información personal
    tipo_documento = SelectField(
        'Tipo de Documento',
        choices=[
            ('CC', 'Cédula de Ciudadanía'),
            ('CE', 'Cédula de Extranjería'),
            ('NIT', 'NIT'),
            ('PP', 'Pasaporte'),
            ('RC', 'Registro Civil'),
            ('TI', 'Tarjeta de Identidad')
        ],
        validators=[DataRequired(message='Seleccione un tipo de documento')]
    )
    
    documento = StringField(
        'Número de Documento',
        validators=[
            DataRequired(message='El documento es requerido'),
            Length(min=5, max=20, message='El documento debe tener entre 5 y 20 caracteres'),
            Regexp(r'^\S+$', message='El documento no puede contener espacios')
        ],
        render_kw={'placeholder': 'Ingrese el número de documento', 'oninput': 'this.value = this.value.replace(/\\s/g, \'\')'}
    )
    
    nombre = StringField(
        'Nombre Completo',
        validators=[
            DataRequired(message='El nombre es requerido'),
            Length(min=2, max=100, message='El nombre debe tener entre 2 y 100 caracteres')
        ],
        render_kw={'placeholder': 'Ingrese el nombre completo'}
    )
    
    email = StringField(
        'Correo Electrónico',
        validators=[
            DataRequired(message='El email es requerido'),
            Email(message='Ingrese un email válido'),
            Length(max=120, message='El email no puede exceder 120 caracteres')
        ],
        render_kw={'placeholder': 'ejemplo@empresa.com'}
    )
    
    celular = StringField(
        'Número de Celular',
        validators=[
            DataRequired(message='El celular es requerido'),
            Length(min=10, max=15, message='El celular debe tener entre 10 y 15 dígitos'),
            Regexp(r'^\S+$', message='El celular no puede contener espacios')
        ],
        render_kw={'placeholder': '3001234567', 'oninput': 'this.value = this.value.replace(/\\s/g, \'\')'}
    )
    
    contrasena = PasswordField(
        'Contraseña',
        validators=[
            DataRequired(message='La contraseña es requerida'),
            Length(min=6, max=50, message='La contraseña debe tener entre 6 y 50 caracteres')
        ],
        render_kw={'placeholder': 'Mínimo 6 caracteres'}
    )
    
    confirmar_contrasena = PasswordField(
        'Confirmar Contraseña',
        validators=[
            DataRequired(message='Confirme la contraseña'),
            EqualTo('contrasena', message='Las contraseñas no coinciden')
        ],
        render_kw={'placeholder': 'Repita la contraseña'}
    )
    
    perfil_usuario = SelectField(
        'Perfil de Usuario',
        choices=[
            ('empleado', 'Empleado'),
            ('administrador', 'Administrador')
        ],
        validators=[DataRequired(message='Seleccione un perfil de usuario')]
    )
    
    estado = SelectField(
        'Estado',
        choices=[
            ('activo', 'Activo'),
            ('inactivo', 'Inactivo'),
            ('suspendido', 'Suspendido')
        ],
        default='activo'
    )
    
    submit = SubmitField('Guardar Usuario')
    
    def validate_documento(self, field):
        """Valida que el documento no esté duplicado"""
        # Para formularios de creación, solo verificar si existe
        user = User.query.filter_by(documento=field.data).first()
        
        if user:
            raise ValidationError('Ya existe un usuario con este número de documento')
    
    def validate_email(self, field):
        """Valida que el email no esté duplicado"""
        # Para formularios de creación, solo verificar si existe
        user = User.query.filter_by(email=field.data).first()
        
        if user:
            raise ValidationError('Ya existe un usuario con este email')

class UserEditForm(UserForm):
    """Formulario para editar usuarios (sin contraseña obligatoria)"""
    
    # Sobrescribir el campo documento para que sea de solo lectura
    documento = StringField(
        'Número de Documento',
        validators=[
            DataRequired(message='El documento es requerido'),
            Length(min=5, max=20, message='El documento debe tener entre 5 y 20 caracteres'),
            Regexp(r'^\S+$', message='El documento no puede contener espacios')
        ],
        render_kw={'placeholder': 'Ingrese el número de documento', 'readonly': True, 'class': 'form-control-plaintext bg-light'}
    )
    
    contrasena = PasswordField(
        'Nueva Contraseña (opcional)',
        validators=[
            Optional(),
            Length(min=6, max=50, message='La contraseña debe tener entre 6 y 50 caracteres')
        ],
        render_kw={'placeholder': 'Deje vacío para mantener la actual'}
    )
    
    confirmar_contrasena = PasswordField(
        'Confirmar Nueva Contraseña',
        validators=[
            Optional()
        ],
        render_kw={'placeholder': 'Repita la nueva contraseña'}
    )
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.id = kwargs.get('id')
    
    def validate_contrasena(self, field):
        """Valida la contraseña solo si se proporciona"""
        if field.data and len(field.data) < 6:
            raise ValidationError('La contraseña debe tener al menos 6 caracteres')
    
    def validate_confirmar_contrasena(self, field):
        """Valida la confirmación solo si se proporciona una contraseña"""
        if self.contrasena.data and not field.data:
            raise ValidationError('Debe confirmar la nueva contraseña')
        elif self.contrasena.data and field.data != self.contrasena.data:
            raise ValidationError('Las contraseñas no coinciden')
    
    def validate_email(self, field):
        """Valida que el email no esté duplicado (excluyendo el usuario actual)"""
        if field.data:
            # Buscar si existe otro usuario con el mismo email (excluyendo el actual)
            user = User.query.filter(
                User.email == field.data,
                User.id != self.id
            ).first()
            
            if user:
                raise ValidationError('Ya existe un usuario con este email')
    
    def validate_documento(self, field):
        """No validar duplicados en edición ya que no se puede modificar"""
        pass

class UserSearchForm(FlaskForm):
    """Formulario para buscar usuarios"""
    
    search = StringField(
        'Buscar',
        render_kw={'placeholder': 'Buscar por nombre, documento o email...'}
    )
    
    perfil_filter = SelectField(
        'Perfil',
        choices=[
            ('', 'Todos los perfiles'),
            ('administrador', 'Administrador'),
            ('empleado', 'Empleado')
        ]
    )
    
    estado_filter = SelectField(
        'Estado',
        choices=[
            ('', 'Todos los estados'),
            ('activo', 'Activo'),
            ('inactivo', 'Inactivo'),
            ('suspendido', 'Suspendido')
        ]
    )
    
    submit = SubmitField('Buscar')

# ===== FORMULARIOS PARA EQUIPOS =====

class EquipoForm(FlaskForm):
    """Formulario para crear/editar equipos"""
    
    # Información básica del equipo
    IdTipoEquipo = SelectField(
        'Tipo de Equipo',
        coerce=int,
        validators=[DataRequired(message='Seleccione un tipo de equipo')],
        render_kw={'placeholder': 'Seleccione el tipo de equipo'}
    )
    
    Placa = StringField(
        'Placa',
        validators=[
            DataRequired(message='La placa es requerida'),
            Length(min=2, max=20, message='La placa debe tener entre 2 y 20 caracteres')
        ],
        render_kw={'placeholder': 'Ingrese la placa del equipo'}
    )
    
    Capacidad = FloatField(
        'Capacidad (Toneladas)',
        validators=[
            DataRequired(message='La capacidad es requerida'),
            NumberRange(min=0.1, max=1000, message='La capacidad debe estar entre 0.1 y 1000 toneladas')
        ],
        render_kw={'placeholder': 'Ej: 25.5', 'step': '0.1'}
    )
    
    IdMarca = SelectField(
        'Marca',
        coerce=int,
        validators=[DataRequired(message='Seleccione una marca')],
        render_kw={'placeholder': 'Seleccione la marca'}
    )
    
    Referencia = StringField(
        'Referencia',
        validators=[
            Length(max=100, message='La referencia no puede exceder 100 caracteres')
        ],
        render_kw={'placeholder': 'Referencia del equipo (opcional)'}
    )
    
    Color = StringField(
        'Color',
        validators=[
            Length(max=50, message='El color no puede exceder 50 caracteres')
        ],
        render_kw={'placeholder': 'Color del equipo (opcional)'}
    )
    
    Modelo = StringField(
        'Modelo',
        validators=[
            Length(max=100, message='El modelo no puede exceder 100 caracteres')
        ],
        render_kw={'placeholder': 'Modelo del equipo (opcional)'}
    )
    
    CentroCostos = StringField(
        'Centro de Costos',
        validators=[
            Length(max=100, message='El centro de costos no puede exceder 100 caracteres')
        ],
        render_kw={'placeholder': 'Centro de costos (opcional)'}
    )
    
    IdEstadoEquipo = SelectField(
        'Estado del Equipo',
        coerce=int,
        validators=[DataRequired(message='Seleccione un estado del equipo')],
        render_kw={'placeholder': 'Seleccione el estado del equipo'}
    )
    
    Estado = SelectField(
        'Estado General',
        choices=[
            ('activo', 'Activo'),
            ('inactivo', 'Inactivo')
        ],
        default='activo'
    )
    
    # Campo para imagen del equipo
    ImagenEquipo = FileField(
        'Imagen del Equipo',
        validators=[
            FileAllowed(['jpg', 'jpeg', 'png', 'gif'], 'Solo se permiten archivos de imagen (JPG, JPEG, PNG, GIF)')
        ],
        render_kw={
            'class': 'form-control', 
            'accept': 'image/*', 
            'onchange': 'previewImage(this, "preview-equipo-imagen")'
        }
    )
    
    # Campo para indicar si el equipo tiene dos motores
    TieneDosMotores = BooleanField(
        'Equipo con Dos Motores',
        render_kw={
            'class': 'form-check-input',
            'id': 'tieneDosMotores'
        }
    )
    
    def validate_TieneDosMotores(self, field):
        """Validar que el campo TieneDosMotores sea un boolean válido"""
        if field.data is not None and not isinstance(field.data, bool):
            raise ValidationError('El valor debe ser verdadero o falso')
    
    submit = SubmitField('Guardar Equipo')
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.id = kwargs.get('id')
        
        # Cargar opciones de las tablas relacionadas
        self.IdTipoEquipo.choices = [(t.IdTipoEquipo, t.descripcion) 
                                    for t in TipoEquipo.query.filter_by(estado='activo').all()]
        self.IdMarca.choices = [(m.IdMarca, m.DescripcionMarca) 
                               for m in Marca.query.filter_by(estado='activo').all()]
        self.IdEstadoEquipo.choices = [(e.IdEstadoEquipo, e.Descripcion) 
                                      for e in EstadoEquipo.query.filter_by(Estado='activo').all()]
    
    def validate_Placa(self, field):
        """Valida que la placa no esté duplicada"""
        if self.id:  # Si es edición
            equipo = Equipo.query.filter(Equipo.Placa == field.data, Equipo.IdEquipo != self.id).first()
        else:  # Si es creación
            equipo = Equipo.query.filter_by(Placa=field.data).first()
        
        if equipo:
            raise ValidationError('Ya existe un equipo con esta placa')
    
    def validate_ImagenEquipo(self, field):
        """Valida la imagen del equipo"""
        if field.data and hasattr(field.data, 'filename'):
            # Validación básica de tamaño de archivo
            if hasattr(field.data, 'content_length') and field.data.content_length:
                max_size = 5 * 1024 * 1024  # 5MB
                if field.data.content_length > max_size:
                    raise ValidationError('La imagen no puede ser mayor a 5MB')
            
            # Validación básica de tipo de archivo
            if field.data.filename:
                allowed_extensions = {'jpg', 'jpeg', 'png', 'gif'}
                file_ext = field.data.filename.rsplit('.', 1)[1].lower() if '.' in field.data.filename else ''
                if file_ext not in allowed_extensions:
                    raise ValidationError('Solo se permiten archivos JPG, JPEG, PNG y GIF')

class EquipoSearchForm(FlaskForm):
    """Formulario para buscar equipos"""
    
    search = StringField(
        'Buscar',
        render_kw={'placeholder': 'Buscar por placa, modelo o referencia...'}
    )
    
    tipo_filter = SelectField(
        'Tipo de Equipo',
        coerce=int,
        choices=[(0, 'Todos los tipos')]
    )
    
    marca_filter = SelectField(
        'Marca',
        coerce=int,
        choices=[(0, 'Todas las marcas')]
    )
    
    estado_filter = SelectField(
        'Estado',
        choices=[
            ('', 'Todos los estados'),
            ('activo', 'Activo'),
            ('inactivo', 'Inactivo')
        ]
    )
    
    estado_equipo_filter = SelectField(
        'Estado del Equipo',
        coerce=int,
        choices=[(0, 'Todos los estados')]
    )
    
    submit = SubmitField('Buscar')
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        
        # Cargar opciones de las tablas relacionadas
        self.tipo_filter.choices = [(0, 'Todos los tipos')] + \
                                  [(t.IdTipoEquipo, t.descripcion) 
                                   for t in TipoEquipo.query.filter_by(estado='activo').all()]
        self.marca_filter.choices = [(0, 'Todas las marcas')] + \
                                   [(m.IdMarca, m.DescripcionMarca) 
                                    for m in Marca.query.filter_by(estado='activo').all()]
        self.estado_equipo_filter.choices = [(0, 'Todos los estados')] + \
                                           [(e.IdEstadoEquipo, e.Descripcion) 
                                            for e in EstadoEquipo.query.filter_by(Estado='activo').all()]

# ===== FORMULARIOS PARA TABLAS MAESTRAS =====

class TipoEquipoForm(FlaskForm):
    """Formulario para tipos de equipos"""
    
    descripcion = StringField(
        'Descripción',
        validators=[
            DataRequired(message='La descripción es requerida'),
            Length(min=2, max=100, message='La descripción debe tener entre 2 y 100 caracteres')
        ],
        render_kw={'placeholder': 'Ej: Grúa Torre, Montacargas, etc.'}
    )
    
    estado = SelectField(
        'Estado',
        choices=[
            ('activo', 'Activo'),
            ('inactivo', 'Inactivo')
        ],
        default='activo'
    )
    
    submit = SubmitField('Guardar Tipo de Equipo')

class MarcaForm(FlaskForm):
    """Formulario para marcas"""
    
    DescripcionMarca = StringField(
        'Descripción de la Marca',
        validators=[
            DataRequired(message='La descripción es requerida'),
            Length(min=2, max=100, message='La descripción debe tener entre 2 y 100 caracteres')
        ],
        render_kw={'placeholder': 'Ej: Caterpillar, Liebherr, etc.'}
    )
    
    estado = SelectField(
        'Estado',
        choices=[
            ('activo', 'Activo'),
            ('inactivo', 'Inactivo')
        ],
        default='activo'
    )
    
    submit = SubmitField('Guardar Marca')

class EstadoEquipoForm(FlaskForm):
    """Formulario para estados de equipos"""
    
    Descripcion = StringField(
        'Descripción',
        validators=[
            DataRequired(message='La descripción es requerida'),
            Length(min=2, max=100, message='La descripción debe tener entre 2 y 100 caracteres')
        ],
        render_kw={'placeholder': 'Ej: Operativo, Mantenimiento, Averiado, etc.'}
    )
    
    Estado = SelectField(
        'Estado',
        choices=[
            ('activo', 'Activo'),
            ('inactivo', 'Inactivo')
        ],
        default='activo'
    )
    
    submit = SubmitField('Guardar Estado de Equipo')

class CargoForm(FlaskForm):
    """Formulario para cargos"""
    
    descripcionCargo = StringField(
        'Descripción del Cargo',
        validators=[
            DataRequired(message='La descripción del cargo es requerida'),
            Length(min=2, max=100, message='La descripción debe tener entre 2 y 100 caracteres')
        ],
        render_kw={'placeholder': 'Ej: Operador de Grúa, Supervisor, Mecánico, etc.'}
    )
    
    Estado = SelectField(
        'Estado',
        choices=[
            ('activo', 'Activo'),
            ('inactivo', 'Inactivo')
        ],
        default='activo'
    )
    
    submit = SubmitField('Guardar Cargo')

class ClienteForm(FlaskForm):
    """Formulario para crear/editar clientes"""
    
    NombreCliente = StringField(
        'Nombre del Cliente',
        validators=[
            DataRequired(message='El nombre del cliente es requerido'),
            Length(min=2, max=200, message='El nombre debe tener entre 2 y 200 caracteres')
        ],
        render_kw={'placeholder': 'Ej: Constructora ABC S.A.S'}
    )
    
    Nit = StringField(
        'NIT',
        validators=[
            DataRequired(message='El NIT es requerido'),
            Length(min=8, max=20, message='El NIT debe tener entre 8 y 20 caracteres')
        ],
        render_kw={'placeholder': 'Ej: 900123456-1'}
    )
    
    Estado = SelectField(
        'Estado',
        choices=[
            ('activo', 'Activo'),
            ('inactivo', 'Inactivo')
        ],
        default='activo'
    )
    
    submit = SubmitField('Guardar Cliente')
    
    def validate_Nit(self, field):
        """Validar que el NIT sea único"""
        cliente = Cliente.query.filter_by(Nit=field.data).first()
        if cliente and (not hasattr(self, 'cliente_id') or cliente.IdCliente != self.cliente_id):
            raise ValidationError('Este NIT ya está registrado')

class ClienteSearchForm(FlaskForm):
    """Formulario de búsqueda de clientes"""
    
    busqueda = StringField(
        'Buscar',
        render_kw={'placeholder': 'Nombre, NIT...'}
    )
    
    estado = SelectField(
        'Estado',
        choices=[
            ('', 'Todos'),
            ('activo', 'Activo'),
            ('inactivo', 'Inactivo')
        ],
        default=''
    )
    
    submit = SubmitField('Buscar')

class RegistroHorasForm(FlaskForm):
    """Formulario para registro de horas de trabajo"""
    
    FechaEmpleado = DateField(
        'Fecha',
        validators=[DataRequired(message='La fecha es requerida')],
        render_kw={'class': 'form-control', 'type': 'date'}
    )
    
    HoraEmpleado = TimeField(
        'Hora',
        validators=[DataRequired(message='La hora es requerida')],
        render_kw={'class': 'form-control', 'type': 'time'}
    )
    
    def validate_FechaEmpleado(self, field):
        """Validar que la fecha no sea futura"""
        from datetime import datetime, date
        
        if field.data:
            fecha_actual = date.today()
            if field.data > fecha_actual:
                raise ValidationError('La fecha no puede ser futura')
    
    def validate_HoraEmpleado(self, field):
        """Validar que la hora sea válida"""
        from datetime import datetime, time
        
        if field.data:
            # Los operarios pueden trabajar a cualquier hora del día (24/7)
            # Solo validamos que sea una hora válida (0-23 horas, 0-59 minutos)
            pass
    
    def validate_fecha_hora_salida(self, fecha_entrada, hora_entrada):
        """Validar que la fecha y hora de salida sean posteriores a la entrada"""
        from datetime import datetime, date, time
        
        if not self.FechaEmpleado.data or not self.HoraEmpleado.data:
            return True
            
        if not fecha_entrada or not hora_entrada:
            return True
            
        # Crear datetime de entrada
        entrada_datetime = datetime.combine(fecha_entrada, hora_entrada)
        
        # Crear datetime de salida
        salida_datetime = datetime.combine(self.FechaEmpleado.data, self.HoraEmpleado.data)
        
        # Validar que la salida sea posterior a la entrada
        if salida_datetime <= entrada_datetime:
            raise ValidationError('La fecha y hora de salida deben ser posteriores a la entrada')
        
        # Validar que no exceda 24 horas de diferencia
        diferencia = salida_datetime - entrada_datetime
        if diferencia.total_seconds() > 24 * 3600:  # 24 horas en segundos
            raise ValidationError('La diferencia entre entrada y salida no puede ser mayor a 24 horas')
        
        return True
    
    IdCargo = SelectField(
        'Cargo',
        coerce=int,
        validators=[DataRequired(message='El cargo es requerido')],
        render_kw={'class': 'form-select'}
    )
    
    Kilometraje = FloatField(
        'Kilometraje',
        validators=[Optional(), NumberRange(min=0, message='El kilometraje debe ser mayor o igual a 0')],
        render_kw={'class': 'form-control', 'step': '0.1', 'placeholder': 'Ej: 1250.5'}
    )
    
    Horometro = FloatField(
        'Horómetro',
        validators=[Optional(), NumberRange(min=0, message='El horómetro debe ser mayor o igual a 0')],
        render_kw={'class': 'form-control', 'step': '0.1', 'placeholder': 'Ej: 2500.5'}
    )
    
    FotoKilometraje = FileField(
        'Foto del Kilometraje',
        validators=[
            Optional(),
            ImageFileValidator(max_size_mb=5)
        ],
        render_kw={'class': 'form-control', 'accept': 'image/*', 'onchange': 'autoCompressOnSelect(this, 5)'}
    )
    
    FotoHorometro = FileField(
        'Foto del Horómetro',
        validators=[
            Optional(),
            ImageFileValidator(max_size_mb=5)
        ],
        render_kw={'class': 'form-control', 'accept': 'image/*', 'onchange': 'autoCompressOnSelect(this, 5)'}
    )
    
    # Campos para el segundo horómetro (solo para equipos con dos motores)
    Horometro2 = FloatField(
        'Horómetro 2',
        validators=[Optional(), NumberRange(min=0, message='El horómetro 2 debe ser mayor o igual a 0')],
        render_kw={'class': 'form-control', 'step': '0.1', 'placeholder': 'Ej: 2500.5', 'style': 'display: none;'}
    )
    
    FotoHorometro2 = FileField(
        'Foto del Horómetro 2',
        validators=[
            Optional(),
            ImageFileValidator(max_size_mb=5)
        ],
        render_kw={'class': 'form-control', 'accept': 'image/*', 'onchange': 'autoCompressOnSelect(this, 5)', 'style': 'display: none;'}
    )
    
    FotoGrua = FileField(
        'Foto de la Grúa',
        validators=[
            Optional(),
            ImageFileValidator(max_size_mb=5)
        ],
        render_kw={'class': 'form-control', 'accept': 'image/*', 'onchange': 'autoCompressOnSelect(this, 5)'}
    )
    
    IdEstadoEquipo = SelectField(
        'Estado del Equipo',
        coerce=int,
        validators=[DataRequired(message='El estado del equipo es requerido')],
        render_kw={'class': 'form-select'}
    )
    
    IdCliente = SelectField(
        'Cliente',
        coerce=lambda x: int(x) if x and x != '' else None,
        validators=[Optional()],
        render_kw={'class': 'form-select'},
        default=None
    )
    
    Observacion = TextAreaField(
        'Observación',
        validators=[Optional(), Length(max=500, message='La observación no puede exceder 500 caracteres')],
        render_kw={'class': 'form-control', 'rows': 3, 'placeholder': 'Observaciones adicionales...'}
    )
    
    Ubicacion = StringField(
        'Ubicación',
        validators=[Optional(), Length(max=255, message='La ubicación no puede exceder 255 caracteres')],
        render_kw={'class': 'form-control', 'readonly': True, 'placeholder': 'Se obtiene automáticamente'}
    )
    
    # Campos ocultos para validaciones
    TipoRegistro = StringField('Tipo de Registro', validators=[DataRequired()])
    IdEquipo = StringField('ID del Equipo', validators=[DataRequired()])
    IdEmpleado = StringField('ID del Empleado', validators=[DataRequired()])
    
    submit = SubmitField('Registrar', render_kw={'class': 'btn btn-primary btn-lg w-100'})
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._setup_choices()
    
    def _setup_choices(self):
        """Configurar las opciones de los select fields"""
        from models import Cargo, EstadoEquipo, Cliente
        
        # Cargos - Solo cargos activos
        cargos = Cargo.query.filter_by(Estado='activo').order_by(Cargo.descripcionCargo).all()
        self.IdCargo.choices = [(cargo.IdCargo, cargo.descripcionCargo) for cargo in cargos]
        
        # Estados de equipos
        estados = EstadoEquipo.query.filter_by(Estado='activo').order_by(EstadoEquipo.Descripcion).all()
        self.IdEstadoEquipo.choices = [(estado.IdEstadoEquipo, estado.Descripcion) for estado in estados]
        
        # Clientes - Incluir todos los clientes (activos e inactivos) para formularios de salida
        clientes_activos = Cliente.query.filter_by(Estado='activo').order_by(Cliente.NombreCliente).all()
        clientes_inactivos = Cliente.query.filter_by(Estado='inactivo').order_by(Cliente.NombreCliente).all()
        
        # Crear opciones con todos los clientes
        opciones_clientes = [(0, 'Seleccionar cliente...')]
        opciones_clientes.extend([(cliente.IdCliente, cliente.NombreCliente) for cliente in clientes_activos])
        opciones_clientes.extend([(cliente.IdCliente, f"{cliente.NombreCliente} (Inactivo)") for cliente in clientes_inactivos])
        
        self.IdCliente.choices = opciones_clientes
    
    def validate_Kilometraje(self, field):
        """Validar kilometraje para operadores con equipo operativo o disponible"""
        if self.IdCargo.data and self.IdEstadoEquipo.data:
            cargo = Cargo.query.get(self.IdCargo.data)
            estado = EstadoEquipo.query.get(self.IdEstadoEquipo.data)
            if (cargo and 'operador' in cargo.descripcionCargo.lower() and 
                estado and ('operativo' in estado.Descripcion.lower() or 'disponible' in estado.Descripcion.lower())):
                if field.data is None or field.data == '':
                    raise ValidationError('El kilometraje es requerido para operadores con equipo operativo o disponible')
        else:
            # Si no hay cargo o estado seleccionado, el campo es opcional
            pass
    
    def validate_Horometro(self, field):
        """Validar horómetro para operadores con equipo operativo o disponible"""
        if self.IdCargo.data and self.IdEstadoEquipo.data:
            cargo = Cargo.query.get(self.IdCargo.data)
            estado = EstadoEquipo.query.get(self.IdEstadoEquipo.data)
            if (cargo and 'operador' in cargo.descripcionCargo.lower() and 
                estado and ('operativo' in estado.Descripcion.lower() or 'disponible' in estado.Descripcion.lower())):
                if field.data is None or field.data == '':
                    raise ValidationError('El horómetro es requerido para operadores con equipo operativo o disponible')
        else:
            # Si no hay cargo o estado seleccionado, el campo es opcional
            pass
    
    def validate_FotoKilometraje(self, field):
        """Validar foto del kilometraje para operadores con equipo operativo o disponible"""
        if self.IdCargo.data and self.IdEstadoEquipo.data:
            cargo = Cargo.query.get(self.IdCargo.data)
            estado = EstadoEquipo.query.get(self.IdEstadoEquipo.data)
            if (cargo and 'operador' in cargo.descripcionCargo.lower() and 
                estado and ('operativo' in estado.Descripcion.lower() or 'disponible' in estado.Descripcion.lower())):
                if not field.data:
                    raise ValidationError('La foto del kilometraje es requerida para operadores con equipo operativo o disponible')
    
    def validate_FotoHorometro(self, field):
        """Validar foto del horómetro para operadores con equipo operativo o disponible"""
        if self.IdCargo.data and self.IdEstadoEquipo.data:
            cargo = Cargo.query.get(self.IdCargo.data)
            estado = EstadoEquipo.query.get(self.IdEstadoEquipo.data)
            if (cargo and 'operador' in cargo.descripcionCargo.lower() and 
                estado and ('operativo' in estado.Descripcion.lower() or 'disponible' in estado.Descripcion.lower())):
                if not field.data:
                    raise ValidationError('La foto del horómetro es requerida para operadores con equipo operativo o disponible')
    
    def validate_Horometro2(self, field):
        """Validar segundo horómetro para operadores con equipo operativo o disponible en equipos con dos motores"""
        if self.IdCargo.data and self.IdEstadoEquipo.data:
            cargo = Cargo.query.get(self.IdCargo.data)
            estado = EstadoEquipo.query.get(self.IdEstadoEquipo.data)
            if (cargo and 'operador' in cargo.descripcionCargo.lower() and 
                estado and ('operativo' in estado.Descripcion.lower() or 'disponible' in estado.Descripcion.lower())):
                # Solo validar si el equipo tiene dos motores
                if self.IdEquipo.data:
                    from models import Equipo
                    equipo = Equipo.query.get(self.IdEquipo.data)
                    if equipo and equipo.TieneDosMotores:
                        if field.data is None or field.data == '':
                            raise ValidationError('El segundo horómetro es requerido para equipos con dos motores')
    
    def validate_FotoHorometro2(self, field):
        """Validar foto del segundo horómetro para operadores con equipo operativo o disponible en equipos con dos motores"""
        if self.IdCargo.data and self.IdEstadoEquipo.data:
            cargo = Cargo.query.get(self.IdCargo.data)
            estado = EstadoEquipo.query.get(self.IdEstadoEquipo.data)
            if (cargo and 'operador' in cargo.descripcionCargo.lower() and 
                estado and ('operativo' in estado.Descripcion.lower() or 'disponible' in estado.Descripcion.lower())):
                # Solo validar si el equipo tiene dos motores
                if self.IdEquipo.data:
                    from models import Equipo
                    equipo = Equipo.query.get(self.IdEquipo.data)
                    if equipo and equipo.TieneDosMotores:
                        if not field.data:
                            raise ValidationError('La foto del segundo horómetro es requerida para equipos con dos motores')
    
    def validate_IdCliente(self, field):
        """Validar cliente según estado del equipo"""
        # Si el campo es de solo lectura, no validar (es un formulario de salida)
        if self.IdCliente.render_kw and self.IdCliente.render_kw.get('readonly'):
            return
        
        # Solo validar si es un registro de entrada
        if self.TipoRegistro.data == 'entrada' and self.IdEstadoEquipo.data:
            estado = EstadoEquipo.query.get(self.IdEstadoEquipo.data)
            if estado and 'operativo' in estado.Descripcion.lower():
                if not field.data or field.data is None:
                    raise ValidationError('El cliente es requerido cuando el equipo está operativo')

class CambiarContrasenaForm(FlaskForm):
    """Formulario para cambiar contraseña"""
    
    contrasena_actual = PasswordField(
        'Contraseña Actual',
        validators=[
            DataRequired(message='La contraseña actual es requerida')
        ],
        render_kw={'placeholder': 'Ingresa tu contraseña actual', 'class': 'form-control'}
    )
    
    nueva_contrasena = PasswordField(
        'Nueva Contraseña',
        validators=[
            DataRequired(message='La nueva contraseña es requerida'),
            Length(min=6, max=100, message='La contraseña debe tener entre 6 y 100 caracteres')
        ],
        render_kw={'placeholder': 'Ingresa tu nueva contraseña', 'class': 'form-control'}
    )
    
    confirmar_contrasena = PasswordField(
        'Confirmar Nueva Contraseña',
        validators=[
            DataRequired(message='La confirmación de contraseña es requerida'),
            EqualTo('nueva_contrasena', message='Las contraseñas no coinciden')
        ],
        render_kw={'placeholder': 'Confirma tu nueva contraseña', 'class': 'form-control'}
    )
    
    submit = SubmitField('Cambiar Contraseña', render_kw={'class': 'btn btn-primary'})
    
    def validate_contrasena_actual(self, field):
        """Validar que la contraseña actual sea correcta"""
        from models import User
        from werkzeug.security import check_password_hash
        from flask import session
        
        if field.data:
            user = User.query.get(session.get('user_id'))
            if user and not check_password_hash(user.contrasena_hash, field.data):
                raise ValidationError('La contraseña actual es incorrecta')
    
    def validate_nueva_contrasena(self, field):
        """Validar que la nueva contraseña sea diferente a la actual"""
        from models import User
        from werkzeug.security import check_password_hash
        from flask import session
        
        if field.data and self.contrasena_actual.data:
            user = User.query.get(session.get('user_id'))
            if user and check_password_hash(user.contrasena_hash, field.data):
                raise ValidationError('La nueva contraseña debe ser diferente a la actual')

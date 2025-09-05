from flask_wtf import FlaskForm
from flask_wtf.file import FileField, FileAllowed
from wtforms import StringField, PasswordField, SelectField, SubmitField, BooleanField, FloatField, TextAreaField, DateField, TimeField
from wtforms.validators import DataRequired, Email, Length, EqualTo, ValidationError, NumberRange, Optional
from models import User, Equipo, TipoEquipo, Marca, EstadoEquipo, Cargo, Cliente, RegistroHoras

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
            Length(min=5, max=20, message='El documento debe tener entre 5 y 20 caracteres')
        ],
        render_kw={'placeholder': 'Ingrese el número de documento'}
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
            Length(min=10, max=15, message='El celular debe tener entre 10 y 15 dígitos')
        ],
        render_kw={'placeholder': '3001234567'}
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
    
    contrasena = PasswordField(
        'Nueva Contraseña (opcional)',
        validators=[
            Length(min=6, max=50, message='La contraseña debe tener entre 6 y 50 caracteres')
        ],
        render_kw={'placeholder': 'Deje vacío para mantener la actual'}
    )
    
    confirmar_contrasena = PasswordField(
        'Confirmar Nueva Contraseña',
        validators=[
            EqualTo('contrasena', message='Las contraseñas no coinciden')
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
        render_kw={'class': 'form-control'}
    )
    
    HoraEmpleado = TimeField(
        'Hora',
        validators=[DataRequired(message='La hora es requerida')],
        render_kw={'class': 'form-control'}
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
            # Validar que no sea una hora muy temprana (antes de las 5 AM)
            if field.data < time(5, 0):
                raise ValidationError('La hora no puede ser antes de las 5:00 AM')
            
            # Validar que no sea una hora muy tarde (después de las 11 PM)
            if field.data > time(23, 0):
                raise ValidationError('La hora no puede ser después de las 11:00 PM')
    
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
            FileAllowed(['jpg', 'jpeg', 'png', 'gif'], 'Solo se permiten imágenes JPG, PNG o GIF')
        ],
        render_kw={'class': 'form-control', 'accept': 'image/*'}
    )
    
    FotoHorometro = FileField(
        'Foto del Horómetro',
        validators=[
            Optional(),
            FileAllowed(['jpg', 'jpeg', 'png', 'gif'], 'Solo se permiten imágenes JPG, PNG o GIF')
        ],
        render_kw={'class': 'form-control', 'accept': 'image/*'}
    )
    
    FotoGrua = FileField(
        'Foto de la Grúa',
        validators=[
            DataRequired(message='La foto de la grúa es requerida'),
            FileAllowed(['jpg', 'jpeg', 'png', 'gif'], 'Solo se permiten imágenes JPG, PNG o GIF')
        ],
        render_kw={'class': 'form-control', 'accept': 'image/*'}
    )
    
    IdEstadoEquipo = SelectField(
        'Estado del Equipo',
        coerce=int,
        validators=[DataRequired(message='El estado del equipo es requerido')],
        render_kw={'class': 'form-select'}
    )
    
    IdCliente = SelectField(
        'Cliente',
        coerce=int,
        validators=[Optional()],
        render_kw={'class': 'form-select'}
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
        
        # Clientes
        clientes = Cliente.query.filter_by(Estado='activo').order_by(Cliente.NombreCliente).all()
        self.IdCliente.choices = [(0, 'Seleccionar cliente...')] + [(cliente.IdCliente, cliente.NombreCliente) for cliente in clientes]
    
    def validate_Kilometraje(self, field):
        """Validar kilometraje para operadores"""
        if self.IdCargo.data:
            cargo = Cargo.query.get(self.IdCargo.data)
            if cargo and 'operador' in cargo.descripcionCargo.lower():
                if field.data is None or field.data == '':
                    raise ValidationError('El kilometraje es requerido para operadores')
        else:
            # Si no hay cargo seleccionado, el campo es opcional
            pass
    
    def validate_Horometro(self, field):
        """Validar horómetro para operadores"""
        if self.IdCargo.data:
            cargo = Cargo.query.get(self.IdCargo.data)
            if cargo and 'operador' in cargo.descripcionCargo.lower():
                if field.data is None or field.data == '':
                    raise ValidationError('El horómetro es requerido para operadores')
        else:
            # Si no hay cargo seleccionado, el campo es opcional
            pass
    
    def validate_FotoKilometraje(self, field):
        """Validar foto del kilometraje para operadores"""
        if self.IdCargo.data:
            cargo = Cargo.query.get(self.IdCargo.data)
            if cargo and 'operador' in cargo.descripcionCargo.lower():
                if not field.data:
                    raise ValidationError('La foto del kilometraje es requerida para operadores')
    
    def validate_FotoHorometro(self, field):
        """Validar foto del horómetro para operadores"""
        if self.IdCargo.data:
            cargo = Cargo.query.get(self.IdCargo.data)
            if cargo and 'operador' in cargo.descripcionCargo.lower():
                if not field.data:
                    raise ValidationError('La foto del horómetro es requerida para operadores')
    
    def validate_IdCliente(self, field):
        """Validar cliente según estado del equipo"""
        if self.IdEstadoEquipo.data:
            estado = EstadoEquipo.query.get(self.IdEstadoEquipo.data)
            if estado and 'operativo' in estado.Descripcion.lower():
                # Solo validar si el campo no es de solo lectura
                if not hasattr(self, 'IdCliente') or not (self.IdCliente.render_kw and self.IdCliente.render_kw.get('readonly')):
                    if not field.data or field.data == 0:
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
            if user and not check_password_hash(user.contrasena, field.data):
                raise ValidationError('La contraseña actual es incorrecta')
    
    def validate_nueva_contrasena(self, field):
        """Validar que la nueva contraseña sea diferente a la actual"""
        from models import User
        from werkzeug.security import check_password_hash
        from flask import session
        
        if field.data and self.contrasena_actual.data:
            user = User.query.get(session.get('user_id'))
            if user and check_password_hash(user.contrasena, field.data):
                raise ValidationError('La nueva contraseña debe ser diferente a la actual')

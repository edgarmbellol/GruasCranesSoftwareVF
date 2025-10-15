"""
Validadores personalizados para el sistema de grúas
"""

from flask_wtf.file import FileAllowed
from wtforms.validators import ValidationError
import os

class FileSizeLimit:
    """
    Validador para limitar el tamaño de archivos
    """
    
    def __init__(self, max_size_mb=5, message=None):
        self.max_size_mb = max_size_mb
        self.max_size_bytes = max_size_mb * 1024 * 1024
        
        if message is None:
            message = f'El archivo no puede ser mayor a {max_size_mb}MB'
        self.message = message
    
    def __call__(self, form, field):
        if field.data:
            file = field.data
            if hasattr(file, 'content_length'):
                file_size = file.content_length
            elif hasattr(file, 'size'):
                file_size = file.size
            else:
                # Si no podemos determinar el tamaño, usar el archivo temporal
                try:
                    file_size = os.path.getsize(file.filename)
                except (OSError, AttributeError):
                    return  # No podemos validar el tamaño
            
            if file_size > self.max_size_bytes:
                raise ValidationError(self.message)

class ImageFileValidator:
    """
    Validador combinado para archivos de imagen
    """
    
    def __init__(self, max_size_mb=5, allowed_extensions=None):
        if allowed_extensions is None:
            allowed_extensions = ['jpg', 'jpeg', 'png', 'gif']
        
        self.file_allowed = FileAllowed(allowed_extensions, 
                                      f'Solo se permiten imágenes {", ".join(allowed_extensions).upper()}')
        self.file_size = FileSizeLimit(max_size_mb, 
                                     f'La imagen no puede ser mayor a {max_size_mb}MB')
    
    def __call__(self, form, field):
        # Validar tipo de archivo
        self.file_allowed(form, field)
        
        # Validar tamaño de archivo
        self.file_size(form, field)

def validate_image_size(file_data, max_size_mb=5):
    """
    Función auxiliar para validar el tamaño de una imagen
    """
    if not file_data:
        return True
    
    try:
        if hasattr(file_data, 'content_length'):
            file_size = file_data.content_length
        elif hasattr(file_data, 'size'):
            file_size = file_data.size
        else:
            file_size = os.path.getsize(file_data.filename)
        
        max_size_bytes = max_size_mb * 1024 * 1024
        return file_size <= max_size_bytes
    
    except (OSError, AttributeError):
        return True  # Si no podemos validar, permitir

def get_file_size_mb(file_data):
    """
    Obtiene el tamaño de un archivo en MB
    """
    if not file_data:
        return 0
    
    try:
        if hasattr(file_data, 'content_length'):
            file_size = file_data.content_length
        elif hasattr(file_data, 'size'):
            file_size = file_data.size
        else:
            file_size = os.path.getsize(file_data.filename)
        
        return file_size / (1024 * 1024)
    
    except (OSError, AttributeError):
        return 0



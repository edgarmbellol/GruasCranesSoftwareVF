"""
Módulo para procesamiento de imágenes en el sistema de grúas
Incluye funciones para comprimir, validar y optimizar imágenes
"""

import os
import math
from PIL import Image, ExifTags
import logging

# Configurar logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def validate_image_dimensions(image_path, min_width=100, min_height=100):
    """
    Valida las dimensiones mínimas de una imagen
    
    Args:
        image_path (str): Ruta de la imagen
        min_width (int): Ancho mínimo requerido
        min_height (int): Alto mínimo requerido
    
    Returns:
        tuple: (is_valid, width, height, error_message)
    """
    try:
        with Image.open(image_path) as img:
            width, height = img.size
            
            if width < min_width or height < min_height:
                error_msg = f"La imagen debe ser al menos {min_width}x{min_height}px. Actual: {width}x{height}px"
                return False, width, height, error_msg
            
            return True, width, height, None
            
    except Exception as e:
        error_msg = f"Error al validar imagen: {str(e)}"
        logger.error(error_msg)
        return False, 0, 0, error_msg

def get_file_size_mb(file_path):
    """Obtiene el tamaño de un archivo en MB"""
    try:
        size_bytes = os.path.getsize(file_path)
        size_mb = size_bytes / (1024 * 1024)
        return size_mb
    except Exception:
        return 0

def compress_image_server(image_path, max_width=1920, max_height=1080, quality=80, max_size_mb=5):
    """
    Comprime una imagen optimizando tamaño y calidad
    
    Args:
        image_path (str): Ruta de la imagen original
        max_width (int): Ancho máximo permitido
        max_height (int): Alto máximo permitido
        quality (int): Calidad de compresión (1-100)
        max_size_mb (float): Tamaño máximo en MB
    
    Returns:
        tuple: (success, compressed_path, compression_info)
    """
    try:
        # Verificar que el archivo existe
        if not os.path.exists(image_path):
            return False, None, {"error": "Archivo no encontrado"}
        
        # Obtener tamaño original
        original_size_mb = get_file_size_mb(image_path)
        
        # Si la imagen ya es pequeña, no comprimir
        if original_size_mb <= max_size_mb:
            logger.info(f"Imagen ya optimizada: {original_size_mb:.2f}MB")
            return True, image_path, {
                "original_size_mb": original_size_mb,
                "compressed_size_mb": original_size_mb,
                "compression_ratio": 0,
                "message": "No se requirió compresión"
            }
        
        # Crear ruta para imagen comprimida
        base_name = os.path.splitext(image_path)[0]
        compressed_path = f"{base_name}_compressed.jpg"
        
        # Abrir y procesar imagen
        with Image.open(image_path) as img:
            # Convertir a RGB si es necesario (para JPEG)
            if img.mode in ('RGBA', 'LA', 'P'):
                # Crear fondo blanco para imágenes con transparencia
                background = Image.new('RGB', img.size, (255, 255, 255))
                if img.mode == 'P':
                    img = img.convert('RGBA')
                background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                img = background
            elif img.mode != 'RGB':
                img = img.convert('RGB')
            
            # Obtener dimensiones originales
            original_width, original_height = img.size
            
            # Calcular nuevas dimensiones manteniendo aspect ratio
            ratio = min(max_width / original_width, max_height / original_height)
            
            if ratio < 1:  # Solo redimensionar si es necesario
                new_width = int(original_width * ratio)
                new_height = int(original_height * ratio)
                img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
                logger.info(f"Imagen redimensionada: {original_width}x{original_height} → {new_width}x{new_height}")
            
            # Guardar imagen comprimida
            img.save(compressed_path, 'JPEG', quality=quality, optimize=True)
            
            # Obtener tamaño comprimido
            compressed_size_mb = get_file_size_mb(compressed_path)
            compression_ratio = ((original_size_mb - compressed_size_mb) / original_size_mb) * 100
            
            # Si aún es muy grande, reducir calidad progresivamente
            if compressed_size_mb > max_size_mb:
                for quality_reduced in [70, 60, 50, 40, 30]:
                    img.save(compressed_path, 'JPEG', quality=quality_reduced, optimize=True)
                    compressed_size_mb = get_file_size_mb(compressed_path)
                    compression_ratio = ((original_size_mb - compressed_size_mb) / original_size_mb) * 100
                    
                    if compressed_size_mb <= max_size_mb:
                        logger.info(f"Compresión exitosa con calidad {quality_reduced}%")
                        break
            
            # Reemplazar archivo original con el comprimido
            if os.path.exists(compressed_path):
                os.replace(compressed_path, image_path)
                final_path = image_path
            else:
                final_path = compressed_path
            
            # Información de compresión
            compression_info = {
                "original_size_mb": round(original_size_mb, 2),
                "compressed_size_mb": round(compressed_size_mb, 2),
                "compression_ratio": round(compression_ratio, 1),
                "original_dimensions": f"{original_width}x{original_height}",
                "final_dimensions": f"{img.size[0]}x{img.size[1]}",
                "final_quality": quality_reduced if compressed_size_mb > max_size_mb else quality,
                "success": True
            }
            
            logger.info(f"✅ Compresión exitosa: {original_size_mb:.2f}MB → {compressed_size_mb:.2f}MB (-{compression_ratio:.1f}%)")
            
            return True, final_path, compression_info
            
    except Exception as e:
        error_msg = f"Error al comprimir imagen: {str(e)}"
        logger.error(error_msg)
        return False, None, {"error": error_msg}

def validate_image_file(file_data, max_size_mb=5):
    """
    Valida un archivo de imagen antes del procesamiento
    
    Args:
        file_data: Datos del archivo subido
        max_size_mb (float): Tamaño máximo permitido en MB
    
    Returns:
        tuple: (is_valid, error_message)
    """
    try:
        # Verificar que hay datos de archivo
        if not file_data or not hasattr(file_data, 'filename'):
            return False, "No se proporcionó archivo"
        
        # Verificar extensión
        if not file_data.filename:
            return False, "Nombre de archivo inválido"
        
        allowed_extensions = {'.jpg', '.jpeg', '.png', '.gif', '.bmp'}
        file_ext = os.path.splitext(file_data.filename)[1].lower()
        
        if file_ext not in allowed_extensions:
            return False, f"Tipo de archivo no permitido. Use: {', '.join(allowed_extensions)}"
        
        # Verificar tamaño
        if hasattr(file_data, 'content_length') and file_data.content_length:
            file_size_mb = file_data.content_length / (1024 * 1024)
            if file_size_mb > max_size_mb:
                return False, f"Archivo demasiado grande. Máximo: {max_size_mb}MB"
        
        return True, None
        
    except Exception as e:
        return False, f"Error al validar archivo: {str(e)}"

def get_image_info(image_path):
    """
    Obtiene información detallada de una imagen
    
    Args:
        image_path (str): Ruta de la imagen
    
    Returns:
        dict: Información de la imagen
    """
    try:
        with Image.open(image_path) as img:
            info = {
                "width": img.size[0],
                "height": img.size[1],
                "mode": img.mode,
                "format": img.format,
                "size_mb": round(get_file_size_mb(image_path), 2),
                "filename": os.path.basename(image_path)
            }
            
            # Obtener metadatos EXIF si están disponibles
            if hasattr(img, '_getexif') and img._getexif():
                exif = img._getexif()
                info["has_exif"] = True
                # Agregar información EXIF relevante
                for tag_id, value in exif.items():
                    tag = ExifTags.TAGS.get(tag_id, tag_id)
                    if tag in ['DateTime', 'Make', 'Model']:
                        info[f"exif_{tag.lower()}"] = value
            else:
                info["has_exif"] = False
            
            return info
            
    except Exception as e:
        logger.error(f"Error al obtener información de imagen: {str(e)}")
        return {"error": str(e)}

def cleanup_temp_files(directory, pattern="*_compressed.*"):
    """
    Limpia archivos temporales de compresión
    
    Args:
        directory (str): Directorio a limpiar
        pattern (str): Patrón de archivos a eliminar
    """
    try:
        import glob
        temp_files = glob.glob(os.path.join(directory, pattern))
        for temp_file in temp_files:
            if os.path.exists(temp_file):
                os.remove(temp_file)
                logger.info(f"Archivo temporal eliminado: {temp_file}")
    except Exception as e:
        logger.error(f"Error al limpiar archivos temporales: {str(e)}")



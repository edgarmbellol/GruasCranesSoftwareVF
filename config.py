import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    """Configuración base"""
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'clave-desarrollo-no-usar-en-produccion'
    DEBUG = os.environ.get('FLASK_DEBUG', 'False').lower() == 'true'
    
class ProductionConfig(Config):
    """Configuración para producción"""
    DEBUG = False
    
class DevelopmentConfig(Config):
    """Configuración para desarrollo"""
    DEBUG = True

config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'default': DevelopmentConfig
}

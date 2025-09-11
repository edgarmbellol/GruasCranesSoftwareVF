import os
from dotenv import load_dotenv
from urllib.parse import quote_plus

load_dotenv()

class Config:
    """Configuración base"""
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'clave-desarrollo-no-usar-en-produccion'
    DEBUG = os.environ.get('FLASK_DEBUG', 'False').lower() == 'true'
    
    # Configuración de zona horaria
    TIMEZONE = 'America/Bogota'  # Zona horaria de Colombia
    
    # Configuración PostgreSQL
    DB_HOST = os.environ.get('DB_HOST') or 'localhost'
    DB_PORT = os.environ.get('DB_PORT') or '5432'
    DB_NAME = os.environ.get('DB_NAME') or 'gruas_db'
    DB_USER = os.environ.get('DB_USER') or 'gruas_user'
    DB_PASSWORD = os.environ.get('DB_PASSWORD') or 'gruas_password'
    
    # Construir URL de conexión
    SQLALCHEMY_DATABASE_URI = f"postgresql://{DB_USER}:{quote_plus(DB_PASSWORD)}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    
    # Configuraciones de rendimiento
    SQLALCHEMY_ENGINE_OPTIONS = {
        'pool_size': 20,           # Número de conexiones en el pool
        'max_overflow': 30,        # Conexiones adicionales permitidas
        'pool_timeout': 30,        # Tiempo de espera para conexión
        'pool_recycle': 3600,      # Reciclar conexiones cada hora
        'pool_pre_ping': True,     # Verificar conexiones antes de usar
        'echo': False              # Cambiar a True para debug de SQL
    }
    
class ProductionConfig(Config):
    """Configuración para producción"""
    DEBUG = False
    # Configuraciones adicionales de seguridad
    SQLALCHEMY_ENGINE_OPTIONS = {
        **Config.SQLALCHEMY_ENGINE_OPTIONS,
        'pool_size': 30,
        'max_overflow': 50
    }
    
class DevelopmentConfig(Config):
    """Configuración para desarrollo"""
    DEBUG = True
    # Mostrar SQL en desarrollo
    SQLALCHEMY_ENGINE_OPTIONS = {
        **Config.SQLALCHEMY_ENGINE_OPTIONS,
        'echo': True
    }

config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'default': DevelopmentConfig
}

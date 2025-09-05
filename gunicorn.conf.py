# Configuración de Gunicorn para producción
import multiprocessing
import os

# Configuración del servidor
bind = f"0.0.0.0:{os.environ.get('PORT', 5000)}"
workers = multiprocessing.cpu_count() * 2 + 1
worker_class = "sync"
worker_connections = 1000
timeout = 30
keepalive = 2

# Configuración de logging
accesslog = "-"
errorlog = "-"
loglevel = "info"
access_log_format = '%(h)s %(l)s %(u)s %(t)s "%(r)s" %(s)s %(b)s "%(f)s" "%(a)s"'

# Configuración de seguridad
limit_request_line = 4094
limit_request_fields = 100
limit_request_field_size = 8190

# Configuración de rendimiento
max_requests = 1000
max_requests_jitter = 50
preload_app = True

# Configuración de procesos
user = None
group = None
tmp_upload_dir = None

# Configuración de SSL (descomentar si usas HTTPS)
# keyfile = "/path/to/keyfile"
# certfile = "/path/to/certfile"

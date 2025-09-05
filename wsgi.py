"""
WSGI entry point para despliegue en producción
Compatible con Gunicorn, uWSGI y otros servidores WSGI
"""

from app import app

if __name__ == "__main__":
    app.run()

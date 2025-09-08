#!/usr/bin/env python3
"""
WSGI entry point para producción
"""
import os
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()

from app import app

if __name__ == "__main__":
    app.run()
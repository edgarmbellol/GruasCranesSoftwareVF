#!/usr/bin/env python3
"""
Script de inicio para la aplicación Flask
Configurado para desarrollo y producción
"""

import os
from app import app

if __name__ == '__main__':
    # Configuración para desarrollo
    debug_mode = os.environ.get('FLASK_DEBUG', 'True').lower() == 'true'
    host = os.environ.get('FLASK_HOST', '0.0.0.0')
    port = int(os.environ.get('FLASK_PORT', 5000))
    
    print("=" * 50)
    print("🚀 SISTEMA DE GESTIÓN DE GRÚAS")
    print("=" * 50)
    print(f"🌐 Servidor: http://{host}:{port}")
    print(f"🔧 Modo Debug: {'Activado' if debug_mode else 'Desactivado'}")
    print(f"📱 Responsive: Optimizado para móviles")
    print("=" * 50)
    
    app.run(
        host=host,
        port=port,
        debug=debug_mode,
        threaded=True
    )

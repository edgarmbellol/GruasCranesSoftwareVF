#!/usr/bin/env python3
"""
Script para regenerar todos los códigos QR usando la función de la aplicación
"""

import os
import sys
import requests

def regenerar_qr_via_api():
    """Regenera QR usando la API de la aplicación"""
    try:
        # URL del endpoint de regeneración
        url = "https://gestor.gruascranes.com/regenerar-qr"
        
        print(f"🚀 Regenerando códigos QR via API...")
        print(f"🔗 URL: {url}")
        
        # Hacer petición GET al endpoint
        response = requests.get(url, timeout=30)
        
        if response.status_code == 200:
            print("✅ Códigos QR regenerados exitosamente")
            print(f"📄 Respuesta: {response.text[:200]}...")
            return True
        else:
            print(f"❌ Error en la respuesta: {response.status_code}")
            print(f"📄 Respuesta: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Error haciendo petición: {str(e)}")
        return False

if __name__ == "__main__":
    print("🚀 Iniciando regeneración de códigos QR...")
    success = regenerar_qr_via_api()
    if success:
        print("🎉 ¡Regeneración completada!")
    else:
        print("❌ Error en la regeneración")


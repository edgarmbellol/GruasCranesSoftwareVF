#!/usr/bin/env python3
"""
Script para subir cambios y regenerar códigos QR en VPS
GRÚAS CRANES S.A.S
"""

import os
import sys
import subprocess
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()

def subir_cambios():
    """Subir cambios al repositorio"""
    print("📤 SUBIENDO CAMBIOS AL REPOSITORIO...")
    print("=" * 50)
    
    try:
        # Agregar archivos modificados
        subprocess.run(['git', 'add', '.'], check=True)
        print("✅ Archivos agregados al staging")
        
        # Hacer commit
        commit_message = "Fix: Corregir error JavaScript y regenerar códigos QR"
        subprocess.run(['git', 'commit', '-m', commit_message], check=True)
        print("✅ Commit realizado")
        
        # Subir al repositorio
        subprocess.run(['git', 'push', 'origin', 'main'], check=True)
        print("✅ Cambios subidos al repositorio")
        
        return True
        
    except subprocess.CalledProcessError as e:
        print(f"❌ Error en git: {e}")
        return False
    except Exception as e:
        print(f"❌ Error inesperado: {e}")
        return False

def regenerar_qr_local():
    """Regenerar códigos QR localmente"""
    print("\n🔧 REGENERANDO CÓDIGOS QR LOCALMENTE...")
    print("=" * 50)
    
    try:
        # Agregar el directorio actual al path
        sys.path.append(os.path.dirname(os.path.abspath(__file__)))
        
        from app import app, db, Equipo, generar_qr_equipo
        
        with app.app_context():
            # Verificar BASE_URL
            base_url = os.environ.get('BASE_URL', 'http://localhost:5000')
            print(f"✅ BASE_URL: {base_url}")
            
            # Obtener equipos activos
            equipos = Equipo.query.filter_by(Estado='activo').all()
            print(f"📋 Equipos activos: {len(equipos)}")
            
            if not equipos:
                print("❌ No hay equipos activos")
                return False
            
            # Crear directorio QR si no existe
            qr_dir = os.path.join(app.static_folder, 'qr_codes')
            os.makedirs(qr_dir, exist_ok=True)
            print(f"📁 Directorio QR: {qr_dir}")
            
            # Regenerar QR para cada equipo
            exitosos = 0
            errores = 0
            
            for equipo in equipos:
                print(f"🔄 Generando QR para {equipo.Placa}...")
                
                try:
                    qr_path = generar_qr_equipo(equipo.IdEquipo, equipo.Placa)
                    if qr_path:
                        print(f"   ✅ QR generado: {qr_path}")
                        exitosos += 1
                    else:
                        print(f"   ❌ Error generando QR")
                        errores += 1
                except Exception as e:
                    print(f"   ❌ Error: {str(e)}")
                    errores += 1
            
            # Resumen
            print(f"\n📊 RESUMEN LOCAL:")
            print(f"   ✅ Exitosos: {exitosos}")
            print(f"   ❌ Errores: {errores}")
            
            return exitosos > 0
            
    except Exception as e:
        print(f"❌ Error regenerando QR localmente: {e}")
        return False

def instrucciones_vps():
    """Mostrar instrucciones para VPS"""
    print("\n🚀 INSTRUCCIONES PARA VPS:")
    print("=" * 50)
    print("1. Conectarse a tu VPS:")
    print("   ssh usuario@tu-servidor.com")
    print()
    print("2. Navegar al proyecto:")
    print("   cd /ruta/a/tu/proyecto/gruas")
    print()
    print("3. Actualizar código:")
    print("   git pull origin main")
    print()
    print("4. Activar entorno virtual:")
    print("   source venv/bin/activate")
    print()
    print("5. Regenerar códigos QR:")
    print("   python regenerar_qr_vps_simple.py")
    print()
    print("6. Reiniciar aplicación:")
    print("   sudo systemctl restart gruas-cranes")
    print()
    print("7. Verificar:")
    print("   https://gestor.gruascranes.com/qr-equipos")

def main():
    print("🚀 GRÚAS CRANES S.A.S - SUBIR Y REGENERAR QR")
    print("=" * 60)
    
    # 1. Regenerar QR localmente
    if regenerar_qr_local():
        print("\n✅ Códigos QR regenerados localmente")
    else:
        print("\n❌ Error regenerando códigos QR localmente")
        return False
    
    # 2. Subir cambios
    if subir_cambios():
        print("\n✅ Cambios subidos al repositorio")
    else:
        print("\n❌ Error subiendo cambios")
        return False
    
    # 3. Mostrar instrucciones para VPS
    instrucciones_vps()
    
    print("\n🎉 ¡Proceso completado!")
    print("💡 Sigue las instrucciones de VPS para completar la actualización")
    
    return True

if __name__ == "__main__":
    if main():
        print("\n✅ Script ejecutado exitosamente")
        sys.exit(0)
    else:
        print("\n❌ Script falló")
        sys.exit(1)

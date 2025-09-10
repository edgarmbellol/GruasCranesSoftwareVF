#!/usr/bin/env python3
"""
Script de diagnóstico para códigos QR en VPS
GRÚAS CRANES S.A.S
"""

import os
import sys
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()

# Agregar el directorio actual al path para importar módulos
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app import app, db, Equipo, generar_qr_equipo

def diagnosticar_qr():
    """Diagnostica el estado de los códigos QR"""
    
    with app.app_context():
        print("🔍 DIAGNÓSTICO DE CÓDIGOS QR - GRÚAS CRANES S.A.S")
        print("=" * 60)
        
        # 1. Verificar configuración
        print("\n📋 1. CONFIGURACIÓN:")
        base_url = os.environ.get('BASE_URL')
        print(f"   BASE_URL: {base_url}")
        
        if not base_url:
            print("   ❌ ERROR: BASE_URL no configurada")
            print("   💡 Solución: Configura BASE_URL en tu archivo .env")
            return False
        else:
            print("   ✅ BASE_URL configurada correctamente")
        
        # 2. Verificar directorio QR
        print("\n📁 2. DIRECTORIO QR:")
        qr_dir = os.path.join(app.static_folder, 'qr_codes')
        print(f"   Directorio: {qr_dir}")
        
        if not os.path.exists(qr_dir):
            print("   ❌ ERROR: Directorio QR no existe")
            print("   💡 Solución: El directorio se creará automáticamente")
            os.makedirs(qr_dir, exist_ok=True)
            print("   ✅ Directorio QR creado")
        else:
            print("   ✅ Directorio QR existe")
        
        # 3. Verificar equipos
        print("\n🏗️ 3. EQUIPOS:")
        equipos = Equipo.query.filter_by(Estado='activo').all()
        print(f"   Equipos activos: {len(equipos)}")
        
        if not equipos:
            print("   ❌ ERROR: No hay equipos activos")
            return False
        
        # 4. Verificar códigos QR existentes
        print("\n🔍 4. CÓDIGOS QR EXISTENTES:")
        qr_existentes = 0
        qr_faltantes = 0
        
        for equipo in equipos:
            qr_filename = f"qr_equipo_{equipo.IdEquipo}_{equipo.Placa}.png"
            qr_path = os.path.join(qr_dir, qr_filename)
            
            if os.path.exists(qr_path):
                qr_existentes += 1
                print(f"   ✅ {equipo.Placa}: QR existe")
            else:
                qr_faltantes += 1
                print(f"   ❌ {equipo.Placa}: QR faltante")
        
        print(f"\n   Resumen: {qr_existentes} existentes, {qr_faltantes} faltantes")
        
        # 5. Generar códigos QR faltantes
        if qr_faltantes > 0:
            print(f"\n🔧 5. GENERANDO CÓDIGOS QR FALTANTES:")
            
            exitosos = 0
            errores = 0
            
            for equipo in equipos:
                qr_filename = f"qr_equipo_{equipo.IdEquipo}_{equipo.Placa}.png"
                qr_path = os.path.join(qr_dir, qr_filename)
                
                if not os.path.exists(qr_path):
                    print(f"   🔄 Generando QR para {equipo.Placa}...")
                    
                    try:
                        qr_path_relativo = generar_qr_equipo(equipo.IdEquipo, equipo.Placa)
                        if qr_path_relativo:
                            print(f"   ✅ QR generado: {qr_path_relativo}")
                            exitosos += 1
                        else:
                            print(f"   ❌ Error generando QR para {equipo.Placa}")
                            errores += 1
                    except Exception as e:
                        print(f"   ❌ Error generando QR para {equipo.Placa}: {str(e)}")
                        errores += 1
        
        # 6. Verificar permisos
        print("\n🔐 6. PERMISOS:")
        if os.path.exists(qr_dir):
            try:
                # Intentar crear un archivo de prueba
                test_file = os.path.join(qr_dir, 'test.txt')
                with open(test_file, 'w') as f:
                    f.write('test')
                os.remove(test_file)
                print("   ✅ Permisos de escritura correctos")
            except Exception as e:
                print(f"   ❌ ERROR de permisos: {str(e)}")
                print("   💡 Solución: Verificar permisos del directorio static/qr_codes")
                return False
        
        # 7. Verificar acceso web
        print("\n🌐 7. ACCESO WEB:")
        print(f"   URL base: {base_url}")
        print(f"   Ruta QR: {base_url}/static/qr_codes/")
        
        # 8. Resumen final
        print("\n📊 RESUMEN FINAL:")
        if qr_faltantes == 0 or exitosos > 0:
            print("   ✅ Diagnóstico completado exitosamente")
            print("   💡 Los códigos QR deberían estar disponibles ahora")
            print(f"   🔗 Accede a: {base_url}/qr-equipos")
            return True
        else:
            print("   ❌ Diagnóstico completado con errores")
            print("   💡 Revisa los errores anteriores")
            return False

if __name__ == "__main__":
    if diagnosticar_qr():
        print("\n🎉 ¡Diagnóstico exitoso! Los códigos QR deberían funcionar ahora.")
        sys.exit(0)
    else:
        print("\n❌ Diagnóstico falló. Revisa los errores anteriores.")
        sys.exit(1)

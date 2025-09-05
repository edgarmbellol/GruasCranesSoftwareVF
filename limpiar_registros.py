#!/usr/bin/env python3
"""
Script para limpiar todos los registros de horas
Útil para resetear datos de prueba o limpiar la base de datos
"""

from app import app, db
from models import RegistroHoras
import os

def limpiar_registros_horas():
    """Eliminar todos los registros de horas de la base de datos"""
    with app.app_context():
        print("🧹 Iniciando limpieza de registros de horas...")
        
        # Contar registros antes de eliminar
        total_registros = RegistroHoras.query.count()
        print(f"📊 Total de registros encontrados: {total_registros}")
        
        if total_registros == 0:
            print("✅ No hay registros de horas para eliminar")
            return
        
        # Confirmar la acción
        print("\n⚠️  ADVERTENCIA: Esta acción eliminará TODOS los registros de horas")
        print("   - Entradas y salidas de empleados")
        print("   - Historial de trabajo en equipos")
        print("   - Datos de horómetro y kilometraje")
        print("   - Fotos adjuntas")
        
        respuesta = input("\n¿Estás seguro de que quieres continuar? (escribe 'SI' para confirmar): ")
        
        if respuesta.upper() != 'SI':
            print("❌ Operación cancelada")
            return
        
        # Eliminar archivos de fotos primero
        print("\n🗑️  Eliminando archivos de fotos...")
        registros = RegistroHoras.query.all()
        fotos_eliminadas = 0
        
        for registro in registros:
            # Eliminar foto de kilometraje
            if registro.FotoKilometraje:
                foto_path = os.path.join('static/uploads', registro.FotoKilometraje)
                if os.path.exists(foto_path):
                    try:
                        os.remove(foto_path)
                        fotos_eliminadas += 1
                    except Exception as e:
                        print(f"⚠️  No se pudo eliminar {foto_path}: {e}")
            
            # Eliminar foto de horómetro
            if registro.FotoHorometro:
                foto_path = os.path.join('static/uploads', registro.FotoHorometro)
                if os.path.exists(foto_path):
                    try:
                        os.remove(foto_path)
                        fotos_eliminadas += 1
                    except Exception as e:
                        print(f"⚠️  No se pudo eliminar {foto_path}: {e}")
            
            # Eliminar foto de grúa
            if registro.FotoGrua:
                foto_path = os.path.join('static/uploads', registro.FotoGrua)
                if os.path.exists(foto_path):
                    try:
                        os.remove(foto_path)
                        fotos_eliminadas += 1
                    except Exception as e:
                        print(f"⚠️  No se pudo eliminar {foto_path}: {e}")
        
        print(f"📸 Fotos eliminadas: {fotos_eliminadas}")
        
        # Eliminar registros de la base de datos
        print("\n🗑️  Eliminando registros de la base de datos...")
        try:
            # Eliminar todos los registros
            RegistroHoras.query.delete()
            db.session.commit()
            print("✅ Registros eliminados exitosamente")
        except Exception as e:
            db.session.rollback()
            print(f"❌ Error al eliminar registros: {e}")
            return
        
        # Verificar que se eliminaron todos
        registros_restantes = RegistroHoras.query.count()
        print(f"📊 Registros restantes: {registros_restantes}")
        
        if registros_restantes == 0:
            print("🎉 ¡Limpieza completada exitosamente!")
            print("   - Todos los registros de horas han sido eliminados")
            print("   - Las fotos adjuntas han sido eliminadas")
            print("   - La base de datos está limpia")
        else:
            print("⚠️  Algunos registros no se pudieron eliminar")

def limpiar_registros_por_fecha(fecha_inicio, fecha_fin):
    """Eliminar registros de horas en un rango de fechas específico"""
    from datetime import datetime
    
    with app.app_context():
        print(f"🧹 Limpiando registros entre {fecha_inicio} y {fecha_fin}...")
        
        # Convertir strings a fechas
        try:
            fecha_ini = datetime.strptime(fecha_inicio, '%Y-%m-%d').date()
            fecha_fin = datetime.strptime(fecha_fin, '%Y-%m-%d').date()
        except ValueError:
            print("❌ Formato de fecha inválido. Use YYYY-MM-DD")
            return
        
        # Contar registros en el rango
        registros_rango = RegistroHoras.query.filter(
            RegistroHoras.FechaEmpleado >= fecha_ini,
            RegistroHoras.FechaEmpleado <= fecha_fin
        ).count()
        
        print(f"📊 Registros encontrados en el rango: {registros_rango}")
        
        if registros_rango == 0:
            print("✅ No hay registros en el rango especificado")
            return
        
        # Confirmar la acción
        print(f"\n⚠️  ADVERTENCIA: Esta acción eliminará {registros_rango} registros")
        respuesta = input("¿Continuar? (escribe 'SI' para confirmar): ")
        
        if respuesta.upper() != 'SI':
            print("❌ Operación cancelada")
            return
        
        # Eliminar registros en el rango
        try:
            registros_eliminar = RegistroHoras.query.filter(
                RegistroHoras.FechaEmpleado >= fecha_ini,
                RegistroHoras.FechaEmpleado <= fecha_fin
            ).all()
            
            # Eliminar fotos
            fotos_eliminadas = 0
            for registro in registros_eliminar:
                for foto_field in [registro.FotoKilometraje, registro.FotoHorometro, registro.FotoGrua]:
                    if foto_field:
                        foto_path = os.path.join('static/uploads', foto_field)
                        if os.path.exists(foto_path):
                            try:
                                os.remove(foto_path)
                                fotos_eliminadas += 1
                            except Exception as e:
                                print(f"⚠️  No se pudo eliminar {foto_path}: {e}")
            
            # Eliminar registros de la base de datos
            RegistroHoras.query.filter(
                RegistroHoras.FechaEmpleado >= fecha_ini,
                RegistroHoras.FechaEmpleado <= fecha_fin
            ).delete()
            db.session.commit()
            
            print(f"✅ {registros_rango} registros eliminados")
            print(f"📸 {fotos_eliminadas} fotos eliminadas")
            
        except Exception as e:
            db.session.rollback()
            print(f"❌ Error al eliminar registros: {e}")

def mostrar_estadisticas():
    """Mostrar estadísticas de registros de horas"""
    with app.app_context():
        print("📊 ESTADÍSTICAS DE REGISTROS DE HORAS")
        print("=" * 50)
        
        total = RegistroHoras.query.count()
        entradas = RegistroHoras.query.filter_by(TipoRegistro='entrada').count()
        salidas = RegistroHoras.query.filter_by(TipoRegistro='salida').count()
        
        print(f"Total de registros: {total}")
        print(f"Entradas: {entradas}")
        print(f"Salidas: {salidas}")
        print(f"Pendientes (sin salida): {entradas - salidas}")
        
        if total > 0:
            from sqlalchemy import func
            fecha_primera = db.session.query(func.min(RegistroHoras.FechaEmpleado)).scalar()
            fecha_ultima = db.session.query(func.max(RegistroHoras.FechaEmpleado)).scalar()
            
            print(f"Primera fecha: {fecha_primera}")
            print(f"Última fecha: {fecha_ultima}")

if __name__ == "__main__":
    import sys
    
    if len(sys.argv) < 2:
        print("Uso:")
        print("  python limpiar_registros.py all                    # Eliminar todos los registros")
        print("  python limpiar_registros.py range YYYY-MM-DD YYYY-MM-DD  # Eliminar por rango de fechas")
        print("  python limpiar_registros.py stats                  # Mostrar estadísticas")
        sys.exit(1)
    
    command = sys.argv[1]
    
    if command == "all":
        limpiar_registros_horas()
    elif command == "range":
        if len(sys.argv) < 4:
            print("❌ Especifica las fechas de inicio y fin")
            print("Uso: python limpiar_registros.py range 2024-01-01 2024-12-31")
            sys.exit(1)
        limpiar_registros_por_fecha(sys.argv[2], sys.argv[3])
    elif command == "stats":
        mostrar_estadisticas()
    else:
        print("❌ Comando no válido")
        sys.exit(1)

# Script de limpieza para VPS
# Sistema de Gestión de Grúas

Write-Host "🧹 INICIANDO LIMPIEZA DE ARCHIVOS INNECESARIOS" -ForegroundColor Green
Write-Host "=" * 50

# Lista de archivos a eliminar
$filesToDelete = @(
    # Scripts de migración
    "migrate_to_postgresql.py",
    "migrate_data.py", 
    "migrate_data.ps1",
    "simple_migrate.py",
    
    # Scripts de instalación Windows
    "install_postgresql.ps1",
    "setup_database.ps1",
    "optimize_database.ps1",
    "update_app.ps1",
    "test_connection.ps1",
    
    # Scripts de análisis
    "database_analysis.py",
    "optimize_database.py",
    "create_indexes.py",
    
    # Configuraciones duplicadas
    "config_postgresql.py",
    "config_production.py",
    
    # Scripts de mantenimiento
    "backup_db.py",
    "limpiar_registros.py",
    "reset_database.py",
    "init_demo_data.py",
    
    # Guías de migración
    "MIGRATION_GUIDE_UBUNTU.md",
    "MIGRATION_GUIDE.md"
)

Write-Host "📋 Archivos a eliminar:" -ForegroundColor Yellow
foreach ($file in $filesToDelete) {
    if (Test-Path $file) {
        Write-Host "  ❌ $file" -ForegroundColor Red
    } else {
        Write-Host "  ⚠️ $file (no encontrado)" -ForegroundColor Gray
    }
}

Write-Host "`n🗑️ Eliminando archivos..." -ForegroundColor Yellow

$deletedCount = 0
$notFoundCount = 0

foreach ($file in $filesToDelete) {
    if (Test-Path $file) {
        try {
            Remove-Item $file -Force
            Write-Host "  ✅ Eliminado: $file" -ForegroundColor Green
            $deletedCount++
        } catch {
            Write-Host "  ❌ Error eliminando: $file - $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        $notFoundCount++
    }
}

Write-Host "`n📊 RESUMEN DE LIMPIEZA:" -ForegroundColor Cyan
Write-Host "  ✅ Archivos eliminados: $deletedCount" -ForegroundColor Green
Write-Host "  ⚠️ Archivos no encontrados: $notFoundCount" -ForegroundColor Yellow
Write-Host "  📁 Total procesados: $($filesToDelete.Count)" -ForegroundColor Blue

Write-Host "`n📁 ARCHIVOS RESTANTES NECESARIOS:" -ForegroundColor Cyan
$remainingFiles = @(
    "app.py",
    "models.py", 
    "forms.py",
    "config.py",
    "run.py",
    "requirements.txt",
    "templates/",
    "static/"
)

foreach ($file in $remainingFiles) {
    if (Test-Path $file) {
        Write-Host "  ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $file (FALTANTE)" -ForegroundColor Red
    }
}

Write-Host "`n🎯 PRÓXIMOS PASOS:" -ForegroundColor Cyan
Write-Host "1. Crear archivos nuevos para VPS" -ForegroundColor White
Write-Host "2. Configurar variables de entorno" -ForegroundColor White
Write-Host "3. Probar la aplicación" -ForegroundColor White
Write-Host "4. Preparar para despliegue" -ForegroundColor White

Write-Host "`n✅ LIMPIEZA COMPLETADA" -ForegroundColor Green

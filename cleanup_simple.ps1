# Script de limpieza simplificado para VPS
Write-Host "INICIANDO LIMPIEZA DE ARCHIVOS INNECESARIOS" -ForegroundColor Green
Write-Host "============================================="

# Lista de archivos a eliminar
$filesToDelete = @(
    "migrate_to_postgresql.py",
    "migrate_data.py", 
    "migrate_data.ps1",
    "simple_migrate.py",
    "install_postgresql.ps1",
    "setup_database.ps1",
    "optimize_database.ps1",
    "update_app.ps1",
    "test_connection.ps1",
    "database_analysis.py",
    "optimize_database.py",
    "create_indexes.py",
    "config_postgresql.py",
    "config_production.py",
    "backup_db.py",
    "limpiar_registros.py",
    "reset_database.py",
    "init_demo_data.py",
    "MIGRATION_GUIDE_UBUNTU.md",
    "MIGRATION_GUIDE.md"
)

Write-Host "Archivos a eliminar:" -ForegroundColor Yellow
foreach ($file in $filesToDelete) {
    if (Test-Path $file) {
        Write-Host "  - $file" -ForegroundColor Red
    } else {
        Write-Host "  - $file (no encontrado)" -ForegroundColor Gray
    }
}

Write-Host "`nEliminando archivos..." -ForegroundColor Yellow

$deletedCount = 0
$notFoundCount = 0

foreach ($file in $filesToDelete) {
    if (Test-Path $file) {
        try {
            Remove-Item $file -Force
            Write-Host "  Eliminado: $file" -ForegroundColor Green
            $deletedCount++
        } catch {
            Write-Host "  Error eliminando: $file" -ForegroundColor Red
        }
    } else {
        $notFoundCount++
    }
}

Write-Host "`nRESUMEN DE LIMPIEZA:" -ForegroundColor Cyan
Write-Host "  Archivos eliminados: $deletedCount" -ForegroundColor Green
Write-Host "  Archivos no encontrados: $notFoundCount" -ForegroundColor Yellow
Write-Host "  Total procesados: $($filesToDelete.Count)" -ForegroundColor Blue

Write-Host "`nARCHIVOS RESTANTES NECESARIOS:" -ForegroundColor Cyan
$remainingFiles = @("app.py", "models.py", "forms.py", "config.py", "run.py", "requirements.txt")

foreach ($file in $remainingFiles) {
    if (Test-Path $file) {
        Write-Host "  OK: $file" -ForegroundColor Green
    } else {
        Write-Host "  FALTANTE: $file" -ForegroundColor Red
    }
}

Write-Host "`nLIMPIEZA COMPLETADA" -ForegroundColor Green

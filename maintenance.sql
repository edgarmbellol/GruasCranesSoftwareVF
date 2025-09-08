
    -- Script de mantenimiento para base de datos de grúas
    -- Ejecutar semanalmente
    
    -- 1. Limpiar registros de sesión antiguos (si los hay)
    DELETE FROM user_sessions WHERE created_at < datetime('now', '-30 days');
    
    -- 2. Optimizar base de datos SQLite
    VACUUM;
    
    -- 3. Analizar tablas para optimizar consultas
    ANALYZE;
    
    -- 4. Verificar integridad
    PRAGMA integrity_check;
    
    -- 5. Estadísticas de uso
    SELECT 
        name,
        (SELECT COUNT(*) FROM sqlite_master WHERE type='index' AND tbl_name=name) as indexes,
        (SELECT COUNT(*) FROM pragma_table_info(name)) as columns
    FROM sqlite_master 
    WHERE type='table' 
    AND name NOT LIKE 'sqlite_%'
    ORDER BY name;
    
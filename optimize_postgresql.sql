-- Script de optimización para PostgreSQL
-- Sistema de Gestión de Grúas

-- 1. Índices para tabla registro_horas (crítica)
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_registro_horas_fecha_empleado 
ON registro_horas (fecha_empleado, id_empleado);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_registro_horas_equipo_fecha 
ON registro_horas (id_equipo, fecha_empleado);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_registro_horas_tipo_fecha 
ON registro_horas (tipo_registro, fecha_empleado);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_registro_horas_empleado_tipo 
ON registro_horas (id_empleado, tipo_registro, fecha_empleado);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_registro_horas_fecha_creacion 
ON registro_horas (fecha_creacion);

-- 2. Índices para tabla users
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_users_estado_perfil 
ON users (estado, perfil_usuario);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_users_documento 
ON users (documento);

-- 3. Índices para tabla equipos
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_equipos_estado_tipo 
ON equipos (estado, id_tipo_equipo);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_equipos_placa 
ON equipos (placa);

-- 4. Índices para otras tablas
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_cargos_estado 
ON cargos (estado);

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_clientes_estado 
ON clientes (estado);

-- 5. Vistas materializadas para reportes frecuentes
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_empleados_activos AS
SELECT 
    id,
    nombre,
    documento,
    perfil_usuario,
    ultimo_login
FROM users 
WHERE estado = 'activo';

CREATE UNIQUE INDEX ON mv_empleados_activos (id);

CREATE MATERIALIZED VIEW IF NOT EXISTS mv_equipos_activos AS
SELECT 
    e.id_equipo,
    e.placa,
    e.capacidad,
    te.descripcion as tipo_equipo,
    m.descripcion as marca
FROM equipos e
JOIN tipo_equipos te ON e.id_tipo_equipo = te.id_tipo_equipo
JOIN marcas m ON e.id_marca = m.id_marca
WHERE e.estado = 'activo';

CREATE UNIQUE INDEX ON mv_equipos_activos (id_equipo);

-- 6. Función para actualizar vistas materializadas
CREATE OR REPLACE FUNCTION refresh_materialized_views()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_empleados_activos;
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_equipos_activos;
END;
$$ LANGUAGE plpgsql;

-- 7. Configurar particionado para registro_horas (opcional para futuro)
-- CREATE TABLE registro_horas_partitioned (LIKE registro_horas) PARTITION BY RANGE (fecha_empleado);

-- 8. Estadísticas de tablas
ANALYZE;

-- 9. Configuraciones adicionales de rendimiento
ALTER TABLE registro_horas SET (fillfactor = 90);
ALTER TABLE users SET (fillfactor = 95);
ALTER TABLE equipos SET (fillfactor = 95);

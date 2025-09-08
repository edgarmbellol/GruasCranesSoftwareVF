-- Script de configuración de base de datos PostgreSQL
-- Sistema de Gestión de Grúas

-- 1. Crear base de datos y usuario
CREATE DATABASE gruas_db;
CREATE USER gruas_user WITH PASSWORD 'gruas_password';
GRANT ALL PRIVILEGES ON DATABASE gruas_db TO gruas_user;

-- 2. Conectar a la base de datos
\c gruas_db;

-- 3. Otorgar permisos adicionales
GRANT ALL ON SCHEMA public TO gruas_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO gruas_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO gruas_user;

-- 4. Configurar extensiones útiles
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";

-- 5. Configuraciones de rendimiento
ALTER SYSTEM SET shared_preload_libraries = 'pg_stat_statements';
ALTER SYSTEM SET max_connections = 200;
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET effective_cache_size = '1GB';
ALTER SYSTEM SET maintenance_work_mem = '64MB';
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET wal_buffers = '16MB';
ALTER SYSTEM SET default_statistics_target = 100;

-- 6. Aplicar configuraciones
SELECT pg_reload_conf();

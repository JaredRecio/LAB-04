-- Laboratorio 04: Hardening y configuración segura de PostgreSQL
-- Script 03: Inspección de parámetros de conexión y extensiones
-- Estudiante: Jesús Jared Recio Ozúa | Grupo: 4-3

-- Límites de conexiones y tiempos de espera (Ref: Lab-04, Sec. 17)
SHOW max_connections;
SHOW superuser_reserved_connections;
SHOW statement_timeout;
SHOW idle_in_transaction_session_timeout;

-- Auditoría de extensiones instaladas en el motor (Ref: Lab-04, Sec. 16)
SELECT 
    extname, 
    extversion 
FROM pg_extension 
ORDER BY extname;
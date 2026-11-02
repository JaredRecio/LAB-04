-- Laboratorio 04: Hardening y configuración segura de PostgreSQL
-- Script 04: Verificación del estado de TLS y sesión actual
-- Estudiante: Jesús Jared Recio Ozúa | Grupo: 4-3

-- Comprobación de cifrado en tránsito (Ref: Lab-04, Sec. 21)
SHOW ssl;
SHOW ssl_min_protocol_version;

-- Inspección correcta uniendo la sesión actual con la actividad del motor
SELECT 
    a.pid,
    a.usename,
    a.client_addr,
    s.ssl,
    s.version,
    s.cipher
FROM pg_stat_ssl s
JOIN pg_stat_activity a ON s.pid = a.pid
WHERE s.pid = pg_backend_pid();
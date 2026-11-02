-- Laboratorio 04: Hardening y configuración segura de PostgreSQL
-- Script 02: Inspección de roles, permisos y privilegios
-- Estudiante: Jesús Jared Recio Ozúa | Grupo: 4-3

-- Análisis detallado de los roles del sistema (Ref: Lab-04, Sec. 14)
SELECT 
    rolname, 
    rolsuper, 
    rolinherit, 
    rolcreaterole, 
    rolcreatedb, 
    rolcanlogin 
FROM pg_roles 
ORDER BY rolname;
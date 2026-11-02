-- Laboratorio 04: Hardening y configuración segura de PostgreSQL
-- Script 01: Inspección de superficie de ataque y parámetros generales
-- Estudiante: Jesús Jared Recio Ozúa | Grupo: 4-3

-- Actividad 1: Superficie de ataque y parámetros principales
SELECT version();
SHOW port;
SHOW listen_addresses;
SHOW ssl;
SHOW password_encryption;

-- Inspección de conexiones activas en el motor
SELECT 
    pid,
    usename,
    datname,
    client_addr,
    client_port,
    application_name
FROM pg_stat_activity;

-- Actividad 2: Ubicación física de archivos de configuración y registros
SHOW config_file;
SHOW hba_file;
SHOW ident_file;
SHOW data_directory;
SHOW log_directory;
SHOW log_connections;
SHOW log_disconnections;

-- Actividad 4: Inspección de reglas del archivo pg_hba.conf
SELECT 
    type, 
    database, 
    user_name, 
    address, 
    auth_method 
FROM pg_hba_file_rules;
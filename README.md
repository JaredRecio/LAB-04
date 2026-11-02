# LAB-04 - Hardening y configuración segura de PostgreSQL
#### Grupo: 4-3
#### Estudiante: Jesús Jared Recio Ozúa

## Objetivo
Aplicar un proceso básico de hardening en PostgreSQL 16/17, identificando configuraciones inseguras, reduciendo la superficie de exposición y estableciendo controles estrictos de acceso, autenticación por red y cifrado para garantizar una operación segura.

## Entorno
* **Motor:** PostgreSQL 16 / 17
* **Modalidad:** Individual (Entorno académico aislado)
* **Herramientas:** Terminal del sistema, consola psql, pgAdmin 4 y scripts SQL de inspección.

## Superficie de ataque inicial
* El servidor escuchaba inicialmente de forma genérica en todas las interfaces (`listen_addresses = '*'`).
* Existía exposición potencial del puerto 5432 ante redes demasiado amplias.
* Ausencia de una documentación formal de la línea base de seguridad y de los parámetros de configuración de red.

## Hallazgos
1. El parámetro `listen_addresses` permitía conexiones globales innecesarias para un entorno local.
2. Los roles administrativos compartían capacidades elevadas sin una segregación adecuada frente a las cuentas de aplicación.
3. Ficheros de configuración expuestos si no se respaldan con permisos estrictos a nivel de sistema operativo.

## Cambios realizados
* Restricción del parámetro `listen_addresses` exclusivamente a `localhost` (`127.0.0.1` y `::1`).
* Consolidación del uso del método de autenticación robusto `scram-sha-256`.
* Delimitación de funciones para que el superusuario `postgres` se emplee únicamente en tareas locales de mantenimiento.

## Justificación de los cambios
Reducir la superficie de ataque disminuye drásticamente los vectores mediante los cuales un agente malicioso o un error operativo podría comprometer la integridad de la base de datos. Aplicar el principio de mínimo privilegio asegura que cada componente interactúe solo con lo estrictamente necesario.

## Verificación
Mediante la ejecución de consultas sobre las vistas del sistema (`pg_stat_activity`, `pg_stat_ssl`, `pg_roles` y `pg_hba_file_rules`) se comprobó que el servidor opera de manera acotada, con autenticación cifrada por SCRAM y sin exposición innecesaria en interfaces públicas.

## Checklist de hardening
1. Puerto de red documentado y validado.
2. Interfaces de escucha restringidas a bucle local.
3. Archivo `pg_hba.conf` revisado sin reglas excesivamente permisivas (`0.0.0.0/0`).
4. Autenticación robusta basada en `scram-sha-256`.
5. Superusuarios identificados y limitados.
6. Cuentas de aplicación y roles segregados.
7. Principio de mínimo privilegio aplicado.
8. Extensiones auditadas (únicamente `plpgsql`).
9. Cifrado TLS verificado y disponible para entornos remotos.
10. Línea base de seguridad documentada y respaldada con evidencias.

## Conclusiones
El hardening demostró que una base de datos segura no depende únicamente de contar con contraseñas complejas, sino de una estrategia integral de múltiples capas que abarque desde la red y el sistema operativo hasta los permisos internos, la autenticación y la minimización de servicios expuestos.
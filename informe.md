# INFORME TÉCNICO: LABORATORIO 04 - HARDENING DE POSTGRESQL
#### Grupo: 4-3
#### Estudiante: Jesús Jared Recio Ozúa

### 1. ¿Cuál era la principal superficie de ataque?
El hecho de que PostgreSQL estuviera configurado para escuchar en todas las interfaces de red (`listen_addresses = '*'`) de forma predeterminada, exponiendo el puerto 5432 ante redes demasiado amplias sin acotar los orígenes de conexión.

### 2. ¿Qué configuración representaba el mayor riesgo?
Permitir el acceso mediante reglas excesivamente permisivas en el archivo `pg_hba.conf` (como patrones globales `0.0.0.0/0`) combinada con el uso de cuentas con privilegios de superusuario para aplicaciones operativas.

### 3. ¿Qué cambio produjo la mayor reducción de exposición?
La restricción de `listen_addresses` a `localhost` (`127.0.0.1` y `::1`), lo cual aísla el servicio de bases de datos de cualquier intento de acceso directo desde redes públicas o interfaces externas innecesarias.

### 4. ¿Qué diferencia existe entre firewall y pg_hba.conf?
El firewall opera a nivel de sistema operativo y red (capas de transporte/red) bloqueando o permitiendo paquetes IP y puertos antes de llegar al servicio. Por su parte, `pg_hba.conf` es un control interno de PostgreSQL basado en host que valida la combinación de base de datos, usuario, red de origen y método de autenticación a nivel de aplicación de base de datos.

### 5. ¿Qué diferencia existe entre autenticación y autorización?
* **Autenticación:** El proceso mediante el cual el sistema verifica *quién* es el usuario (por ejemplo, mediante credenciales y métodos como `scram-sha-256`).
* **Autorización:** El proceso posterior que determina *qué* puede hacer ese usuario verificado (mediante roles, permisos y restricciones de esquema).

### 6. ¿Por qué una cuenta de aplicación no debe ser SUPERUSER?
Porque si la aplicación web o el software cliente se viera comprometido (por ejemplo, mediante una vulnerabilidad de inyección SQL), el atacante heredaría capacidades administrativas globales absolutas sobre todo el motor y el sistema operativo subyacente.

### 7. ¿Por qué cambiar el puerto de PostgreSQL no constituye hardening suficiente?
Porque modificar el puerto 5432 a otro número solo mitiga el ruido automatizado o los escaneos superficiales de bots (seguridad por oscuridad), pero no corrige credenciales débiles, fallas de autenticación, excesos de privilegios ni configuraciones deficientes de red.

### 8. ¿Por qué `listen_addresses='*'` puede ser innecesario?
Porque la gran mayoría de los servicios modernos de arquitectura dividida sitúan la base de datos en un entorno local (bucle local) o dentro de una red privada específica y controlada; habilitar todas las interfaces abre el servicio a redes donde no hay clientes legítimos.

### 9. ¿Qué papel tiene el sistema operativo en la seguridad de PostgreSQL?
Es la primera línea de defensa física y lógica. El sistema operativo protege los archivos de configuración (`postgresql.conf`, `pg_hba.conf`) y el directorio de datos mediante permisos estrictos de ficheros (como `600` o `700`) y cuentas de servicio sin privilegios, evitando que usuarios locales no autorizados lean credenciales o claves.

### 10. ¿Qué controles deberían revisarse periódicamente?
* Las reglas de acceso y autenticación en `pg_hba.conf`.
* La asignación de roles y la revisión de privilegios huérfanos o excesivos.
* El catálogo de extensiones instaladas (`pg_extension`).
* La topología de red y los registros de auditoría/bitácoras de conexión.
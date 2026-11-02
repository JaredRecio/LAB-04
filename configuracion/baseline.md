# Actividad 19 — Construcción de una línea base
# Línea base de seguridad para PostgreSQL 16

### Red
| Control | Parámetro de referencia |
|---|---|
| Interfaces autorizadas | `listen_addresses = 'localhost'` o una dirección IP privada específica del servidor si existen clientes remotos; jamás debe dejarse abierto con asterisco (`*`). |
| Puerto | 5432/TCP validado mediante herramientas del sistema operativo como `ss -lnt` o `netstat -ano`. |
| Firewall | Política predeterminada de denegación absoluta. El tráfico hacia el puerto 5432 solo se admite desde segmentos de red de confianza. |
| Redes permitidas | Restringido exclusivamente al perímetro de aplicaciones y administradores (por ejemplo, `10.10.10.0/24`), bloqueando cualquier acceso directo desde redes públicas. |

### Autenticación
| Control | Parámetro de referencia |
|---|---|
| Método de acceso | Obligatoriedad de `scram-sha-256`, erradicando por completo métodos obsoletos o inseguros como `trust`, `password` y `md5`. |
| Cifrado de contraseñas | `password_encryption = scram-sha-256`. |
| Políticas de credenciales | Claves robustas y exclusivas por cada cuenta, ciclos periódicos de renovación, restricciones de vigencia en los roles y prohibición estricta de almacenar secretos en el código fuente. |
| Cuentas administrativas | El superusuario `postgres` se restringe de manera exclusiva para labores de gestión y únicamente mediante conexiones locales. |
| Configuración de `pg_hba.conf` | Definición estricta de tuplas (base de datos + usuario + origen + mecanismo). Las restricciones más específicas se ubican al inicio y se prohíben comodines amplios como `0.0.0.0/0`. |

### Autorización
| Control | Parámetro de referencia |
|---|---|
| Esquema de roles | Jerarquía dividida en tres perfiles: DBA (gestión global), APP (software operativo) y CONSULTA (solo lectura analítica). Los permisos se otorgan mediante roles de grupo. |
| Privilegios | Aplicación rigurosa del principio de mínimo privilegio; derecho de `CONNECT` limitado y permisos `GRANT` acotados estrictamente a los objetos indispensables. |
| Cuentas de aplicación | Cuentas operativas desprovistas de privilegios de superusuario, con un usuario único por cada aplicación y prohibición absoluta de compartir credenciales administrativas. |

### Configuración
| Control | Parámetro de referencia |
|---|---|
| Parámetros relevantes | `ssl = on`, `ssl_min_protocol_version = 'TLSv1.2'`, activación de `log_connections` y `log_disconnections`, estructurando el `log_line_prefix` para registrar usuario, base de datos, IP de origen y marca temporal. |
| Gestión de conexiones | `max_connections` dimensionado acorde a la carga real de trabajo, `superuser_reserved_connections = 3`, y desactivación de tiempos de espera infinitos en `statement_timeout` e `idle_in_transaction_session_timeout` (configurando umbrales prudentes como 30s y 60s). |
| Extensiones | Reducción al mínimo indispensable (únicamente `plpgsql`), auditando periódicamente el catálogo de extensiones instaladas (`pg_extension`). |
| Bitácoras de eventos | Políticas de rotación y retención de registros de actividad con control estricto de accesos. |

### Sistema operativo
| Control | Parámetro de referencia |
|---|---|
| Propietario de archivos | Asignación exclusiva al usuario del sistema operativo que ejecuta el servicio de base de datos. |
| Permisos de ficheros | En sistemas operativos basados en Linux, el directorio de datos debe poseer permisos restrictivos (`700`), y los archivos críticos como `postgresql.conf` y `pg_hba.conf` permisos de `600`, evitando accesos para usuarios generales. |
| Directorio de datos | Ubicado en volúmenes de almacenamiento dedicados y aislados, con supervisión de espacio disponible; los respaldos y registros heredan las mismas restricciones de seguridad. |
| Ejecución del servicio | El demonio de PostgreSQL opera bajo una cuenta de usuario sin privilegios del sistema, descartando totalmente el uso de cuentas de superusuario como `root` o administrador local. |

### Cifrado y protección de datos
| Control | Parámetro de referencia |
|---|---|
| Canal seguro (TLS) | `ssl = on` respaldado por certificados digitales válidos, complementado con directivas de tipo `hostssl` para clientes remotos y supervisado mediante la vista `pg_stat_ssl`. |
| Protección de credenciales | Verificadores criptográficos basados en SCRAM almacenados en el servidor; prohibición terminante de registrar claves en texto claro dentro de scripts o repositorios. |
| Información sensible | Cifrado a nivel de almacenamiento o volúmenes, respaldos protegidos criptográficamente, y empleo de utilidades como `pggcrypto` o cifrado de aplicación para resguardar atributos críticos fuera del alcance de los registros de log. |

### Mantenimiento y gobernanza
| Control | Parámetro de referencia |
|---|---|
| Actualización y parches | Aplicación programada de versiones menores y correcciones de seguridad para PostgreSQL 16 bajo ventanas de mantenimiento controladas, registrando la versión mediante la instrucción `SELECT version();`. |
| Revisiones periódicas | Auditorías trimestrales sobre las reglas de autenticación del archivo `pg_hba.conf`, la asignación de roles, el inventario de extensiones, la topología de red y el contenido de las bitácoras. |
| Estrategia de respaldos | Ejecución periódica de copias mediante `pg_dump` o `pg_basebackup` junto con los ficheros de configuración, almacenados en ubicaciones externas y validadas mediante pruebas de recuperación periódicas. |
| Documentación técnica | Línea base mantenida bajo control de versiones, bitácora detallada de modificaciones (estado previo frente a estado posterior) y listas de verificación respaldadas con evidencias gráficas. |
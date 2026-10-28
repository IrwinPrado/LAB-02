# LAB-02: Cifrado, Credenciales y Comunicaciones Seguras

**Estudiante:** Irwin Gabriel Martinez Prado  
**Materia:** Gestión de Seguridad y Desempeño de Bases de Datos  
**Unidad:** II. Seguridad, privacidad y control de acceso  
**Tema:** 2.4 Cifrado, credenciales y protección de las comunicaciones  
**Motor:** PostgreSQL 16  
**Fecha:** 28 de octubre de 2026  

---

## Estructura del Repositorio

```text
LAB-02/
├── README.md
├── sql/
│   ├── 01-credenciales.sql
│   ├── 02-cifrado-datos.sql
│   └── 03-verificacion-tls.sql
└── evidencias/
    ├── 01-credenciales.md
    ├── 02-cifrado-datos.md
    ├── 03-gestion-claves.md
    ├── 04-tls.md
    ├── 07-comparacion.md
    ├── 08-analisis-escenario.md
    └── 10-politica-claves.md

    ### 1. Introducción
En este laboratorio se abordó la protección criptográfica en PostgreSQL para resolver tres problemas críticos de seguridad: la vulnerabilidad de guardar contraseñas en texto claro, la necesidad de cifrar datos sensibles recuperables en reposo (como el RFC) y la protección de las comunicaciones entre el cliente y el servidor PostgreSQL en tránsito mediante TLS.

### 2. Protección de Credenciales
Se diferenció claramente entre texto claro, hash y cifrado simétrico. Se demostró que las contraseñas nunca deben almacenarse directamente ni cifrarse de forma reversible. Se utilizó la extensión `pgcrypto` con las funciones `crypt()` y `gen_salt('bf')` (Blowfish) para aplicar derivación unidireccional con sal, garantizando que el hash generado sea no reversible y resistente a ataques de tablas Rainbow y fuerza bruta.

### 3. Protección de Datos Sensibles
Para datos que requieren ser recuperados en su formato original (como el RFC), se implementó cifrado simétrico a nivel de columna con `pgp_sym_encrypt()` y descifrado condicional con `pgp_sym_decrypt()`. Esta técnica protege la confidencialidad de la información en reposo contra consultas directas a las tablas o robos de archivos de datos.

### 4. TLS (Transport Layer Security)
Se verificó el estado de TLS en PostgreSQL mediante consultas a `SHOW ssl;` y a la vista administrativa `pg_stat_ssl`. TLS resuelve el problema de la intercepción de tráfico en tránsito (eavesdropping y tampering). Se analizó la diferencia entre los modos `sslmode=require` (cifrado obligatorio sin validación estricta) y `sslmode=verify-full` (cifrado obligatorio con validación de certificado CA y coincidencia del nombre del servidor).

### 5. Gestión de Claves
Se analizó el riesgo crítico de incluir contraseñas o claves en scripts SQL o código fuente (*hardcoded secrets*). Las claves publicadas en repositorios Git permanecen en el historial de commits de forma permanente. Por ello, las claves deben gestionarse fuera de la base de datos utilizando variables de entorno o sistemas de gestión de secretos (*KMS* / *Vault*).

### 6. Resultados
* Se migraron credenciales vulnerables en texto claro a un esquema seguro de hash con sal Blowfish (`$2a$06$...`).
* Se cifraron con éxito columnas de RFC con el estándar PGP de `pgp_sym_encrypt`.
* Se validaron las vistas del motor PostgreSQL para monitorear conexiones seguras y parámetros TLS.
* Se estructuraron los 7 archivos de evidencia requeridos en la carpeta `evidencias/`.

### 7. Problemas Encontrados
Durante la ejecución desde la terminal de Windows, se identificó la diferencia entre ejecutar comandos en la shell del sistema contra el intérprete `psql`. Se resolvió ingresando correctamente al prompt interactivo de PostgreSQL o pasando el parámetro `-f` a la herramienta `psql.exe`.

### 8. Conclusiones
La seguridad en bases de datos exige una estrategia de defensa en profundidad. El control de acceso por roles (RBAC) es insuficiente si los datos almacenados en disco o transmitidos por la red no están protegidos criptográficamente. Cifrar en reposo, derivar contraseñas con sal, forzar TLS en tránsito y custodiar las claves fuera del código fuente son pilares indispensables para cualquier DBA.

---

## Preguntas de Reflexión

### 1. ¿Por qué una contraseña no debe almacenarse como texto claro?
**Respuesta:**  
Si una persona no autorizada u operadora obtiene acceso de lectura a la tabla o a un respaldo de la base de datos, obtendría de inmediato las credenciales en texto claro. Esto le permitiría suplantar identidades en el sistema y en otros servicios donde los usuarios reutilicen la misma contraseña.

---

### 2. ¿Por qué un hash no es equivalente a un cifrado?
**Respuesta:**  
Un hash criptográfico es una transformación matemática unidireccional no reversible. No existe una clave para "descifrar" un hash y recuperar el valor original. El cifrado, en cambio, es un proceso bidireccional diseñado para transformar datos legibles mediante una clave que permite recuperarlos cuando se requiera.

---

### 3. ¿Por qué el cifrado de una columna no sustituye al control de acceso?
**Respuesta:**  
El control de acceso (roles, usuarios y permisos) determina *quién* tiene autorización para conectarse y consultar las tablas. El cifrado de columna protege la confidencialidad de la información en caso de que la seguridad de la base de datos sea vulnerada o el disco sea sustraído. Ambos mecanismos se complementan en una estrategia de seguridad en capas.

---

### 4. ¿Por qué TLS no sustituye a los mecanismos de autorización de PostgreSQL?
**Respuesta:**  
TLS únicamente protege el canal de comunicación en tránsito contra escuchas o modificaciones en la red. Una vez que la conexión cifrada llega al servidor, los mecanismos de autorización y permisos (RBAC) de PostgreSQL son los que deciden a qué tablas, vistas y operaciones tiene acceso la sesión.

---

### 5. ¿Qué ocurriría si una organización pierde una clave utilizada para cifrar información?
**Respuesta:**  
La información cifrada con esa clave se volverá matemática e irreversiblemente inaccesible de forma permanente. Sin la clave correspondiente, es imposible realizar el descifrado, provocando una pérdida definitiva de los datos.

---

### 6. ¿Qué ocurriría si una clave criptográfica se publica accidentalmente en GitLab / GitHub?
**Respuesta:**  
Cualquier persona o sistema con acceso al repositorio (o a su historial de commits) podrá extraer la clave y utilizarla para descifrar la información sensible protegida, comprometiendo por completo la confidencialidad de los datos de la organización.

---

### 7. ¿Por qué un repositorio privado no debe considerarse un almacén de secretos?
**Respuesta:**  
Porque los repositorios conservan el historial completo de versiones (`git log`), otorgan acceso a múltiples colaboradores o canalizaciones de CI/CD, y no cuentan con las auditorías, controles de acceso estricto y capacidades de rotación automatizada que ofrecen los gestores dedicados de secretos.

---

### 8. ¿Qué diferencia existe entre proteger información almacenada y proteger información durante su transmisión?
**Respuesta:**  
* **Protección en reposo:** Mitiga riesgos si se roban discos, archivos de datos o respaldos no autorizados.
* **Protección en tránsito (TLS):** Evita que un atacante mediante un ataque de escucha (*eavesdropping*) pueda capturar las consultas o respuestas mientras viajan por la red entre el cliente y la base de datos.

---

### 9. ¿Por qué la gestión de claves es tan importante como el algoritmo criptográfico?
**Respuesta:**  
Los algoritmos criptográficos modernos son matemáticamente robustos. El eslabón más débil casi siempre radica en la generación, almacenamiento, rotación y custodia de las claves. Si la clave es expuesta o mal administrada, toda la protección criptográfica se anula de inmediato.

---

### 10. ¿Qué mecanismo adicional implementarías en una organización para proteger los respaldos de las bases de datos?
**Respuesta:**  
Implementaría el cifrado automático de los archivos de respaldo (`.dump` / `.sql`) antes de ser transferidos o almacenados, combinado con el almacenamiento en ubicaciones geográficas aisladas, control de acceso estricto a las claves de cifrado mediante un servicio de gestión de claves (KMS) y auditoría continua de las restauraciones.
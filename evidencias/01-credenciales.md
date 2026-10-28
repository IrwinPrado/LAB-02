### **1. `evidencias/01-credenciales.md`**

```markdown
# Evidencia 01: Protección de Credenciales

**Estudiante:** Irwin Gabriel Martinez Prado  
**Materia:** Gestión de Seguridad y Desempeño de Bases de Datos  
**Práctica:** LAB-02 — Cifrado, credenciales y comunicaciones seguras  

---

## 1. Objetivo
Demostrar los riesgos asociados al almacenamiento de contraseñas en texto claro e implementar un esquema seguro de derivación de claves utilizando funciones de hash con sal (`crypt` y `gen_salt` con algoritmo Blowfish) mediante la extensión `pgcrypto`.

---

## 2. Procedimiento y Comandos SQL
Se ejecutó el script `sql/01-credenciales.sql`:

```sql
-- Creación de tabla insegura (Texto claro)
CREATE TABLE usuarios_insegura (
    id BIGSERIAL PRIMARY KEY,
    usuario VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL
);
INSERT INTO usuarios_insegura (usuario, password) VALUES ('juan', 'Password123');

-- Creación de tabla segura (Hash + Sal)
CREATE TABLE usuarios_segura (
    id BIGSERIAL PRIMARY KEY,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL
);
INSERT INTO usuarios_segura (usuario, password_hash) 
VALUES ('juan', crypt('Password123', gen_salt('bf')));

-- Verificación de credenciales
SELECT usuario, password_hash = crypt('Password123', password_hash) AS contraseña_correcta 
FROM usuarios_segura WHERE usuario = 'juan';

```

## 3. Resultado Obtenido

### a Almacenamiento Inseguro (Texto Claro):
```text
postgres=# SELECT * FROM usuarios_insegura;
 id | usuario |  password   
----+---------+-------------
  1 | juan    | Password123
(1 row)
```

### b Almacenamiento Seguro (Hash + Sal con Blowfish):
```text
postgres=# SELECT * FROM usuarios_segura;
 id | usuario |                        password_hash                        
----+---------+-------------------------------------------------------------
  1 | juan    | $2a$06$v98H... (Hash encriptado no reversible)
(1 row)
```

### c Verificación de Contraseña Correcta e Incorrecta:
```text
postgres=# SELECT usuario, password_hash = crypt('Password123', password_hash) AS contraseña_correcta FROM usuarios_segura WHERE usuario = 'juan';
 usuario | contraseña_correcta 
---------+---------------------
 juan    | t
(1 row)

postgres=# SELECT usuario, password_hash = crypt('OtraPassword', password_hash) AS contraseña_correcta FROM usuarios_segura WHERE usuario = 'juan';
 usuario | contraseña_correcta 
---------+---------------------
 juan    | f
(1 row)
```
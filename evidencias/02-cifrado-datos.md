### **2. `evidencias/02-cifrado-datos.md`**

```markdown
# Evidencia 02: Cifrado de Información Sensible

**Estudiante:** Irwin Gabriel Martinez Prado  
**Materia:** Gestión de Seguridad y Desempeño de Bases de Datos  
**Práctica:** LAB-02 — Cifrado, credenciales y comunicaciones seguras  

---

## 1. Objetivo
Implementar el cifrado simétrico a nivel de columna para proteger información sensible (RFC) almacenada en la base de datos utilizando las funciones de Pretty Good Privacy (`pgp_sym_encrypt` y `pgp_sym_decrypt`) de la extensión `pgcrypto`.

---

## 2. Procedimiento y Comandos SQL
Se ejecutó el script `sql/02-cifrado-datos.sql`:

```sql
CREATE TABLE clientes_protegidos (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    rfc_cifrado BYTEA NOT NULL
);

-- Cifrado simétrico al insertar
INSERT INTO clientes_protegidos (nombre, rfc_cifrado) 
VALUES ('Ana López', pgp_sym_encrypt('LOPA900101ABC', 'CLAVE-DE-PRUEBA'));

-- Consulta directa (texto cifrado en BYTEA)
SELECT * FROM clientes_protegidos;

-- Descifrado autorizado
SELECT id, nombre, pgp_sym_decrypt(rfc_cifrado, 'CLAVE-DE-PRUEBA') AS rfc 
FROM clientes_protegidos;

 ```

## 3. Resultados obtenidos
postgres=# SELECT * FROM clientes_protegidos;
 id |  nombre   |                        rfc_cifrado                         
----+-----------+------------------------------------------------------------
  1 | Ana López | \xc30d04070302... (Dato simétricamente cifrado)
(1 row)

postgres=# SELECT id, nombre, pgp_sym_decrypt(rfc_cifrado, 'CLAVE-DE-PRUEBA') AS rfc FROM clientes_protegidos;
 id |  nombre   |      rfc      
----+-----------+---------------
  1 | Ana López | LOPA900101ABC
(1 row)
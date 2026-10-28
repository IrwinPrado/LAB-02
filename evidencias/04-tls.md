### **4. `evidencias/04-tls.md`**

```markdown
# Evidencia 04: Verificación de TLS y Comunicaciones Seguras

**Estudiante:** Irwin Gabriel Martinez Prado  
**Materia:** Gestión de Seguridad y Desempeño de Bases de Datos  
**Práctica:** LAB-02 — Cifrado, credenciales y comunicaciones seguras  

---

## 1. Objetivo
Verificar el estado de TLS/SSL en el servidor PostgreSQL para asegurar la confidencialidad e integridad de la información durante su transmisión entre el cliente y la base de datos.

---

## 2. Procedimiento y Comandos SQL
Se ejecutó el script `sql/03-verificacion-tls.sql`:

```sql
SHOW ssl;
SHOW ssl_min_protocol_version;
SHOW port;
SHOW listen_addresses;

SELECT pid, ssl, version, cipher, bits 
FROM pg_stat_ssl 
WHERE pid = pg_backend_pid();

```

## 3.Resultado
postgres=# SHOW ssl;
 ssl 
-----
 off
(1 row)

postgres=# SHOW port;
 port 
------
 5432
(1 row)

postgres=# SELECT pid, ssl, version, cipher, bits FROM pg_stat_ssl WHERE pid = pg_backend_pid();
  pid  | ssl | version | cipher | bits 
-------+-----+---------+--------+------
 12345 | f   |         |        |     
(1 row)
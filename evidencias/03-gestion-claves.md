### **3. `evidencias/03-gestion-claves.md`**

```markdown
# Evidencia 03: Gestión y Protección de Claves Criptográficas

**Estudiante:** Irwin Gabriel Martinez Prado  
**Materia:** Gestión de Seguridad y Desempeño de Bases de Datos  
**Práctica:** LAB-02 — Cifrado, credenciales y comunicaciones seguras  

---

## 1. Objetivo
Analizar los riesgos asociados a la inclusión de secretos y claves criptográficas dentro del código fuente o scripts SQL (*hardcoded secrets*) y evaluar su impacto al publicarse en sistemas de control de versiones como GitHub o GitLab.

---

## 2. Procedimiento
Se analizó la inclusión directa de claves en consultas SQL como:
```sql
SELECT pgp_sym_decrypt(rfc_cifrado, 'CLAVE-DE-PRUEBA') FROM clientes_protegidos;

```
## 3. Resultado Obtenido
postgres=# SELECT pgp_sym_decrypt(rfc_cifrado, 'CLAVE-DE-PRUEBA') FROM clientes_protegidos;
 pgp_sym_decrypt 
-----------------
 LOPA900101ABC
(1 row)
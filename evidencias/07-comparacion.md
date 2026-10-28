### **5. `evidencias/07-comparacion.md`**

```markdown
# Evidencia 07: Comparación entre Protección en Reposo y en Tránsito

**Estudiante:** Irwin Gabriel Martinez Prado  
**Materia:** Gestión de Seguridad y Desempeño de Bases de Datos  
**Práctica:** LAB-02 — Cifrado, credenciales y comunicaciones seguras  

---

## 1. Objetivo
Comparar las técnicas de protección criptográfica apropiadas según el estado de la información y el tipo de elemento a proteger en la base de datos.

---

## 2. Tabla Comparativa de Mecanismos de Protección

| Situación / Elemento | Mecanismo apropiado | ¿Qué protege? |
| :--- | :--- | :--- |
| **Contraseña de usuario** | Derivación de claves con sal (`bcrypt`, `Argon2id`, `crypt` + `bf`) | Protege las credenciales en reposo mediante una representación unidireccional no reversible contra ataques de fuerza bruta. |
| **RFC almacenado en una tabla** | Cifrado simétrico a nivel de columna (`pgp_sym_encrypt`) | Protege la confidencialidad de datos sensibles en reposo, permitiendo su descifrado solo a usuarios autorizados. |
| **Consulta enviada cliente → servidor** | Cifrado en tránsito con TLS (`sslmode=verify-full`) | Protege la confidencialidad e integridad de la comunicación durante la transmisión en la red. |
| **Respaldo de una base de datos** | Cifrado del archivo de respaldo (e.g., `gpg`, cifrado de disco) | Protege la información almacenada en reposo dentro de volúmenes o medios de almacenamiento externos. |
| **Clave criptográfica** | Gestor de secretos / HSM (*Key Management Service*) | Protege el acceso, uso, rotación y almacenamiento de la clave que custodia los datos cifrados. |

---

## 3. Conclusión
Cada tipo de dato y estado (en reposo o en tránsito) requiere una técnica específica. El cifrado de datos almacenados no reemplaza la protección del canal de comunicación ni la gestión segura de las credenciales.
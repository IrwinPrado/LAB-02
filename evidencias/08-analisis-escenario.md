# Evidencia 08: Análisis del Escenario de Seguridad

**Estudiante:** Irwin Gabriel Martinez Prado  
**Materia:** Gestión de Seguridad y Desempeño de Bases de Datos  
**Práctica:** LAB-02 — Cifrado, credenciales y comunicaciones seguras  

---

## 1. Objetivo
Evaluar las deficiencias de seguridad presentes en el escenario de la empresa Comercializadora Norte S.A. de C.V. y proponer las medidas correctivas correspondientes.

---

## 2. Respuestas al Análisis del Escenario

* **Pregunta 1: ¿Cuáles son los principales riesgos?**
  * Filtración masiva de credenciales al almacenar contraseñas en texto claro.
  * Violación de la privacidad de los clientes al almacenar el RFC en texto claro.
  * Interceptación de tráfico en la red por falta de validación de certificados TLS.
  * Exposición de claves de cifrado al estar escritas en scripts SQL subidos al repositorio.
  * Pérdida o robo de información mediante respaldos expuestos sin cifrado.

* **Pregunta 2: ¿Qué mecanismo utilizarías para cada elemento?**
  * **Contraseñas:** Derivación con hash y sal (`bcrypt` / `Argon2id`).
  * **RFC:** Cifrado simétrico a nivel de columna (`pgp_sym_encrypt`).
  * **Conexiones:** Configurar TLS con `sslmode=verify-full`.
  * **Claves:** Gestor de secretos externo (no guardar en archivos SQL).
  * **Respaldos:** Cifrado simétrico de archivos `.dump` / `.sql`.

* **Pregunta 3: ¿Cuál de los problemas consideras más crítico y por qué?**
  Almacenar las contraseñas en texto claro y la exposición de claves en el repositorio. La exposición de la clave compromete automáticamente todos los datos cifrados de la organización.

* **Pregunta 4: ¿Tener correctamente configurados los usuarios y permisos elimina estos riesgos?**
  No. Los roles y permisos restringen el acceso dentro de la base de datos, pero si un atacante obtiene un respaldo o intercepta la red, la falta de cifrado dejará la información expuesta.

---

## 3. Conclusión
La seguridad en bases de datos debe ser en capas (*Defense in Depth*), combinando control de acceso, cifrado en reposo, cifrado en tránsito y gestión adecuada de claves.
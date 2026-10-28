# Evidencia 10: Política Mínima de Gestión de Claves Criptográficas

**Estudiante:** Irwin Gabriel Martinez Prado  
**Materia:** Gestión de Seguridad y Desempeño de Bases de Datos  
**Práctica:** LAB-02 — Cifrado, credenciales y comunicaciones seguras  

---

## 1. Objetivo
Establecer una política mínima para la gestión segura del ciclo de vida de las claves criptográficas en la organización.

---

## 2. Reglas de la Política

1. **Generación:** Las claves criptográficas deben generarse utilizando generadores de números pseudoaleatorios criptográficamente seguros (CSPRNG) con longitudes mínimas de 256 bits para cifrado simétrico (AES-256).
2. **Prohibición de almacenamiento en código:** Queda estrictamente prohibido escribir o almacenar claves, contraseñas o tokens dentro del código fuente, scripts SQL o archivos de configuración integrados en Git.
3. **Almacenamiento Aislado:** Las claves deben custodiarse en sistemas dedicados a la gestión de secretos (Vault, KMS) o cargarse exclusivamente mediante variables de entorno protegidas.
4. **Control de Acceso:** El acceso a las claves de cifrado debe regirse bajo el principio de mínimo privilegio y separación de funciones; los desarrolladores no tendrán acceso a las claves de producción.
5. **Rotación Periódica:** Las claves de cifrado deben rotarse anualmente o de forma inmediata ante cualquier sospecha de compromiso.
6. **Respaldos de Claves:** Los respaldos de las claves se almacenarán cifrados en una ubicación geográfica distinta, custodiados bajo un esquema de control dual.
7. **Revocación:** Se mantendrá un procedimiento de revocación para invalidar de manera inmediata claves comprometidas o que hayan cumplido su ciclo de vida.
8. **Prevención de Exposición Accidental:** Se deben implementar herramientas de escaneo automatizado en los pipelines de CI/CD para detectar y bloquear commits que contengan secretos.
9. **Eliminación Segura:** Las claves en desuso o revocadas deben destruirse utilizando métodos de borrado seguro (*zeroization*) para evitar su recuperación.

---

## 3. Conclusión
Una política clara garantiza la protección de las claves criptográficas durante todo su ciclo de vida, previniendo exposiciones que comprometan la seguridad de la organización.
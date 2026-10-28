-- ============================================================
-- LAB-02: Cifrado, credenciales y comunicaciones seguras
-- Script: 02-cifrado-datos.sql
-- Estudiante: Irwin Gabriel Martinez Prado
-- Descripción: Cifrado simétrico de datos sensibles (RFC) mediante pgp_sym_encrypt,
--              recuperación con pgp_sym_decrypt y demostración de gestión de claves.
-- ============================================================

-- Habilitar la extensión pgcrypto
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 8.1 Crear tabla de demostración
CREATE TABLE clientes_protegidos (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    rfc_cifrado BYTEA NOT NULL
);

-- Insertar registro cifrando el RFC con clave simétrica
INSERT INTO clientes_protegidos (nombre, rfc_cifrado) 
VALUES ('Ana López', pgp_sym_encrypt('LOPA900101ABC', 'CLAVE-DE-PRUEBA'));

-- Consulta directa (se observa el RFC como un dato binario BYTEA encriptado)
SELECT * FROM clientes_protegidos;

-- 8.2 Recuperar el dato original con la clave simétrica correcta
SELECT 
    id, 
    nombre, 
    pgp_sym_decrypt(rfc_cifrado, 'CLAVE-DE-PRUEBA') AS rfc 
FROM clientes_protegidos;
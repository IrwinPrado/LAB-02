-- ============================================================
-- LAB-02: Cifrado, credenciales y comunicaciones seguras
-- Script: 01-credenciales.sql
-- Estudiante: Irwin Gabriel Martinez Prado
-- Descripción: Demostración de vulnerabilidad de almacenado en texto claro
--              y solución con hash y sal mediante pgcrypto (crypt/bf).
-- ============================================================

-- Habilitar la extensión criptográfica
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 7.1 Implementación Insegura (Demostrativa - Texto Claro)
CREATE TABLE usuarios_insegura (
    id BIGSERIAL PRIMARY KEY,
    usuario VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL
);

INSERT INTO usuarios_insegura (usuario, password)
VALUES ('juan', 'Password123');

-- Consulta para demostrar que la contraseña es visible directamente
SELECT * FROM usuarios_insegura;

-- 7.3 Generar representación no reversible con crypt() y gen_salt()
SELECT crypt('Password123', gen_salt('bf'));
SELECT crypt('Password123', gen_salt('bf'));

-- 7.4 Crear tabla para credenciales protegidas
CREATE TABLE usuarios_segura (
    id BIGSERIAL PRIMARY KEY,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL
);

INSERT INTO usuarios_segura (usuario, password_hash)
VALUES (
    'juan',
    crypt('Password123', gen_salt('bf'))
);

SELECT * FROM usuarios_segura;

-- 7.5 Verificación de contraseñas (Correcta e Incorrecta)
SELECT usuario, password_hash = crypt('Password123', password_hash) AS contraseña_correcta 
FROM usuarios_segura WHERE usuario = 'juan';

SELECT usuario, password_hash = crypt('OtraPassword', password_hash) AS contraseña_correcta 
FROM usuarios_segura WHERE usuario = 'juan';
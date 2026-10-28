-- ============================================================
-- LAB-02: Cifrado, credenciales y comunicaciones seguras
-- Script: 03-verificacion-tls.sql
-- Estudiante: Irwin Gabriel Martinez Prado
-- Descripción: Verificación del estado de TLS/SSL, puertos, versión de
--              protocolos y parámetros de la conexión activa en PostgreSQL.
-- ============================================================

-- 11. Verificar configuración general de SSL/TLS en el servidor
SHOW ssl;
SHOW ssl_min_protocol_version;
SHOW port;
SHOW listen_addresses;

-- 11.1 Verificar dirección IP y puerto del cliente conectado
SELECT
    inet_client_addr(),
    inet_client_port();

-- Verificar si la sesión actual utiliza TLS y los detalles del cifrado activo
SELECT 
    pid,
    ssl, 
    version, 
    cipher,
    bits,
    client_dn
FROM pg_stat_ssl 
WHERE pid = pg_backend_pid();
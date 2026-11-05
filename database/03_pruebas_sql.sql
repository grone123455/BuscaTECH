
-- ============================================
-- BUSCATECH
-- Archivo: 03_pruebas_sql.sql
-- Consultas de prueba de la base de datos
-- ============================================

-- 1. CONSULTAR TODOS LOS OBJETOS
SELECT *
FROM public.objetos
ORDER BY id;

-- 2. BUSCAR UN OBJETO POR SU IDENTIFICADOR
SELECT *
FROM public.objetos
WHERE id = 8;

-- 3. FILTRAR OBJETOS POR ESPECIALIDAD
SELECT *
FROM public.objetos
WHERE especialidad = 'Mecánica';

-- 4. CONSULTAR TODOS LOS PERFILES
SELECT *
FROM public.perfiles
ORDER BY creado_en DESC;

-- 5. CONSULTAR LA CANTIDAD DE OBJETOS
SELECT COUNT(*) AS cantidad_objetos
FROM public.objetos;

-- 6. CONSULTAR LA CANTIDAD DE PERFILES
SELECT COUNT(*) AS cantidad_perfiles
FROM public.perfiles;

-- 7. CONSULTAR OBJETOS ORDENADOS ALFABÉTICAMENTE
SELECT id, nombre, especialidad
FROM public.objetos
ORDER BY nombre ASC;

-- 8. CONSULTAR OBJETOS CON UBICACIÓN REGISTRADA
SELECT id, nombre, sector, estante, armario, cajon
FROM public.objetos
WHERE estante IS NOT NULL
   OR armario IS NOT NULL
   OR cajon IS NOT NULL;

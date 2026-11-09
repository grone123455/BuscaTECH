
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

-- 9. INSERTAR, ACTUALIZAR Y ELIMINAR UN OBJETO DE PRUEBA
-- Las operaciones se ejecutan dentro de una transacción
-- que se revierte al finalizar para no dejar registros de prueba.

BEGIN;

DO $$
DECLARE
    nuevo_id BIGINT;
    nombre_actualizado TEXT;
    id_eliminado BIGINT;
BEGIN
    -- INSERT
    INSERT INTO public.objetos (
        nombre,
        descripcion,
        especialidad,
        sector,
        estante,
        armario,
        cajon,
        observaciones
    )
    VALUES (
        'Objeto de prueba SQL',
        'Registro utilizado para comprobar las operaciones SQL.',
        'Mecánica',
        'Sector de prueba',
        'Estante de prueba',
        'Armario de prueba',
        'Cajón de prueba',
        'Este registro será eliminado al finalizar la prueba.'
    )
    RETURNING id INTO nuevo_id;

    RAISE NOTICE 'INSERT realizado. ID del objeto: %', nuevo_id;

    -- UPDATE
    UPDATE public.objetos
    SET nombre = 'Objeto de prueba SQL actualizado'
    WHERE id = nuevo_id
    RETURNING nombre INTO nombre_actualizado;

    RAISE NOTICE 'UPDATE realizado. Nuevo nombre: %', nombre_actualizado;

    -- DELETE
    DELETE FROM public.objetos
    WHERE id = nuevo_id
    RETURNING id INTO id_eliminado;

    RAISE NOTICE 'DELETE realizado. ID eliminado: %', id_eliminado;
END $$;

-- REVERSIÓN DE LA TRANSACCIÓN:
-- No se conserva el objeto utilizado para la prueba.
ROLLBACK;

-- 10. CONSULTAR PERFILES RELACIONADOS CON USUARIOS AUTENTICADOS
-- Relación: perfiles.id = auth.users.id

SELECT
    p.id,
    p.nombre,
    p.apellido,
    p.tipo_integrante,
    u.email
FROM public.perfiles AS p
INNER JOIN auth.users AS u
    ON p.id = u.id
ORDER BY p.apellido, p.nombre;

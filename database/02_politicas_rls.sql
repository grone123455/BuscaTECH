
-- ============================================
-- BUSCATECH
-- Archivo: 02_politicas_rls.sql
-- Habilitación y políticas de seguridad RLS
-- ============================================

-- ============================================
-- 1. HABILITAR ROW LEVEL SECURITY
-- ============================================

ALTER TABLE public.objetos
ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.perfiles
ENABLE ROW LEVEL SECURITY;


-- ============================================
-- 2. ELIMINAR POLÍTICAS ANTERIORES
-- Permite volver a ejecutar el script sin
-- generar errores por políticas duplicadas.
-- ============================================

DROP POLICY IF EXISTS "Usuarios registrados pueden agregar objetos"
ON public.objetos;

DROP POLICY IF EXISTS "Usuarios registrados pueden editar objetos"
ON public.objetos;

DROP POLICY IF EXISTS "Usuarios registrados pueden eliminar objetos"
ON public.objetos;

DROP POLICY IF EXISTS "Usuarios registrados pueden ver objetos"
ON public.objetos;

DROP POLICY IF EXISTS "Visitantes pueden consultar objetos"
ON public.objetos;

DROP POLICY IF EXISTS "Cada usuario puede crear su perfil"
ON public.perfiles;

DROP POLICY IF EXISTS "Cada usuario puede editar su perfil"
ON public.perfiles;

DROP POLICY IF EXISTS "Cada usuario puede ver su perfil"
ON public.perfiles;


-- ============================================
-- 3. POLÍTICAS DE LA TABLA OBJETOS
-- ============================================

-- Los usuarios registrados pueden agregar objetos.
CREATE POLICY "Usuarios registrados pueden agregar objetos"
ON public.objetos
FOR INSERT
TO authenticated
WITH CHECK (true);

-- Los usuarios registrados pueden editar objetos.
CREATE POLICY "Usuarios registrados pueden editar objetos"
ON public.objetos
FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

-- Los usuarios registrados pueden eliminar objetos.
CREATE POLICY "Usuarios registrados pueden eliminar objetos"
ON public.objetos
FOR DELETE
TO authenticated
USING (true);

-- Los usuarios registrados pueden consultar objetos.
CREATE POLICY "Usuarios registrados pueden ver objetos"
ON public.objetos
FOR SELECT
TO authenticated
USING (true);

-- Los visitantes pueden consultar objetos.
CREATE POLICY "Visitantes pueden consultar objetos"
ON public.objetos
FOR SELECT
TO anon
USING (true);


-- ============================================
-- 4. POLÍTICAS DE LA TABLA PERFILES
-- ============================================

-- Cada usuario puede crear su propio perfil.
CREATE POLICY "Cada usuario puede crear su perfil"
ON public.perfiles
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

-- Cada usuario puede editar únicamente su perfil.
CREATE POLICY "Cada usuario puede editar su perfil"
ON public.perfiles
FOR UPDATE
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Cada usuario puede consultar únicamente su perfil.
CREATE POLICY "Cada usuario puede ver su perfil"
ON public.perfiles
FOR SELECT
TO authenticated
USING (auth.uid() = id);


-- ============================================
-- FIN DE LA CONFIGURACIÓN RLS
-- ============================================


# BuscaTECH — Documentación de pruebas

## 1. Conexión con Supabase

**Objetivo:** comprobar que la aplicación se conecta correctamente con Supabase.

**Resultado:** correcto. La aplicación obtiene información real de la base de datos.

## 2. Autenticación

| Prueba | Resultado |
|---|---|
| Registro de usuario | Correcto |
| Inicio de sesión | Correcto |
| Cierre de sesión | Correcto |
| Creación automática del perfil | Correcto |

## 3. Operaciones CRUD

| Operación | Resultado |
|---|---|
| Crear objeto | Correcto |
| Consultar objeto | Correcto |
| Editar objeto | Correcto |
| Eliminar objeto | Correcto |

## 4. Formularios y validaciones

**Prueba:** intentar guardar un objeto dejando vacíos los campos obligatorios.

**Resultado:** correcto. Se muestra un mensaje de validación y se impide guardar.

También se verificaron los mensajes de éxito al crear, editar y eliminar objetos.

## 5. Búsqueda y filtros

**Prueba:** buscar objetos y filtrar por especialidad.

**Resultado:** correcto. Los resultados se obtienen de los datos almacenados en Supabase.

## 6. Seguridad y permisos RLS

| Prueba | Resultado |
|---|---|
| Visitante consulta el catálogo | Correcto |
| Visitante consulta detalles | Correcto |
| Visitante intenta agregar objetos | Bloqueado |
| Visitante intenta editar objetos | Bloqueado |
| Visitante intenta eliminar objetos | Bloqueado |
| Inserción anónima mediante SQL | Bloqueada |

Las políticas RLS permiten que los usuarios autenticados gestionen objetos y que cada usuario acceda únicamente a su propio perfil.

## 7. Observaciones

Las pruebas funcionales principales fueron realizadas correctamente.

Las pruebas SQL de UPDATE y DELETE con rol anónimo no fueron concluyentes y requieren una verificación adicional.

## 8. Pendientes

- Completar las verificaciones SQL de seguridad.
- Incorporar evidencias de las pruebas realizadas.
- Revisar los 18 requisitos de la Etapa 6.
- Completar la documentación general de las Etapas 1 a 5.


# BuscaTECH — Documentación de pruebas

## 1. Conexión con Supabase

**Objetivo:** comprobar que la aplicación se conecta correctamente con Supabase y puede recuperar información almacenada en la base de datos.

**Procedimiento:**
1. Iniciar la aplicación.
2. Acceder al catálogo de objetos.
3. Comprobar que se muestran los registros almacenados en Supabase.

**Resultado esperado:** la aplicación establece la conexión y muestra los datos de la base de datos.

**Resultado obtenido:** correcto. La aplicación obtiene y muestra información real almacenada en Supabase.

**Estado:** Aprobado.

## 2. Autenticación

**Objetivo:** verificar el funcionamiento del registro, inicio y cierre de sesión mediante Supabase Auth.

| Prueba | Procedimiento y resultado obtenido |
|---|---|
| Registro de usuario | Se completó el formulario con datos válidos. La cuenta se creó correctamente. |
| Validación del registro | Se intentó registrar un usuario dejando un campo obligatorio vacío. Se mostró la validación y se impidió continuar. |
| Inicio de sesión correcto | Se ingresó con una cuenta registrada. El acceso se realizó correctamente. |
| Inicio de sesión incorrecto | Se ingresaron credenciales incorrectas. Se mostró un mensaje de error y no se permitió el acceso. |
| Cierre de sesión | Se cerró la sesión desde la navegación. La aplicación volvió al estado de visitante. |
| Creación automática del perfil | Se verificó la existencia de los perfiles vinculados a las cuentas registradas. |

**Resultado general:** las pruebas realizadas fueron satisfactorias.

**Estado:** Aprobado.

## 3. Operaciones CRUD

**Objetivo:** comprobar que las operaciones de gestión de objetos se realizan correctamente y se reflejan en Supabase.

| Operación | Procedimiento | Resultado obtenido |
|---|---|---|
| Crear objeto | Completar el formulario y guardar un nuevo objeto. | Correcto. El objeto se guarda en la base de datos. |
| Consultar objeto | Acceder al catálogo y abrir el detalle de un objeto. | Correcto. Se muestran los datos almacenados. |
| Editar objeto | Modificar los datos de un objeto existente y guardar los cambios. | Correcto. Los cambios se reflejan en la base de datos. |
| Eliminar objeto | Ejecutar la opción de eliminación de un objeto. | Correcto. El registro se elimina de la base de datos. |

**Resultado general:** las cuatro operaciones CRUD funcionan correctamente.

**Estado:** Aprobado.

## 4. Formularios y validaciones

**Objetivo:** comprobar que los formularios validan los campos obligatorios y muestran mensajes al realizar operaciones.

**Pruebas realizadas:**

- Intentar guardar un objeto dejando vacío el campo Nombre.
- Intentar guardar un objeto sin seleccionar la Especialidad.
- Completar los campos obligatorios y guardar el objeto.
- Modificar un objeto y guardar los cambios.
- Verificar los mensajes de confirmación al crear, modificar y eliminar objetos.

**Resultado esperado:** impedir el envío de formularios incompletos y mostrar mensajes que informen el resultado de las operaciones.

**Resultado obtenido:** correcto. Las validaciones impiden guardar información incompleta y se muestran los mensajes de confirmación correspondientes.

**Estado:** Aprobado.

## 5. Búsqueda, filtros y ordenamiento

**Objetivo:** comprobar que las herramientas de consulta funcionan con los datos almacenados en Supabase.

| Prueba | Resultado obtenido |
|---|---|
| Búsqueda por nombre | Correcto. Se muestran los objetos que coinciden con la búsqueda. |
| Filtro por especialidad Mecánica | Correcto. Se muestran los objetos de esa especialidad. |
| Filtro por especialidad Electricidad | Correcto. Se muestran los objetos de esa especialidad. |
| Orden alfabético A-Z | Correcto. Los objetos se ordenan alfabéticamente. |
| Orden alfabético Z-A | Correcto. Los objetos se ordenan en orden alfabético inverso. |

**Resultado general:** las consultas se realizan sobre los datos reales almacenados en Supabase.

**Estado:** Aprobado.

## 6. Seguridad y permisos RLS

**Objetivo:** verificar que las políticas de seguridad de Supabase controlan el acceso a la información y las operaciones de gestión.

### 6.1. Pruebas desde la aplicación

| Prueba | Resultado obtenido |
|---|---|
| Visitante consulta el catálogo | Correcto. |
| Visitante consulta detalles | Correcto. |
| Visitante intenta agregar objetos desde el catálogo | Bloqueado. No se muestran las opciones de gestión. |
| Visitante intenta acceder directamente a la ruta `/objetos/nuevo` | Correcto. La aplicación redirige al inicio de sesión. |
| Visitante intenta acceder directamente a la ruta `/objetos/:id/editar` | Correcto. La aplicación redirige al inicio de sesión. |
| Usuario autenticado accede a la ruta de alta | Permitido. Se muestra el formulario de creación. |
| Usuario autenticado accede a la ruta de edición | Permitido. Se muestra el formulario de edición. |
| Usuario autenticado agrega objetos | Permitido. |
| Usuario autenticado modifica objetos | Permitido. |
| Usuario autenticado elimina objetos | Permitido. |

### 6.2. Verificaciones en Supabase

Se habilitó Row Level Security (RLS) en las tablas `objetos` y `perfiles`.

Se comprobó que ambas tablas tienen RLS habilitado mediante una consulta a `pg_tables`.

También se verificaron las políticas configuradas:

- Los visitantes pueden consultar los objetos.
- Los usuarios autenticados pueden consultar y gestionar objetos.
- Cada usuario puede acceder a su propio perfil según su identificador de autenticación.
- Las políticas de perfiles restringen las operaciones a la identidad correspondiente.

**Resultado obtenido:** las pruebas realizadas desde la aplicación fueron satisfactorias. La inserción anónima mediante SQL fue bloqueada.

**Observación:** las pruebas SQL de UPDATE y DELETE utilizando el rol anónimo no fueron concluyentes y requieren una verificación adicional.

**Estado:** Parcialmente aprobado. Pendiente completar las verificaciones SQL indicadas.

## 7. Pruebas SQL

**Objetivo:** comprobar las operaciones principales sobre las tablas de la base de datos.

Se ejecutaron los scripts SQL de pruebas preparados para el proyecto.

| Operación o consulta | Resultado |
|---|---|
| SELECT | Correcto. Se recuperaron registros de las tablas. |
| INSERT | Ejecutado dentro de una transacción de prueba. |
| UPDATE | Ejecutado dentro de una transacción de prueba. |
| DELETE | Ejecutado dentro de una transacción de prueba. |
| JOIN entre perfiles y usuarios | Correcto. Se recuperaron los perfiles vinculados a las cuentas de autenticación. |

**Observación:** las operaciones de prueba INSERT, UPDATE y DELETE se ejecutaron dentro de una transacción finalizada con `ROLLBACK`, por lo que los cambios de prueba no quedaron guardados permanentemente.

**Estado:** Ejecutado correctamente. Las verificaciones específicas de seguridad con rol anónimo siguen pendientes.

## 8. Observaciones generales

Las pruebas funcionales principales de BuscaTECH fueron realizadas correctamente.

Se comprobó la conexión con Supabase, la autenticación de usuarios, las operaciones CRUD, las validaciones de formularios, la búsqueda, los filtros, el ordenamiento y las restricciones de acceso desde la aplicación.

También se comprobó que las rutas de creación y edición de objetos requieren una sesión iniciada.

La base de datos cuenta con políticas RLS habilitadas para las tablas correspondientes.

Se identificó que todavía es necesario completar las verificaciones SQL de UPDATE y DELETE con el rol anónimo y reunir evidencias de las pruebas realizadas.

## 9. Pendientes

- Completar las verificaciones SQL de seguridad para UPDATE y DELETE con el rol anónimo.
- Incorporar capturas de pantalla como evidencia de las pruebas realizadas.
- Revisar la correspondencia entre la implementación y los 18 requisitos de la Etapa 6.
- Verificar la coherencia de la documentación de las Etapas 1 a 5 con el estado actual del proyecto.

## 10. Conclusión

Las pruebas realizadas permitieron comprobar que las funcionalidades principales de BuscaTECH funcionan correctamente y que la aplicación está integrada con Supabase.

El sistema permite consultar el catálogo, buscar y filtrar objetos, registrar e iniciar sesión con usuarios, y realizar operaciones de alta, modificación y eliminación de objetos.

Además, se verificó que las rutas de gestión están protegidas y requieren autenticación.

Quedan pendientes algunas verificaciones específicas de seguridad mediante SQL y la incorporación de evidencias para completar la documentación de la etapa.

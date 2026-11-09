
<script setup>
import { onMounted, onUnmounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { supabase } from '../services/supabase'
import { MODO_PRUEBA } from '../data/modoPrueba'
import { objetosEstado } from '../data/objetosEstado'
import EstadoMensaje from '../components/EstadoMensaje.vue'

const route = useRoute()
const router = useRouter()

const objeto = ref(null)
const usuario = ref(null)
const cargando = ref(true)
const eliminando = ref(false)
const error = ref('')
let suscripcionAuth = null

async function cargarObjeto() {
  cargando.value = true
  error.value = ''
  objeto.value = null

  const id = route.params.id

  try {
    if (MODO_PRUEBA) {
      objeto.value = objetosEstado.value.find(
        (item) => String(item.id) === String(id)
      ) ?? null
    } else {
      if (!/^\d+$/.test(String(id))) {
        error.value = 'El identificador del objeto no es válido.'
        return
      }

      const { data, error: errorObjeto } = await supabase
        .from('objetos')
        .select(
          'id, nombre, descripcion, especialidad, sector, estante, armario, cajon, observaciones, imagen_url, creado_en'
        )
        .eq('id', id)
        .maybeSingle()

      if (errorObjeto) throw errorObjeto

      objeto.value = data
    }

    if (!objeto.value) {
      error.value = 'No se encontró el objeto solicitado.'
    }
  } catch (err) {
    console.error('Error al cargar el objeto:', err)
    error.value = 'No se pudo cargar la información del objeto.'
  } finally {
    cargando.value = false
  }
}

function volverAlCatalogo() {
  router.push('/catalogo')
}

async function comprobarSesion() {
  if (MODO_PRUEBA) {
    return Boolean(usuario.value)
  }

  const { data, error: errorSesion } = await supabase.auth.getSession()

  if (errorSesion || !data.session) {
    usuario.value = null
    return false
  }

  usuario.value = data.session.user
  return true
}

async function editarObjeto() {
  const tieneSesion = await comprobarSesion()

  if (!tieneSesion) return

  router.push(`/objetos/${route.params.id}/editar`)
}

async function eliminarObjeto() {
  if (eliminando.value || !objeto.value) return

  const tieneSesion = await comprobarSesion()

  if (!tieneSesion) {
    alert('Debés iniciar sesión para eliminar objetos.')
    return
  }

  const confirmar = window.confirm(
    `¿Estás seguro de que querés eliminar "${objeto.value.nombre}"? Esta acción no se puede deshacer.`
  )

  if (!confirmar) return

  eliminando.value = true

  try {
    if (MODO_PRUEBA) {
      objetosEstado.value = objetosEstado.value.filter(
        (item) => String(item.id) !== String(route.params.id)
      )
    } else {
      const { data, error: errorEliminacion } = await supabase
        .from('objetos')
        .delete()
        .eq('id', route.params.id)
        .select('id')
        .maybeSingle()

      if (errorEliminacion) throw errorEliminacion

      if (!data) {
        throw new Error(
          'No se pudo eliminar el objeto. Verificá tus permisos de acceso.'
        )
      }

      if (objeto.value.imagen_url) {
        try {
          const marcador = '/fotografias-objetos/'
          const parteUrl = objeto.value.imagen_url.split(marcador)[1]

          if (parteUrl) {
            const rutaImagen = decodeURIComponent(
              parteUrl.split('?')[0]
            )

            const { error: errorImagen } = await supabase.storage
              .from('fotografias-objetos')
              .remove([rutaImagen])

            if (errorImagen) {
              console.error(
                'No se pudo eliminar la fotografía:',
                errorImagen
              )
            }
          }
        } catch (err) {
          console.error('Error al eliminar la fotografía:', err)
        }
      }
    }

    router.push({
      path: '/catalogo',
      query: {
        mensaje: 'Objeto eliminado correctamente.',
      },
    })
  } catch (err) {
    console.error('Error al eliminar el objeto:', err)

    alert(
      err.message || 'No se pudo eliminar el objeto. Intentá nuevamente.'
    )
  } finally {
    eliminando.value = false
  }
}

function formatearFecha(fecha) {
  if (!fecha) return ''

  return new Date(fecha).toLocaleDateString('es-AR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
  })
}

onMounted(async () => {
  if (MODO_PRUEBA) {
    usuario.value = { modoPrueba: true }
  } else {
    const { data } = await supabase.auth.getSession()
    usuario.value = data.session?.user ?? null

    const { data: authData } = supabase.auth.onAuthStateChange(
      (_evento, session) => {
        usuario.value = session?.user ?? null
      }
    )

    suscripcionAuth = authData.subscription
  }

  await cargarObjeto()
})

watch(() => route.params.id, cargarObjeto)

onUnmounted(() => {
  suscripcionAuth?.unsubscribe()
})
</script>

<template>
  <main class="detail-page page-width">
    <div class="breadcrumb">
      <RouterLink to="/catalogo">Catálogo</RouterLink>
      <span aria-hidden="true">/</span>
      <span>Detalle del objeto</span>
    </div>

    <EstadoMensaje
      v-if="cargando"
      tipo="info"
      titulo="Cargando objeto"
      mensaje="Esperá un momento mientras recuperamos la información."
    />

    <section v-else-if="error" class="detail-empty-card">
      <div class="detail-empty-symbol">
        <span>!</span>
      </div>

      <h2>No se pudo abrir el objeto</h2>
      <p>{{ error }}</p>

      <div class="detail-actions">
        <button
          class="button button-secondary"
          @click="volverAlCatalogo"
        >
          Volver al catálogo
        </button>
      </div>
    </section>

    <article v-else-if="objeto" class="object-detail">
      <div class="object-detail-heading">
        <div>
          <p class="eyebrow">INVENTARIO ESCOLAR / EEST N.º 1</p>
          <h1>{{ objeto.nombre }}</h1>
          <span class="catalog-card-category">
            {{ objeto.especialidad }}
          </span>
        </div>

        <div class="detail-actions">
          <button
            class="button button-secondary"
            @click="volverAlCatalogo"
          >
            Volver
          </button>

          <button
            v-if="usuario"
            class="button button-primary"
            @click="editarObjeto"
          >
            Modificar objeto
          </button>

          <button
            v-if="usuario"
            class="button button-secondary"
            :disabled="eliminando"
            @click="eliminarObjeto"
          >
            {{ eliminando ? 'Eliminando...' : 'Eliminar objeto' }}
          </button>
        </div>
      </div>

      <div class="object-detail-grid">
        <div class="object-detail-image">
          <img
            v-if="objeto.imagen_url"
            :src="objeto.imagen_url"
            :alt="`Fotografía de ${objeto.nombre}`"
          />

          <div v-else class="object-no-image">
            Sin fotografía disponible
          </div>
        </div>

        <div class="object-detail-information">
          <section class="detail-section">
            <h2>Descripción</h2>
            <p>
              {{ objeto.descripcion || 'Sin descripción disponible.' }}
            </p>
          </section>

          <section class="detail-section">
            <h2>Ubicación en el pañol</h2>

            <dl class="detail-data">
              <div>
                <dt>Sector</dt>
                <dd>{{ objeto.sector || 'Sin especificar' }}</dd>
              </div>

              <div>
                <dt>Estante</dt>
                <dd>{{ objeto.estante || 'Sin especificar' }}</dd>
              </div>

              <div>
                <dt>Armario</dt>
                <dd>{{ objeto.armario || 'Sin especificar' }}</dd>
              </div>

              <div>
                <dt>Cajón</dt>
                <dd>{{ objeto.cajon || 'Sin especificar' }}</dd>
              </div>
            </dl>
          </section>

          <section class="detail-section">
            <h2>Observaciones</h2>
            <p>
              {{ objeto.observaciones || 'Sin observaciones adicionales.' }}
            </p>
          </section>

          <p v-if="objeto.creado_en" class="detail-date">
            Registrado el {{ formatearFecha(objeto.creado_en) }}
          </p>
        </div>
      </div>
    </article>
  </main>
</template>

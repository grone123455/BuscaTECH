
<script setup>
import { onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { supabase } from '../services/supabase'
import { objetosEstado } from '../data/objetosEstado'
import { MODO_PRUEBA } from '../data/modoPrueba'
import PageHeading from '../components/PageHeading.vue'

const route = useRoute()
const router = useRouter()

const objeto = ref(null)
const cargando = ref(true)
const error = ref('')
const eliminando = ref(false)
const errorEliminacion = ref('')

async function cargarObjeto() {
  cargando.value = true
  error.value = ''
  objeto.value = null

  const id = String(route.params.id)

  if (MODO_PRUEBA) {
    const encontrado = objetosEstado.value.find(
      (item) => String(item.id) === id,
    )

    if (!encontrado) {
      error.value = 'No existe un objeto de prueba con ese identificador.'
    } else {
      objeto.value = encontrado
    }

    cargando.value = false
    return
  }

  if (!id || !/^\d+$/.test(id)) {
    error.value = 'El identificador del objeto no es válido.'
    cargando.value = false
    return
  }

  try {
    const { data, error: errorConsulta } = await supabase
      .from('objetos')
      .select(
        'id, nombre, descripcion, especialidad, sector, estante, armario, cajon, observaciones, imagen_url, creado_en',
      )
      .eq('id', id)
      .maybeSingle()

    if (errorConsulta) throw errorConsulta

    if (!data) {
      error.value = 'No existe un objeto con ese identificador.'
      return
    }

    objeto.value = data
  } catch (e) {
    console.error('Error al cargar el objeto:', e)
    error.value =
      'No se pudo cargar el objeto. Revisá la conexión e intentá nuevamente.'
  } finally {
    cargando.value = false
  }
}

async function eliminarObjeto() {
  const confirmar = window.confirm(
    `¿Estás seguro de que querés eliminar "${objeto.value.nombre}"? Esta acción no se puede deshacer.`,
  )

  if (!confirmar) return

  eliminando.value = true
  errorEliminacion.value = ''

  try {
    if (MODO_PRUEBA) {
      const indice = objetosEstado.value.findIndex(
        (item) => String(item.id) === String(objeto.value.id),
      )

      if (indice === -1) {
        throw new Error('No se encontró el objeto.')
      }

      objetosEstado.value.splice(indice, 1)
    } else {
      const { data, error: errorEliminar } = await supabase
        .from('objetos')
        .delete()
        .eq('id', objeto.value.id)
        .select('id')
        .maybeSingle()

      if (errorEliminar) throw errorEliminar

      if (!data) {
        throw new Error('No se pudo encontrar el objeto para eliminarlo.')
      }
    }

    await router.push({
      path: '/catalogo',
      query: {
        mensaje: 'Objeto eliminado correctamente.',
      },
    })
  } catch (e) {
    console.error('Error al eliminar el objeto:', e)
    errorEliminacion.value =
      'No se pudo eliminar el objeto. Revisá los permisos y la conexión e intentá nuevamente.'
  } finally {
    eliminando.value = false
  }
}

onMounted(cargarObjeto)
watch(() => route.params.id, cargarObjeto)
</script>

<template>
  <section class="detail-page page-width">
    <div v-if="cargando" class="detail-empty-card" aria-live="polite">
      <h1>Cargando objeto…</h1>
      <p>Estamos preparando la información del pañol.</p>
    </div>

    <div v-else-if="error" class="detail-empty-card" role="alert">
      <p class="eyebrow">FICHA DEL PAÑOL</p>
      <h1>No se pudo mostrar el objeto</h1>
      <p>{{ error }}</p>

      <div class="detail-actions">
        <RouterLink to="/catalogo" class="button button-secondary">
          Volver al catálogo
        </RouterLink>
      </div>
    </div>

    <template v-else-if="objeto">
      <PageHeading
        class="form-intro"
        :breadcrumb="[
          { label: 'Catálogo', to: '/catalogo' },
          { label: 'Detalle' },
        ]"
        :eyebrow="`FICHA DEL PAÑOL / ${objeto.id}`"
        :title="objeto.nombre"
        :description="objeto.especialidad"
      >
        <template #actions>
          <RouterLink
            v-if="!MODO_PRUEBA"
            :to="`/objetos/${objeto.id}/editar`"
            class="button button-primary"
          >
            Modificar objeto
          </RouterLink>

          <button
            v-if="!MODO_PRUEBA"
            type="button"
            class="button button-secondary"
            :disabled="eliminando"
            @click="eliminarObjeto"
          >
            {{ eliminando ? 'Eliminando...' : 'Eliminar objeto' }}
          </button>
        </template>
      </PageHeading>

      <p v-if="errorEliminacion" class="detail-error" role="alert">
        {{ errorEliminacion }}
      </p>

      <div class="form-layout">
        <article class="form-card">
          <h2 class="form-section-title">
            <span>01</span> Información del objeto
          </h2>

          <div class="form-grid">
            <div class="form-field is-wide">
              <label>Descripción</label>
              <p>{{ objeto.descripcion || 'Sin descripción' }}</p>
            </div>

            <div class="form-field">
              <label>Especialidad</label>
              <p>{{ objeto.especialidad }}</p>
            </div>
          </div>

          <h2 class="form-section-title form-section-spaced">
            <span>02</span> Ubicación en el pañol
          </h2>

          <div class="form-grid">
            <div class="form-field">
              <label>Sector</label>
              <p>{{ objeto.sector || 'No especificado' }}</p>
            </div>

            <div class="form-field">
              <label>Estante</label>
              <p>{{ objeto.estante || 'No especificado' }}</p>
            </div>

            <div class="form-field">
              <label>Armario</label>
              <p>{{ objeto.armario || 'No especificado' }}</p>
            </div>

            <div class="form-field">
              <label>Cajón</label>
              <p>{{ objeto.cajon || 'No especificado' }}</p>
            </div>
          </div>

          <h2 class="form-section-title form-section-spaced">
            <span>03</span> Observaciones
          </h2>

          <p>{{ objeto.observaciones || 'Sin observaciones' }}</p>

          <div class="form-actions">
            <RouterLink to="/catalogo" class="button button-secondary">
              Volver al catálogo
            </RouterLink>
          </div>
        </article>

        <aside class="form-aside">
          <p class="aside-label">RESUMEN DE LA FICHA</p>
          <p><strong>Identificador:</strong> {{ objeto.id }}</p>
          <p><strong>Especialidad:</strong> {{ objeto.especialidad }}</p>
          <p>
            <strong>Ubicación:</strong>
            {{
              [objeto.sector, objeto.estante, objeto.armario, objeto.cajon]
                .filter(Boolean)
                .join(' · ') || 'No especificada'
            }}
          </p>
        </aside>
      </div>
    </template>
  </section>
</template>

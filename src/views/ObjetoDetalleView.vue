
<script setup>
import { onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { supabase } from '../services/supabase'

const route = useRoute()

const objeto = ref(null)
const cargando = ref(true)
const error = ref('')

async function cargarObjeto() {
  cargando.value = true
  error.value = ''
  objeto.value = null

  const id = route.params.id

  if (!id || !/^\d+$/.test(String(id))) {
    error.value = 'El identificador del objeto no es válido.'
    cargando.value = false
    return
  }

  try {
    const { data, error: errorConsulta } = await supabase
      .from('objetos')
      .select(
        'id, nombre, descripcion, especialidad, sector, estante, armario, cajon, observaciones, imagen_url, creado_en'
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
    error.value = 'No se pudo cargar el objeto. Revisá la conexión e intentá nuevamente.'
  } finally {
    cargando.value = false
  }
}

onMounted(cargarObjeto)

watch(() => route.params.id, cargarObjeto)
</script>

<template>
  <section class="detail-page page-width" aria-labelledby="detail-title">
    <div class="breadcrumb">
      <RouterLink to="/catalogo">Catálogo</RouterLink>
      <span aria-hidden="true">/</span>
      <span>Detalle</span>
    </div>

    <div v-if="cargando" class="detail-empty-card" aria-live="polite">
      <h1 id="detail-title">Cargando objeto…</h1>
      <p>Estamos consultando la información del pañol.</p>
    </div>

    <div v-else-if="error" class="detail-empty-card" role="alert">
      <p class="eyebrow">FICHA DEL PAÑOL</p>
      <h1 id="detail-title">No se pudo mostrar el objeto</h1>
      <p>{{ error }}</p>

      <div class="detail-actions">
        <RouterLink to="/catalogo" class="button button-secondary">
          Volver al catálogo
        </RouterLink>
      </div>
    </div>

    <template v-else-if="objeto">
      <header class="page-heading form-intro">
        <div>
          <p class="eyebrow">
            FICHA DEL PAÑOL <span class="eyebrow-divider">/</span>
            {{ objeto.id }}
          </p>
          <h1 id="detail-title">{{ objeto.nombre }}</h1>
          <p class="page-intro">{{ objeto.especialidad }}</p>
        </div>

        <RouterLink
          :to="`/objetos/${objeto.id}/editar`"
          class="button button-primary"
        >
          Modificar objeto
        </RouterLink>
      </header>

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


<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '../services/supabase'
import PageHeading from '../components/PageHeading.vue'
import EstadoMensaje from '../components/EstadoMensaje.vue'

const router = useRouter()

const mensajeExito = computed(
  () => router.currentRoute.value.query.mensaje || ''
)

const objetos = ref([])
const categorias = ref(['Todas'])
const categoriaSeleccionada = ref('Todas')
const busqueda = ref('')
const ordenSeleccionado = ref('asc')
const cargando = ref(true)
const error = ref('')

const objetosFiltrados = computed(() => {
  return objetos.value.filter((objeto) => {
    const coincideCategoria =
      categoriaSeleccionada.value === 'Todas' ||
      objeto.especialidad === categoriaSeleccionada.value

    const texto = busqueda.value.toLowerCase().trim()

    const coincideBusqueda =
      objeto.nombre.toLowerCase().includes(texto) ||
      (objeto.descripcion || '').toLowerCase().includes(texto) ||
      (objeto.especialidad || '').toLowerCase().includes(texto) ||
      (objeto.sector || '').toLowerCase().includes(texto)

    return coincideCategoria && coincideBusqueda
  })
})

const objetosOrdenados = computed(() => {
  return [...objetosFiltrados.value].sort((a, b) => {
    return ordenSeleccionado.value === 'asc'
      ? a.nombre.localeCompare(b.nombre)
      : b.nombre.localeCompare(a.nombre)
  })
})

async function cargarCatalogo() {
  cargando.value = true
  error.value = ''

  try {
    const { data, error: errorObjetos } = await supabase
      .from('objetos')
      .select(
        'id, nombre, descripcion, especialidad, sector, estante, armario, cajon, observaciones, imagen_url, creado_en'
      )
      .order('nombre', { ascending: true })

    if (errorObjetos) {
      throw errorObjetos
    }

    objetos.value = data ?? []

    const especialidades = [
      ...new Set(
        objetos.value
          .map((objeto) => objeto.especialidad)
          .filter(Boolean)
      )
    ]

    categorias.value = [
      'Todas',
      ...especialidades.sort((a, b) => a.localeCompare(b))
    ]

    if (!categorias.value.includes(categoriaSeleccionada.value)) {
      categoriaSeleccionada.value = 'Todas'
    }
  } catch (err) {
    console.error('Error al cargar el catálogo:', err)
    error.value = 'No se pudo cargar el catálogo. Intentá nuevamente.'
  } finally {
    cargando.value = false
  }
}

function verObjeto(id) {
  router.push(`/objetos/${id}`)
}

function agregarObjeto() {
  router.push('/objetos/nuevo')
}

onMounted(cargarCatalogo)
</script>

<template>
  <main class="catalog-page page-width">
    <div class="breadcrumb">
      <span>BuscaTECH</span>
      <span>/</span>
      <span>Catálogo</span>
    </div>

    <PageHeading
      eyebrow="INVENTARIO ESCOLAR / EEST N.º 1"
      title="Catálogo del pañol"
      description="Buscá herramientas, materiales y equipos y consultá dónde se encuentran."
    />

    <EstadoMensaje
      v-if="mensajeExito"
      tipo="success"
      titulo="Operación realizada"
      :mensaje="mensajeExito"
    />

    <section class="catalog-controls">
      <div class="search-box">
        <input
          v-model="busqueda"
          type="search"
          placeholder="Buscar herramientas, materiales..."
          aria-label="Buscar objetos"
        />
      </div>

      <button class="button button-primary catalog-add" @click="agregarObjeto">
        <span>+</span>
        Agregar objeto
      </button>
    </section>

    <section class="filter-row">
      <span class="filter-label">Especialidad</span>

      <div class="filter-options">
        <button
          v-for="categoria in categorias"
          :key="categoria"
          class="filter-chip"
          :class="{ 'is-selected': categoriaSeleccionada === categoria }"
          @click="categoriaSeleccionada = categoria"
        >
          {{ categoria }}
        </button>
      </div>
    </section>

    <section class="catalog-sort">
      <label for="orden-objetos">Ordenar por</label>

      <select id="orden-objetos" v-model="ordenSeleccionado">
        <option value="asc">Nombre: A a Z</option>
        <option value="desc">Nombre: Z a A</option>
      </select>
    </section>

    <div class="catalog-results-bar">
      <span class="results-label">
        <span class="results-dot"></span>
        Resultados
      </span>

      <span class="results-count">
        {{ objetosOrdenados.length }}
        {{ objetosOrdenados.length === 1 ? 'objeto' : 'objetos' }}
      </span>
    </div>

    <EstadoMensaje
      v-if="cargando"
      tipo="info"
      titulo="Cargando catálogo"
      mensaje="Esperá un momento mientras cargamos los objetos."
    />

    <EstadoMensaje
      v-else-if="error"
      tipo="error"
      titulo="No se pudo cargar el catálogo"
      :mensaje="error"
    />

    <section v-else-if="objetosOrdenados.length" class="catalog-grid">
      <article
        v-for="objeto in objetosOrdenados"
        :key="objeto.id"
        class="catalog-card"
        @click="verObjeto(objeto.id)"
      >
        <img
          v-if="objeto.imagen_url"
          :src="objeto.imagen_url"
          :alt="`Fotografía de ${objeto.nombre}`"
          class="catalog-card-image"
        />

        <div class="catalog-card-content">
          <span class="catalog-card-category">
            {{ objeto.especialidad }}
          </span>

          <h2>{{ objeto.nombre }}</h2>

          <p v-if="objeto.descripcion">
            {{ objeto.descripcion }}
          </p>

          <p class="catalog-card-location">
            Sector: {{ objeto.sector || 'Sin especificar' }}
            · Estante: {{ objeto.estante || 'Sin especificar' }}
            · Armario: {{ objeto.armario || 'Sin especificar' }}
            <span v-if="objeto.cajon">
              · Cajón: {{ objeto.cajon }}
            </span>
          </p>
        </div>
      </article>
    </section>

    <section v-else class="catalog-empty">
      <div class="empty-illustration">
        <div class="empty-grid"></div>
        <div class="empty-shelf"></div>
        <div class="empty-tool"></div>
      </div>

      <h2>No hay objetos disponibles</h2>

      <p class="empty-copy">
        No se encontraron objetos con los filtros seleccionados.
      </p>

      <button class="text-button" @click="agregarObjeto">
        Agregar el primer objeto
      </button>
    </section>

    <p class="catalog-footnote">
      BuscaTECH · Inventario escolar
    </p>
  </main>
</template>

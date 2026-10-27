
<script setup>
import { computed, onMounted, ref } from 'vue'
import { supabase } from '../services/supabase'
import { objetosPrueba } from '../data/objetos'
import { MODO_PRUEBA } from '../data/modoPrueba'
import PageHeading from '../components/PageHeading.vue'
import EstadoMensaje from '../components/EstadoMensaje.vue'
import { objetosEstado } from '../data/objetosEstado'

const busqueda = ref('')
const categoriaSeleccionada = ref('Todas')
const categorias = ref(['Todas'])
const objetos = ref([])
const cargando = ref(true)
const error = ref('')

const tieneFiltros = computed(
  () =>
    busqueda.value.trim().length > 0 ||
    categoriaSeleccionada.value !== 'Todas',
)

const objetosFiltrados = computed(() => {
  const termino = busqueda.value.trim().toLowerCase()

  return objetos.value.filter((objeto) => {
    const coincideNombre = objeto.nombre.toLowerCase().includes(termino)
    const coincideCategoria =
      categoriaSeleccionada.value === 'Todas' ||
      objeto.especialidad === categoriaSeleccionada.value

    return coincideNombre && coincideCategoria
  })
})

async function cargarCatalogo() {
  cargando.value = true
  error.value = ''

  try {
    if (MODO_PRUEBA) {
      objetos.value = objetosEstado.value

      categorias.value = [
        'Todas',
        ...new Set(objetosPrueba.map((objeto) => objeto.especialidad)),
      ].sort((a, b) => {
        if (a === 'Todas') return -1
        if (b === 'Todas') return 1
        return a.localeCompare(b)
      })

      categoriaSeleccionada.value = 'Todas'
      return
    }

    const [respuestaObjetos, respuestaEspecialidades] = await Promise.all([
      supabase
        .from('objetos')
        .select(
          'id, nombre, descripcion, especialidad, sector, estante, armario, cajon, observaciones, imagen_url, creado_en',
        )
        .order('nombre', { ascending: true }),

      supabase
        .from('especialidades')
        .select('nombre')
        .order('nombre', { ascending: true }),
    ])

    if (respuestaObjetos.error) throw respuestaObjetos.error
    if (respuestaEspecialidades.error) throw respuestaEspecialidades.error

    objetos.value = respuestaObjetos.data ?? []

    categorias.value = [
      'Todas',
      ...(respuestaEspecialidades.data ?? []).map(
        (especialidad) => especialidad.nombre,
      ),
    ]

    if (!categorias.value.includes(categoriaSeleccionada.value)) {
      categoriaSeleccionada.value = 'Todas'
    }
  } catch (e) {
    console.error('Error al cargar el catálogo:', e)
    error.value =
      'No se pudo cargar el catálogo. Revisá la conexión e intentá nuevamente.'
  } finally {
    cargando.value = false
  }
}

function limpiarFiltros() {
  busqueda.value = ''
  categoriaSeleccionada.value = 'Todas'
}

onMounted(cargarCatalogo)
</script>

<template>
  <section class="catalog-page page-width" aria-labelledby="catalog-title">
    <PageHeading
      class="catalog-heading"
      :breadcrumb="[
        { label: 'BuscaTECH', to: '/' },
        { label: 'Catálogo' },
      ]"
      eyebrow="INVENTARIO ESCOLAR / EEST N.º 1"
      title="Catálogo del pañol"
      description="Encontrá herramientas, materiales y equipos por nombre, especialidad y ubicación."
    >
      <template #actions>
        <RouterLink
          to="/objetos/nuevo"
          class="button button-primary catalog-add"
        >
          <svg viewBox="0 0 20 20" aria-hidden="true">
            <path d="M10 4v12M4 10h12" />
          </svg>
          Registrar objeto
        </RouterLink>
      </template>
    </PageHeading>

    <section class="catalog-controls" aria-label="Buscar y filtrar objetos">
      <label class="search-box">
        <svg viewBox="0 0 20 20" aria-hidden="true">
          <circle cx="8.8" cy="8.8" r="5.8" />
          <path d="m13.2 13.2 4 4" />
        </svg>

        <span class="sr-only">Buscar por nombre</span>

        <input
          v-model="busqueda"
          type="search"
          placeholder="Buscar una herramienta, material o equipo…"
        />

        <button
          v-if="busqueda"
          class="search-clear"
          type="button"
          aria-label="Limpiar búsqueda"
          @click="busqueda = ''"
        >
          ×
        </button>

        <kbd v-else aria-hidden="true">Buscar</kbd>
      </label>

      <div class="filter-row">
        <span class="filter-label">Especialidad</span>

        <div
          class="filter-options"
          role="group"
          aria-label="Filtrar por especialidad"
        >
          <button
            v-for="categoria in categorias"
            :key="categoria"
            type="button"
            class="filter-chip"
            :class="{ 'is-selected': categoriaSeleccionada === categoria }"
            :aria-pressed="categoriaSeleccionada === categoria"
            @click="categoriaSeleccionada = categoria"
          >
            {{ categoria }}
          </button>
        </div>
      </div>
    </section>

    <div class="catalog-results-bar">
      <div class="results-label">
        <span class="results-dot"></span>
        <span>
          {{
            cargando
              ? 'Cargando catálogo…'
              : error
                ? 'Error de conexión'
                : MODO_PRUEBA
                  ? 'Modo de prueba'
                  : 'Catálogo conectado'
          }}
        </span>
      </div>

      <span class="results-count">
        {{ cargando ? '…' : `${objetosFiltrados.length} objetos` }}
      </span>
    </div>

    <EstadoMensaje
      v-if="error"
      tipo="error"
      titulo="Error al cargar el catálogo"
      :mensaje="error"
    />

    <EstadoMensaje
      v-else-if="cargando"
      tipo="info"
      titulo="Cargando catálogo"
      mensaje="Estamos preparando la información del pañol."
    />

    <section
      v-else-if="objetosFiltrados.length"
      class="catalog-grid"
      aria-label="Objetos del catálogo"
    >
      <article
        v-for="objeto in objetosFiltrados"
        :key="objeto.id"
        class="object-card"
      >
        <div class="object-card-content">
          <p class="eyebrow">{{ objeto.especialidad }}</p>
          <h2>{{ objeto.nombre }}</h2>

          <p v-if="objeto.descripcion">{{ objeto.descripcion }}</p>

          <p class="object-location">
            <strong>Ubicación:</strong>
            {{
              [objeto.sector, objeto.estante, objeto.armario, objeto.cajon]
                .filter(Boolean)
                .join(' · ') || 'Sin ubicación especificada'
            }}
          </p>

          <RouterLink :to="`/objetos/${objeto.id}`" class="text-button">
            Ver detalle <span aria-hidden="true">→</span>
          </RouterLink>
        </div>
      </article>
    </section>

    <section v-else class="catalog-empty" aria-live="polite">
      <div class="empty-illustration" aria-hidden="true">
        <div class="empty-grid"></div>
        <div class="empty-tool empty-tool-one"><span></span><i></i></div>
        <div class="empty-tool empty-tool-two"><span></span><i></i></div>
        <div class="empty-tool empty-tool-three"><span></span><i></i></div>
        <div class="empty-shelf"></div>
        <div class="empty-screw empty-screw-one"></div>
        <div class="empty-screw empty-screw-two"></div>
      </div>

      <p class="eyebrow">
        {{ tieneFiltros ? 'SIN COINCIDENCIAS' : 'CATÁLOGO VACÍO' }}
      </p>

      <h2>
        {{
          tieneFiltros
            ? 'No hay resultados para esta búsqueda'
            : 'El pañol empieza acá'
        }}
      </h2>

      <p class="empty-copy">
        {{
          tieneFiltros
            ? 'No hay objetos que coincidan con esos criterios. Probá otra búsqueda o limpiá los filtros.'
            : 'Todavía no hay objetos para mostrar.'
        }}
      </p>

      <button
        v-if="tieneFiltros"
        type="button"
        class="text-button"
        @click="limpiarFiltros"
      >
        Limpiar búsqueda y filtros <span aria-hidden="true">→</span>
      </button>

      <RouterLink
        v-else
        to="/objetos/nuevo"
        class="button button-secondary empty-action"
      >
        Registrar el primer objeto <span aria-hidden="true">→</span>
      </RouterLink>
    </section>

    <div class="catalog-footnote">
      <svg viewBox="0 0 20 20" aria-hidden="true">
        <circle cx="10" cy="10" r="7.2" />
        <path d="M10 9v4M10 6.4h.01" />
      </svg>

      <p>
        {{
          MODO_PRUEBA
            ? 'Se muestran datos ficticios locales. No se guardan en Supabase.'
            : 'Los datos se consultan directamente desde la base de datos de BuscaTECH.'
        }}
      </p>
    </div>
  </section>
</template>

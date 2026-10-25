<script setup>
import { computed, ref } from 'vue'

const busqueda = ref('')
const categoriaSeleccionada = ref('Todas')
const categorias = ['Todas', 'Mecánica', 'Electricidad', 'Otros']
const tieneFiltros = computed(() => busqueda.value.trim().length > 0 || categoriaSeleccionada.value !== 'Todas')

function limpiarFiltros() {
  busqueda.value = ''
  categoriaSeleccionada.value = 'Todas'
}
</script>

<template>
  <section class="catalog-page page-width" aria-labelledby="catalog-title">
    <div class="page-heading catalog-heading">
      <div>
        <div class="breadcrumb"><span>BuscaTECH</span><span aria-hidden="true">/</span><span>Catálogo</span></div>
        <p class="eyebrow">INVENTARIO ESCOLAR <span class="eyebrow-divider">/</span> EEST N.º 1</p>
        <h1 id="catalog-title">Catálogo del pañol</h1>
        <p class="page-intro">Encontrá herramientas, materiales y equipos por nombre, especialidad y ubicación.</p>
      </div>
      <RouterLink to="/objetos/nuevo" class="button button-primary catalog-add">
        <svg viewBox="0 0 20 20" aria-hidden="true"><path d="M10 4v12M4 10h12" /></svg>
        Registrar objeto
      </RouterLink>
    </div>

    <section class="catalog-controls" aria-label="Buscar y filtrar objetos">
      <label class="search-box">
        <svg viewBox="0 0 20 20" aria-hidden="true"><circle cx="8.8" cy="8.8" r="5.8"/><path d="m13.2 13.2 4 4"/></svg>
        <span class="sr-only">Buscar por nombre</span>
        <input v-model="busqueda" type="search" placeholder="Buscar una herramienta, material o equipo…" />
        <button v-if="busqueda" class="search-clear" type="button" aria-label="Limpiar búsqueda" @click="busqueda = ''">×</button>
        <kbd v-else aria-hidden="true">Buscar</kbd>
      </label>

      <div class="filter-row">
        <span class="filter-label">Especialidad</span>
        <div class="filter-options" role="group" aria-label="Filtrar por especialidad">
          <button
            v-for="categoria in categorias"
            :key="categoria"
            type="button"
            class="filter-chip"
            :class="{ 'is-selected': categoriaSeleccionada === categoria }"
            :aria-pressed="categoriaSeleccionada === categoria"
            @click="categoriaSeleccionada = categoria"
          >{{ categoria }}</button>
        </div>
      </div>
    </section>

    <div class="catalog-results-bar">
      <div class="results-label"><span class="results-dot"></span><span>Catálogo sin conexión a datos</span></div>
      <span class="results-count">0 objetos</span>
    </div>

    <section class="catalog-empty" aria-live="polite">
      <div class="empty-illustration" aria-hidden="true">
        <div class="empty-grid"></div>
        <div class="empty-tool empty-tool-one"><span></span><i></i></div>
        <div class="empty-tool empty-tool-two"><span></span><i></i></div>
        <div class="empty-tool empty-tool-three"><span></span><i></i></div>
        <div class="empty-shelf"></div>
        <div class="empty-screw empty-screw-one"></div>
        <div class="empty-screw empty-screw-two"></div>
      </div>
      <p class="eyebrow">PRÓXIMO PASO</p>
      <h2>{{ tieneFiltros ? 'No hay resultados para esta búsqueda' : 'El pañol empieza acá' }}</h2>
      <p class="empty-copy">
        {{ tieneFiltros
          ? 'Todavía no hay objetos cargados para estos criterios. Probá con otra búsqueda o limpiá los filtros.'
          : 'El catálogo todavía no tiene objetos cargados. La conexión con los datos se incorporará en una próxima etapa.' }}
      </p>
      <button v-if="tieneFiltros" type="button" class="text-button" @click="limpiarFiltros">Limpiar búsqueda y filtros <span aria-hidden="true">→</span></button>
      <RouterLink v-else to="/objetos/nuevo" class="button button-secondary empty-action">Preparar un registro <span aria-hidden="true">→</span></RouterLink>
    </section>

    <div class="catalog-footnote">
      <svg viewBox="0 0 20 20" aria-hidden="true"><circle cx="10" cy="10" r="7.2"/><path d="M10 9v4M10 6.4h.01" /></svg>
      <p>Los resultados aparecerán cuando el catálogo esté conectado. No se muestran objetos de ejemplo.</p>
    </div>
  </section>
</template>

<template>
  <section class="page-container">
    <span class="eyebrow">BUSCATECH</span>
    <h1>{{ esEdicion ? 'Modificar objeto' : 'Registrar objeto' }}</h1>
    <p>Acá estará el formulario para {{ esEdicion ? 'modificar' : 'registrar' }} objetos del pañol.</p>
    <RouterLink to="/catalogo" class="button button-secondary">Volver al catálogo</RouterLink>
  </section>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const esEdicion = computed(() => Boolean(route.params.id))
</script>

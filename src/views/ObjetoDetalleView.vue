<script setup>
import { useRoute } from 'vue-router'

const route = useRoute()
</script>

<template>
  <section class="detail-page page-width" aria-labelledby="detail-title">
    <div class="breadcrumb"><RouterLink to="/catalogo">Catálogo</RouterLink><span aria-hidden="true">/</span><span>Detalle</span></div>
    <header class="page-heading form-intro">
      <div>
        <p class="eyebrow">FICHA DEL PAÑOL <span class="eyebrow-divider">/</span> {{ route.params.id }}</p>
        <h1 id="detail-title">Detalle del objeto</h1>
        <p class="page-intro">La ficha completa mostrará la descripción y la ubicación precisa del objeto.</p>
      </div>
    </header>

    <div class="detail-empty-card">
      <span class="detail-empty-symbol" aria-hidden="true"><svg viewBox="0 0 24 24"><path d="M4 7.5 12 3l8 4.5v9L12 21l-8-4.5v-9Z"/><path d="m4.5 7.8 7.5 4.4 7.5-4.4M12 12.2V21M8 5.3l8 4.5"/></svg></span>
      <p class="eyebrow">SIN DATOS DISPONIBLES</p>
      <h2>No se encontró una ficha para mostrar</h2>
      <p>El detalle aparecerá cuando el catálogo esté conectado y haya objetos cargados. No se muestra información inventada.</p>
      <div class="detail-actions">
        <RouterLink to="/catalogo" class="button button-secondary">Volver al catálogo</RouterLink>
        <RouterLink to="/objetos/nuevo" class="button button-primary">Registrar objeto</RouterLink>
      </div>
    </div>
  </section>
</template>

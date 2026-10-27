
<script setup>
import AppNavbar from './components/AppNavbar.vue'
</script>

<template>
  <div class="app-shell">
    <AppNavbar />

    <main class="main-content">
      <RouterView />
    </main>

    <footer class="site-footer">
      <div class="footer-inner">
        <RouterLink to="/" class="footer-brand">
          Busca<span>TECH</span>
        </RouterLink>

        <p>
          Organización del pañol · EEST N.º 1 de Esteban Echeverría
        </p>

        <span class="footer-note">
          Herramientas en su lugar.
        </span>
      </div>
    </footer>
  </div>
</template>

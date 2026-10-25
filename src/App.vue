<script setup>
import { ref } from 'vue'

const menuOpen = ref(false)

function closeMenu() {
  menuOpen.value = false
}
</script>

<template>
  <div class="app-shell">
    <header class="site-header">
      <div class="header-inner">
        <RouterLink to="/" class="brand" aria-label="BuscaTECH, ir al inicio" @click="closeMenu">
          <span class="brand-mark" aria-hidden="true">
            <svg viewBox="0 0 32 32" fill="none">
              <path d="M7 24V8h9a6 6 0 0 1 0 12H7m9 0 8 4" />
              <path d="M22 8h4v4" />
            </svg>
          </span>
          <span class="brand-word">Busca<span>TECH</span></span>
        </RouterLink>

        <button
          class="menu-toggle"
          type="button"
          :aria-expanded="menuOpen"
          aria-controls="primary-navigation"
          :aria-label="menuOpen ? 'Cerrar menú' : 'Abrir menú'"
          @click="menuOpen = !menuOpen"
        >
          <span></span><span></span>
        </button>

        <nav id="primary-navigation" class="primary-navigation" :class="{ 'is-open': menuOpen }" aria-label="Navegación principal">
          <div class="nav-main">
            <RouterLink to="/" exact-active-class="is-active" @click="closeMenu">Inicio</RouterLink>
            <RouterLink to="/catalogo" active-class="is-active" @click="closeMenu">Catálogo</RouterLink>
          </div>
          <div class="nav-account">
            <RouterLink to="/login" class="nav-login" @click="closeMenu">Iniciar sesión</RouterLink>
            <RouterLink to="/registro" class="button button-primary nav-register" @click="closeMenu">Crear cuenta</RouterLink>
          </div>
        </nav>
      </div>
    </header>

    <main class="main-content">
      <RouterView />
    </main>

    <footer class="site-footer">
      <div class="footer-inner">
        <RouterLink to="/" class="footer-brand">Busca<span>TECH</span></RouterLink>
        <p>Organización del pañol · EEST N.º 1 de Esteban Echeverría</p>
        <span class="footer-note">Herramientas en su lugar.</span>
      </div>
    </footer>
  </div>
</template>

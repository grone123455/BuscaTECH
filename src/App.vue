<script setup>
</script>

<template>
  <div class="app">
    <header class="navbar">
      <RouterLink to="/" class="brand">
        <span class="brand-icon">B</span>
        <span>Busca<span class="brand-accent">TECH</span></span>
      </RouterLink>

      <nav class="nav-links">
        <RouterLink to="/">Inicio</RouterLink>
        <RouterLink to="/catalogo">Catálogo</RouterLink>
        <RouterLink to="/login" class="login-link">Iniciar sesión</RouterLink>
        <RouterLink to="/registro" class="register-link">Registrarse</RouterLink>
      </nav>
    </header>

    <main>
      <RouterView />
    </main>

    <footer class="footer">
      <p>BuscaTECH · Organización del pañol escolar</p>
    </footer>
  </div>
</template>

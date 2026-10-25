<script setup>
import { ref } from 'vue'

const email = ref('')
const password = ref('')
const mensaje = ref('')

function iniciarSesion() {
  mensaje.value = 'La autenticación todavía no está conectada. No se inició ninguna sesión.'
}
</script>

<template>
  <section class="auth-page" aria-labelledby="login-title">
    <div class="auth-aside">
      <span class="auth-aside-mark" aria-hidden="true"><svg viewBox="0 0 32 32"><path d="M7 24V8h9a6 6 0 0 1 0 12H7m9 0 8 4"/><path d="M22 8h4v4"/></svg></span>
      <p class="eyebrow">BUSCATECH <span class="eyebrow-divider">/</span> EEST N.º 1</p>
      <h1 id="login-title">Qué bueno<br />verte de nuevo.</h1>
      <p>Iniciá sesión para acceder a las herramientas de organización del pañol.</p>
    </div>

    <form class="auth-card" @submit.prevent="iniciarSesion">
      <div class="auth-card-heading"><h2>Iniciar sesión</h2><p>Ingresá con tu correo institucional o personal.</p></div>
      <div class="auth-fields">
        <div class="form-field"><label for="login-email">Correo electrónico</label><input id="login-email" v-model.trim="email" type="email" autocomplete="email" placeholder="nombre@correo.com" required /></div>
        <div class="form-field"><label for="login-password">Contraseña</label><input id="login-password" v-model="password" type="password" autocomplete="current-password" placeholder="Tu contraseña" required /></div>
      </div>
      <p v-if="mensaje" class="auth-feedback" role="status">{{ mensaje }}</p>
      <button class="button button-primary" type="submit">Iniciar sesión</button>
      <p class="auth-switch">¿Todavía no tenés una cuenta? <RouterLink to="/registro">Crear cuenta</RouterLink></p>
    </form>
  </section>
</template>

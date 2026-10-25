<script setup>
import { ref } from 'vue'

const nombre = ref('')
const apellido = ref('')
const email = ref('')
const password = ref('')
const confirmarPassword = ref('')
const mensaje = ref('')

function crearCuenta() {
  if (password.value.length < 8) {
    mensaje.value = 'La contraseña debe tener al menos 8 caracteres.'
    return
  }
  if (password.value !== confirmarPassword.value) {
    mensaje.value = 'Las contraseñas no coinciden. Revisá ambos campos.'
    return
  }
  mensaje.value = 'El formulario está completo, pero la autenticación todavía no está conectada. No se creó ninguna cuenta.'
}
</script>

<template>
  <section class="auth-page register-page" aria-labelledby="register-title">
    <div class="auth-aside">
      <span class="auth-aside-mark" aria-hidden="true"><svg viewBox="0 0 32 32"><path d="M7 24V8h9a6 6 0 0 1 0 12H7m9 0 8 4"/><path d="M22 8h4v4"/></svg></span>
      <p class="eyebrow">BUSCATECH <span class="eyebrow-divider">/</span> EEST N.º 1</p>
      <h1 id="register-title">Sumate al<br />pañol organizado.</h1>
      <p>Creá tu cuenta para colaborar con el registro y la organización de herramientas y materiales.</p>
    </div>

    <form class="auth-card" @submit.prevent="crearCuenta">
      <div class="auth-card-heading"><h2>Crear cuenta</h2><p>Completá tus datos para continuar.</p></div>
      <div class="auth-fields two-column">
        <div class="form-field"><label for="register-name">Nombre</label><input id="register-name" v-model.trim="nombre" type="text" autocomplete="given-name" placeholder="Tu nombre" required /></div>
        <div class="form-field"><label for="register-lastname">Apellido</label><input id="register-lastname" v-model.trim="apellido" type="text" autocomplete="family-name" placeholder="Tu apellido" required /></div>
        <div class="form-field is-wide"><label for="register-email">Correo electrónico</label><input id="register-email" v-model.trim="email" type="email" autocomplete="email" placeholder="nombre@correo.com" required /></div>
        <div class="form-field is-wide"><label for="register-password">Contraseña</label><input id="register-password" v-model="password" type="password" autocomplete="new-password" minlength="8" placeholder="Al menos 8 caracteres" required /></div>
        <div class="form-field is-wide"><label for="register-password-confirm">Confirmar contraseña</label><input id="register-password-confirm" v-model="confirmarPassword" type="password" autocomplete="new-password" placeholder="Repetí tu contraseña" required /></div>
      </div>
      <p v-if="mensaje" class="auth-feedback" role="status">{{ mensaje }}</p>
      <button class="button button-primary" type="submit">Crear cuenta</button>
      <p class="auth-switch">¿Ya tenés una cuenta? <RouterLink to="/login">Iniciar sesión</RouterLink></p>
    </form>
  </section>
</template>

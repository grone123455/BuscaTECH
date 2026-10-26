
<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '../services/supabase'

const router = useRouter()

const nombre = ref('')
const apellido = ref('')
const email = ref('')
const password = ref('')
const confirmarPassword = ref('')
const tipoIntegrante = ref('otro')
const mensaje = ref('')
const cargando = ref(false)

async function crearCuenta() {
  mensaje.value = ''

  if (password.value.length < 8) {
    mensaje.value = 'La contraseña debe tener al menos 8 caracteres.'
    return
  }

  if (password.value !== confirmarPassword.value) {
    mensaje.value = 'Las contraseñas no coinciden. Revisá ambos campos.'
    return
  }

  cargando.value = true

  try {
    const { data, error } = await supabase.auth.signUp({
      email: email.value.trim(),
      password: password.value,
      options: {
        data: {
          nombre: nombre.value.trim(),
          apellido: apellido.value.trim(),
          tipo_integrante: tipoIntegrante.value,
        },
      },
    })

    if (error) throw error

    if (!data.user) {
      mensaje.value = 'No se pudo crear la cuenta. Intentá nuevamente.'
      return
    }

    if (data.session) {
      const { error: errorPerfil } = await supabase
        .from('perfiles')
        .upsert(
          {
            id: data.user.id,
            nombre: nombre.value.trim(),
            apellido: apellido.value.trim(),
            tipo_integrante: tipoIntegrante.value,
          },
          { onConflict: 'id' },
        )

      if (errorPerfil) {
        console.error('Error al guardar el perfil:', errorPerfil)
        mensaje.value =
          'La cuenta se creó, pero no se pudo guardar el perfil. Iniciá sesión e intentá nuevamente.'
        return
      }

      await router.push('/catalogo')
    } else {
      mensaje.value =
        'La cuenta se creó. Revisá tu correo para confirmarla y después iniciá sesión.'
    }
  } catch (error) {
    console.error('Error al crear la cuenta:', error)
    mensaje.value =
      error.message ||
      'No se pudo crear la cuenta. Revisá los datos e intentá nuevamente.'
  } finally {
    cargando.value = false
  }
}
</script>

<template>
  <section class="auth-page register-page" aria-labelledby="register-title">
    <div class="auth-aside">
      <span class="auth-aside-mark" aria-hidden="true">
        <svg viewBox="0 0 32 32">
          <path d="M7 24V8h9a6 6 0 0 1 0 12H7m9 0 8 4" />
          <path d="M22 8h4v4" />
        </svg>
      </span>

      <p class="eyebrow">
        BUSCATECH <span class="eyebrow-divider">/</span> EEST N.º 1
      </p>

      <h1 id="register-title">Sumate al<br />pañol organizado.</h1>

      <p>
        Creá tu cuenta para colaborar con el registro y la organización de
        herramientas y materiales.
      </p>
    </div>

    <form class="auth-card" @submit.prevent="crearCuenta">
      <div class="auth-card-heading">
        <h2>Crear cuenta</h2>
        <p>Completá tus datos para continuar.</p>
      </div>

      <div class="auth-fields two-column">
        <div class="form-field">
          <label for="register-name">Nombre</label>
          <input
            id="register-name"
            v-model.trim="nombre"
            type="text"
            autocomplete="given-name"
            placeholder="Tu nombre"
            required
            :disabled="cargando"
          />
        </div>

        <div class="form-field">
          <label for="register-lastname">Apellido</label>
          <input
            id="register-lastname"
            v-model.trim="apellido"
            type="text"
            autocomplete="family-name"
            placeholder="Tu apellido"
            required
            :disabled="cargando"
          />
        </div>

        <div class="form-field is-wide">
          <label for="register-role">Tipo de integrante</label>
          <select
            id="register-role"
            v-model="tipoIntegrante"
            required
            :disabled="cargando"
          >
            <option value="profesor">Profesor</option>
            <option value="preceptor">Preceptor</option>
            <option value="directivo">Directivo</option>
            <option value="pañolero">Pañolero</option>
            <option value="otro">Otro</option>
          </select>
        </div>

        <div class="form-field is-wide">
          <label for="register-email">Correo electrónico</label>
          <input
            id="register-email"
            v-model.trim="email"
            type="email"
            autocomplete="email"
            placeholder="nombre@correo.com"
            required
            :disabled="cargando"
          />
        </div>

        <div class="form-field is-wide">
          <label for="register-password">Contraseña</label>
          <input
            id="register-password"
            v-model="password"
            type="password"
            autocomplete="new-password"
            minlength="8"
            placeholder="Al menos 8 caracteres"
            required
            :disabled="cargando"
          />
        </div>

        <div class="form-field is-wide">
          <label for="register-password-confirm">Confirmar contraseña</label>
          <input
            id="register-password-confirm"
            v-model="confirmarPassword"
            type="password"
            autocomplete="new-password"
            placeholder="Repetí tu contraseña"
            required
            :disabled="cargando"
          />
        </div>
      </div>

      <p v-if="mensaje" class="auth-feedback" role="status">
        {{ mensaje }}
      </p>

      <button class="button button-primary" type="submit" :disabled="cargando">
        {{ cargando ? 'Creando cuenta…' : 'Crear cuenta' }}
      </button>

      <p class="auth-switch">
        ¿Ya tenés una cuenta?
        <RouterLink to="/login">Iniciar sesión</RouterLink>
      </p>
    </form>
  </section>
</template>

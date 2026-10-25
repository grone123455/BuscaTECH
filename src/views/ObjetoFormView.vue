<script setup>
import { computed, reactive, ref } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const esEdicion = computed(() => Boolean(route.params.id))
const camposDeshabilitados = computed(() => esEdicion.value)
const formulario = reactive({
  nombre: '',
  descripcion: '',
  especialidad: '',
  sector: '',
  estante: '',
  armario: '',
  cajon: '',
  observaciones: '',
})
const fotoNombre = ref('')
const errores = ref([])
const mensaje = ref('')

function seleccionarFoto(event) {
  fotoNombre.value = event.target.files?.[0]?.name ?? ''
}

function enviarFormulario() {
  mensaje.value = ''
  if (esEdicion.value) return

  errores.value = [
    !formulario.nombre.trim() && 'Ingresá el nombre del objeto.',
    !formulario.especialidad && 'Seleccioná una especialidad.',
    !formulario.sector.trim() && 'Completá el sector.',
    !formulario.estante.trim() && 'Completá el estante.',
    !formulario.armario.trim() && 'Completá el armario.',
  ].filter(Boolean)

  if (errores.value.length) return
  mensaje.value = 'Los campos están completos, pero no se guardó ningún dato: la conexión con el catálogo está pendiente.'
}
</script>

<template>
  <section class="form-page page-width" aria-labelledby="object-form-title">
    <div class="breadcrumb"><RouterLink to="/catalogo">Catálogo</RouterLink><span aria-hidden="true">/</span><span>{{ esEdicion ? 'Modificar objeto' : 'Nuevo objeto' }}</span></div>
    <header class="page-heading form-intro">
      <div>
        <p class="eyebrow">FICHA DEL PAÑOL <span class="eyebrow-divider">/</span> {{ esEdicion ? 'EDICIÓN' : 'NUEVO REGISTRO' }}</p>
        <h1 id="object-form-title">{{ esEdicion ? 'Modificar objeto' : 'Registrar objeto' }}</h1>
        <p class="page-intro">{{ esEdicion ? 'Revisá la información de la ficha seleccionada.' : 'Completá los datos para identificar y ubicar el objeto en el pañol.' }}</p>
      </div>
    </header>

    <div class="form-layout">
      <form class="form-card" novalidate @submit.prevent="enviarFormulario">
        <p v-if="esEdicion" class="form-alert" role="status">No se cargaron datos de un objeto para editar. La ficha se podrá modificar cuando el catálogo esté conectado.</p>
        <p v-else-if="errores.length" class="form-alert" role="alert">{{ errores.join(' ') }}</p>
        <p v-if="mensaje" class="form-feedback" role="status">{{ mensaje }}</p>

        <h2 class="form-section-title"><span>01</span> Información del objeto</h2>
        <div class="form-grid">
          <div class="form-field is-wide">
            <label for="object-name">Nombre del objeto <span aria-hidden="true">*</span></label>
            <input id="object-name" v-model.trim="formulario.nombre" type="text" placeholder="Ej.: nombre de la herramienta o material" :disabled="camposDeshabilitados" :required="!esEdicion" autocomplete="off" />
          </div>
          <div class="form-field">
            <label for="object-category">Especialidad <span aria-hidden="true">*</span></label>
            <select id="object-category" v-model="formulario.especialidad" :disabled="camposDeshabilitados" :required="!esEdicion">
              <option value="" disabled>Seleccioná una especialidad</option>
              <option>Mecánica</option><option>Electricidad</option><option>Otros</option>
            </select>
          </div>
          <div class="form-field is-wide">
            <label for="object-description">Descripción</label>
            <textarea id="object-description" v-model.trim="formulario.descripcion" placeholder="Descripción breve para reconocer el objeto" :disabled="camposDeshabilitados"></textarea>
          </div>
        </div>

        <h2 class="form-section-title form-section-spaced"><span>02</span> Ubicación en el pañol</h2>
        <div class="form-grid">
          <div class="form-field">
            <label for="object-sector">Sector <span aria-hidden="true">*</span></label>
            <input id="object-sector" v-model.trim="formulario.sector" type="text" placeholder="Sector" :disabled="camposDeshabilitados" :required="!esEdicion" />
          </div>
          <div class="form-field">
            <label for="object-shelf">Estante <span aria-hidden="true">*</span></label>
            <input id="object-shelf" v-model.trim="formulario.estante" type="text" placeholder="Estante" :disabled="camposDeshabilitados" :required="!esEdicion" />
          </div>
          <div class="form-field">
            <label for="object-cabinet">Armario <span aria-hidden="true">*</span></label>
            <input id="object-cabinet" v-model.trim="formulario.armario" type="text" placeholder="Armario" :disabled="camposDeshabilitados" :required="!esEdicion" />
          </div>
          <div class="form-field">
            <label for="object-drawer">Cajón <span class="field-hint">(opcional)</span></label>
            <input id="object-drawer" v-model.trim="formulario.cajon" type="text" placeholder="Cajón" :disabled="camposDeshabilitados" />
          </div>
          <div class="form-field is-wide">
            <label for="object-photo">Fotografía <span class="field-hint">(opcional)</span></label>
            <label class="upload-control" for="object-photo">
              <span class="upload-icon" aria-hidden="true"><svg viewBox="0 0 20 20"><path d="M10 13V3.5m0 0L6.5 7M10 3.5 13.5 7M4 12v4.5h12V12"/></svg></span>
              <span class="upload-copy"><strong>{{ fotoNombre || 'Elegir una imagen' }}</strong><small>JPG, PNG o WEBP · La imagen no se sube en esta etapa</small></span>
              <input id="object-photo" type="file" accept="image/*" :disabled="camposDeshabilitados" @change="seleccionarFoto" />
            </label>
          </div>
        </div>

        <h2 class="form-section-title form-section-spaced"><span>03</span> Observaciones</h2>
        <div class="form-grid">
          <div class="form-field is-wide">
            <label for="object-notes">Notas adicionales <span class="field-hint">(opcional)</span></label>
            <textarea id="object-notes" v-model.trim="formulario.observaciones" placeholder="Agregá cualquier detalle útil para identificar el objeto" :disabled="camposDeshabilitados"></textarea>
          </div>
        </div>

        <div class="form-actions">
          <RouterLink to="/catalogo" class="button button-secondary">Cancelar</RouterLink>
          <button class="button button-primary" type="submit" :disabled="esEdicion">{{ esEdicion ? 'Esperando datos del objeto' : 'Guardar objeto' }}</button>
        </div>
      </form>

      <aside class="form-aside" aria-label="Ayuda para completar la ficha">
        <p class="aside-label">GUÍA DE REGISTRO</p>
        <div class="aside-step"><span class="aside-step-number">1</span><p><strong>Identificá</strong> el objeto con un nombre claro y una especialidad.</p></div>
        <div class="aside-step"><span class="aside-step-number">2</span><p><strong>Ubicalo</strong> indicando sector, estante y armario.</p></div>
        <div class="aside-step"><span class="aside-step-number">3</span><p><strong>Completá</strong> la descripción, foto y notas si hacen falta.</p></div>
        <div class="aside-note"><svg viewBox="0 0 16 16" aria-hidden="true"><circle cx="8" cy="8" r="6.2"/><path d="M8 7v4M8 4.8h.01"/></svg><span>Esta pantalla es una vista previa. Los datos no se guardan hasta conectar el catálogo.</span></div>
      </aside>
    </div>
  </section>
</template>

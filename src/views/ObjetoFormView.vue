
<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { supabase } from '../services/supabase'
import { MODO_PRUEBA } from '../data/modoPrueba'
import { objetosEstado } from '../data/objetosEstado'

const route = useRoute()
const router = useRouter()

const esEdicion = computed(() => Boolean(route.params.id))

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
const guardando = ref(false)
const cargando = ref(false)

function seleccionarFoto(event) {
  fotoNombre.value = event.target.files?.[0]?.name ?? ''
}

function completarFormulario(data) {
  formulario.nombre = data.nombre ?? ''
  formulario.descripcion = data.descripcion ?? ''
  formulario.especialidad = data.especialidad ?? ''
  formulario.sector = data.sector ?? ''
  formulario.estante = data.estante ?? ''
  formulario.armario = data.armario ?? ''
  formulario.cajon = data.cajon ?? ''
  formulario.observaciones = data.observaciones ?? ''
}

async function cargarObjeto() {
  if (!esEdicion.value) return

  cargando.value = true
  errores.value = []
  mensaje.value = ''

  const id = route.params.id

  try {
    if (MODO_PRUEBA) {
      const objeto = objetosEstado.value.find(
        (item) => String(item.id) === String(id)
      )

      if (!objeto) {
        mensaje.value = 'No se encontró el objeto que querés modificar.'
        return
      }

      completarFormulario(objeto)
      return
    }

    if (!/^\d+$/.test(String(id))) {
      mensaje.value = 'El identificador del objeto no es válido.'
      return
    }

    const { data, error } = await supabase
      .from('objetos')
      .select(
        'id, nombre, descripcion, especialidad, sector, estante, armario, cajon, observaciones'
      )
      .eq('id', id)
      .maybeSingle()

    if (error) throw error

    if (!data) {
      mensaje.value = 'No se encontró el objeto que querés modificar.'
      return
    }

    completarFormulario(data)
  } catch (error) {
    console.error('Error al cargar el objeto:', error)
    mensaje.value = 'No se pudieron cargar los datos del objeto.'
  } finally {
    cargando.value = false
  }
}

onMounted(cargarObjeto)
watch(() => route.params.id, cargarObjeto)

async function enviarFormulario() {
  errores.value = []
  mensaje.value = ''

  errores.value = [
    !formulario.nombre.trim() && 'Ingresá el nombre del objeto.',
    !formulario.especialidad && 'Seleccioná una especialidad.',
    !formulario.sector.trim() && 'Completá el sector.',
    !formulario.estante.trim() && 'Completá el estante.',
    !formulario.armario.trim() && 'Completá el armario.',
  ].filter(Boolean)

  if (errores.value.length) return

  guardando.value = true

  const datosObjeto = {
    nombre: formulario.nombre.trim(),
    descripcion: formulario.descripcion.trim() || null,
    especialidad: formulario.especialidad,
    sector: formulario.sector.trim(),
    estante: formulario.estante.trim(),
    armario: formulario.armario.trim(),
    cajon: formulario.cajon.trim() || null,
    observaciones: formulario.observaciones.trim() || null,
  }

  try {
    if (MODO_PRUEBA) {
      if (esEdicion.value) {
        const indice = objetosEstado.value.findIndex(
          (item) => String(item.id) === String(route.params.id)
        )

        if (indice === -1) {
          mensaje.value = 'No se encontró el objeto que querés modificar.'
          return
        }

        objetosEstado.value[indice] = {
          ...objetosEstado.value[indice],
          ...datosObjeto,
        }
      } else {
        const numeros = objetosEstado.value
          .map((item) => String(item.id).match(/^prueba-(\d+)$/))
          .filter(Boolean)
          .map((coincidencia) => Number(coincidencia[1]))

        const siguienteNumero = Math.max(0, ...numeros) + 1

        objetosEstado.value.push({
          id: `prueba-${siguienteNumero}`,
          ...datosObjeto,
          imagen_url: null,
          creado_en: new Date().toISOString().slice(0, 10),
        })
      }

      await router.push('/catalogo')
      return
    }

    if (esEdicion.value) {
      const id = route.params.id

      if (!/^\d+$/.test(String(id))) {
        mensaje.value = 'El identificador del objeto no es válido.'
        return
      }

      const resultado = await supabase
        .from('objetos')
        .update(datosObjeto)
        .eq('id', id)
        .select('id')
        .maybeSingle()

      if (resultado.error) throw resultado.error

      if (!resultado.data) {
        mensaje.value =
          'No se pudo modificar el objeto. Verificá que exista y que tengas permiso para editarlo.'
        return
      }
    } else {
      const resultado = await supabase
        .from('objetos')
        .insert(datosObjeto)

      if (resultado.error) throw resultado.error
    }

    await router.push('/catalogo')
  } catch (error) {
    console.error('Error al guardar el objeto:', error)
    mensaje.value = MODO_PRUEBA
      ? 'No se pudo guardar el objeto de prueba.'
      : 'No se pudo guardar el objeto. Revisá la conexión y los permisos de Supabase.'
  } finally {
    guardando.value = false
  }
}
</script>

<template>
  <section class="form-page page-width" aria-labelledby="object-form-title">
    <div class="breadcrumb">
      <RouterLink to="/catalogo">Catálogo</RouterLink>
      <span aria-hidden="true">/</span>
      <span>{{ esEdicion ? 'Modificar objeto' : 'Nuevo objeto' }}</span>
    </div>

    <header class="page-heading form-intro">
      <div>
        <p class="eyebrow">
          FICHA DEL PAÑOL <span class="eyebrow-divider">/</span>
          {{ esEdicion ? 'EDICIÓN' : 'NUEVO REGISTRO' }}
        </p>
        <h1 id="object-form-title">
          {{ esEdicion ? 'Modificar objeto' : 'Registrar objeto' }}
        </h1>
        <p class="page-intro">
          Completá los datos para identificar y ubicar el objeto en el pañol.
        </p>
      </div>
    </header>

    <div v-if="cargando" class="detail-empty-card" aria-live="polite">
      <h2>Cargando datos del objeto…</h2>
    </div>

    <div
      v-else-if="esEdicion && mensaje && !formulario.nombre"
      class="detail-empty-card"
      role="alert"
    >
      <h2>No se pudo abrir el formulario</h2>
      <p>{{ mensaje }}</p>
      <RouterLink to="/catalogo" class="button button-secondary">
        Volver al catálogo
      </RouterLink>
    </div>

    <div v-else class="form-layout">
      <form class="form-card" novalidate @submit.prevent="enviarFormulario">
        <p v-if="errores.length" class="form-alert" role="alert">
          {{ errores.join(' ') }}
        </p>
        <p v-if="mensaje" class="form-feedback" role="status">
          {{ mensaje }}
        </p>

        <h2 class="form-section-title">
          <span>01</span> Información del objeto
        </h2>

        <div class="form-grid">
          <div class="form-field is-wide">
            <label for="object-name">
              Nombre del objeto <span aria-hidden="true">*</span>
            </label>
            <input
              id="object-name"
              v-model.trim="formulario.nombre"
              type="text"
              placeholder="Ej.: Martillo"
              required
              :disabled="guardando"
            />
          </div>

          <div class="form-field">
            <label for="object-category">
              Especialidad <span aria-hidden="true">*</span>
            </label>
            <select
              id="object-category"
              v-model="formulario.especialidad"
              required
              :disabled="guardando"
            >
              <option value="" disabled>Seleccioná una especialidad</option>
              <option>Mecánica</option>
              <option>Electricidad</option>
              <option>Informática</option>
              <option>Construcciones</option>
              <option>Otros</option>
            </select>
          </div>

          <div class="form-field is-wide">
            <label for="object-description">Descripción</label>
            <textarea
              id="object-description"
              v-model.trim="formulario.descripcion"
              placeholder="Descripción breve del objeto"
              :disabled="guardando"
            ></textarea>
          </div>
        </div>

        <h2 class="form-section-title form-section-spaced">
          <span>02</span> Ubicación en el pañol
        </h2>

        <div class="form-grid">
          <div class="form-field">
            <label for="object-sector">
              Sector <span aria-hidden="true">*</span>
            </label>
            <input
              id="object-sector"
              v-model.trim="formulario.sector"
              required
              placeholder="Sector"
              :disabled="guardando"
            />
          </div>

          <div class="form-field">
            <label for="object-shelf">
              Estante <span aria-hidden="true">*</span>
            </label>
            <input
              id="object-shelf"
              v-model.trim="formulario.estante"
              required
              placeholder="Estante"
              :disabled="guardando"
            />
          </div>

          <div class="form-field">
            <label for="object-cabinet">
              Armario <span aria-hidden="true">*</span>
            </label>
            <input
              id="object-cabinet"
              v-model.trim="formulario.armario"
              required
              placeholder="Armario"
              :disabled="guardando"
            />
          </div>

          <div class="form-field">
            <label for="object-drawer">
              Cajón <span class="field-hint">(opcional)</span>
            </label>
            <input
              id="object-drawer"
              v-model.trim="formulario.cajon"
              placeholder="Cajón"
              :disabled="guardando"
            />
          </div>

          <div class="form-field is-wide">
            <label for="object-photo">
              Fotografía <span class="field-hint">(opcional)</span>
            </label>
            <label class="upload-control" for="object-photo">
              <span class="upload-icon" aria-hidden="true">
                <svg viewBox="0 0 20 20">
                  <path d="M10 13V3.5m0 0L6.5 7M10 3.5 13.5 7M4 12v4.5h12V12"/>
                </svg>
              </span>
              <span class="upload-copy">
                <strong>{{ fotoNombre || 'Elegir una imagen' }}</strong>
                <small>JPG, PNG o WEBP · La imagen no se sube en esta etapa</small>
              </span>
              <input
                id="object-photo"
                type="file"
                accept="image/*"
                :disabled="guardando"
                @change="seleccionarFoto"
              />
            </label>
          </div>
        </div>

        <h2 class="form-section-title form-section-spaced">
          <span>03</span> Observaciones
        </h2>

        <div class="form-grid">
          <div class="form-field is-wide">
            <label for="object-notes">
              Notas adicionales <span class="field-hint">(opcional)</span>
            </label>
            <textarea
              id="object-notes"
              v-model.trim="formulario.observaciones"
              placeholder="Detalles útiles para identificar el objeto"
              :disabled="guardando"
            ></textarea>
          </div>
        </div>

        <div class="form-actions">
          <RouterLink to="/catalogo" class="button button-secondary">
            Cancelar
          </RouterLink>
          <button
            class="button button-primary"
            type="submit"
            :disabled="guardando"
          >
            {{
              guardando
                ? 'Guardando…'
                : esEdicion
                  ? 'Guardar cambios'
                  : 'Guardar objeto'
            }}
          </button>
        </div>
      </form>

      <aside class="form-aside" aria-label="Ayuda para completar la ficha">
        <p class="aside-label">GUÍA DE REGISTRO</p>

        <div class="aside-step">
          <span class="aside-step-number">1</span>
          <p><strong>Identificá</strong> el objeto con un nombre claro y una especialidad.</p>
        </div>

        <div class="aside-step">
          <span class="aside-step-number">2</span>
          <p><strong>Ubicalo</strong> indicando sector, estante y armario.</p>
        </div>

        <div class="aside-step">
          <span class="aside-step-number">3</span>
          <p><strong>Completá</strong> la descripción y las notas si hacen falta.</p>
        </div>

        <div class="aside-note">
          <svg viewBox="0 0 16 16" aria-hidden="true">
            <circle cx="8" cy="8" r="6.2"/>
            <path d="M8 7v4M8 4.8h.01"/>
          </svg>
          <span>
            {{ MODO_PRUEBA
              ? 'Los datos de prueba son temporales y se reinician al recargar la aplicación.'
              : 'Los datos se guardan en la base de datos de BuscaTECH.' }}
          </span>
        </div>
      </aside>
    </div>
  </section>
</template>

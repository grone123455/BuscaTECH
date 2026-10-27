
<script setup>
defineProps({
  titulo: {
    type: String,
    required: true,
  },
  mensaje: {
    type: String,
    default: '',
  },
  tipo: {
    type: String,
    default: 'info',
    validator: (valor) => ['info', 'error'].includes(valor),
  },
})
</script>

<template>
  <section
    class="estado-mensaje"
    :class="`estado-mensaje-${tipo}`"
    :role="tipo === 'error' ? 'alert' : 'status'"
    aria-live="polite"
  >
    <h2>{{ titulo }}</h2>
    <p v-if="mensaje">{{ mensaje }}</p>
    <slot />
  </section>
</template>

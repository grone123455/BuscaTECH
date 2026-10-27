
<script setup>
defineProps({
  breadcrumb: {
    type: Array,
    default: () => [],
  },
  eyebrow: {
    type: String,
    default: '',
  },
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    default: '',
  },
})
</script>

<template>
  <div class="page-heading">
    <div>
      <div v-if="breadcrumb.length" class="breadcrumb">
        <template v-for="(item, index) in breadcrumb" :key="index">
          <span v-if="index > 0" aria-hidden="true">/</span>
          <RouterLink
            v-if="item.to"
            :to="item.to"
          >
            {{ item.label }}
          </RouterLink>
          <span v-else>{{ item.label }}</span>
        </template>
      </div>

      <p v-if="eyebrow" class="eyebrow">
        {{ eyebrow }}
      </p>

      <h1>{{ title }}</h1>

      <p v-if="description" class="page-intro">
        {{ description }}
      </p>
    </div>

    <div class="page-heading-actions">
      <slot name="actions" />
    </div>
  </div>
</template>

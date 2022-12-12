<template>
  <p>モーダル</p>
  <button v-on:click="$emit('close')">閉じる</button>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'Modal',
  props: {},
  emits: ['close']
})
</script>

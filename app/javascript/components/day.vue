<template>
  <Popper arrow>
    <button>{{ currentSchedule() }}</button>
    <template #content>
      <div v-for="scheduleMark in scheduleMarks" :key="scheduleMark">
        <button v-on:click="changeSchedule(scheduleMark)">{{ scheduleMark }}</button>
      </div>
    </template>
  </Popper>
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import Popper from 'vue3-popper'

export default defineComponent({
  data() {
    return {
      schedule: "",
      scheduleMarks: ["●","▲","△","□"],
      markToSchedule: { "●":"full-time", "▲":"morning", "△":"afternoon", "□":"off" },
      scheduleToMark: { "full-time":"●", "morning":"▲", "afternoon":"△", "off":"□" },
    }
  },
  props: { 
    date: { type: Object, required: true },
  },
  methods: {
    token() {
      const meta = document.querySelector('meta[name="csrf-token"]')
      return meta ? meta.getAttribute('content') : ''
    },
    currentSchedule() {
      if (!this.schedule) {
        return this.scheduleToMark[this.date.schedule]
      } 
      return this.scheduleToMark[this.schedule]
    },
    changeSchedule(scheduleMark) {
      this.schedule = this.markToSchedule[scheduleMark]
      this.updateCalendar(this.schedule)
    },
    updateCalendar(state) {
      const dateState = {date:this.date.date, schedule:state}
      fetch(`days/${this.date.year}/${this.date.month}`, {
      method: 'POST',
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': this.token(),
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(dateState),
      credentials: 'same-origin'
      })
      .catch((error) => {
        console.warn(error)
      })
    },
  },
  components: {
    Popper,
  },
})
</script>

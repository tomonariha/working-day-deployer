import { createApp } from 'vue'
import App from '../app.vue'
import Scheduler from '../scheduler.vue'

document.addEventListener('DOMContentLoaded', () => {
  const Calendar = document.querySelector("#app")
  const userId = Calendar.getAttribute('data-user-id')
  createApp(App, {userId: userId}).component('Scheduler', Scheduler).mount('#app')
})

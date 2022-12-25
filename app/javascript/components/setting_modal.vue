<template>
  <p>モーダル</p>
  <select v-model="selectedStartMonth">
    <option v-for="i in 12" :key="i">
      {{ i }}
    </option>
  </select>
  <select v-model="selectedStartDay">
    <option v-for="i in this.lastDate(this.selectedStartMonth)" :key="i">
      {{ i }}
    </option>
  </select>
  <br>
  <select v-model="selectedEndMonth">
    <option v-for="i in 12" :key="i">
      {{ i }}
    </option>
  </select>
  <select v-model="selectedEndDay">
    <option v-for="i in this.lastDate(this.selectedEndMonth)" :key="i">
      {{ i }}
    </option>
  </select>
  <div>日曜日の予定</div>
  <br/>
  <input type="radio" id="none" value="None" v-model="scheduleOfSunday" />
  <label for="none">予定なし</label>
  <br/>
  <input type="radio" id="full-time" value="full-time" v-model="scheduleOfSunday" />
  <label for="full-time">全日出勤</label>
  <br/>
  <input type="radio" id="morning" value="morning" v-model="scheduleOfSunday" />
  <label for="morning">午前出勤</label>
  <br/>
  <input type="radio" id="after-noon" value="after-noon" v-model="scheduleOfSunday" />
  <label for="after-noon">午後出勤</label>
  <br/>
  <input type="radio" id="off" value="off" v-model="scheduleOfSunday" />
  <label for="off">休み</label>
  <br/>
  <button v-on:click="$emit('close')">閉じる</button>
  <button v-on:click="updateSetting()">保存</button>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'Modal',
  data() {
    return {
      scheduleOfSunday: "",
      scheduleOfMonday: "",
      scheduleOfTuesday: "",
      scheduleOfWednesday: "",
      scheduleOfThursday: "",
      scheduleOfFriday: "",
      scheduleOfSaturday: "",
      selectedStartMonth: "",
      selectedStartDay: "",
      selectedEndMonth: "",
      selectedEndDay: "",
    }
  },
  props: {
    year: { type: Number, required: true }
  },
  methods: {
    token() {
      const meta = document.querySelector('meta[name="csrf-token"]')
      return meta ? meta.getAttribute('content') : ''
    },
    lastDate(selectedMonth) {
      const lastDay = new Date(this.year, selectedMonth, 0)
      return lastDay.getDate()
    },
    updateSetting() {
      const schedules = {
        start_month: this.selectedStartMonth,
        start_day: this.selectedStartDay,
        end_month: this.selectedEndMonth,
        end_day: this.selectedEndDay,
        schedule_of_sunday: this.scheduleOfSunday
        }
      fetch(`/settings/${this.year}`, {
      method: 'POST',
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': this.token(),
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(schedules),
      credentials: 'same-origin'
      })
      .catch((error) => {
        console.warn(error)
      })
    },
  },
  emits: ['close']
})
</script>

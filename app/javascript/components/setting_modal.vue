<template>
  <p>モーダル</p>
  <div v-for="setting in settings" :key="setting.id">
    <button v-on:click="reflectSetting(setting)">{{ setting.period_start_at }} 〜 {{ setting.period_end_at }}</button>
    <button v-on:click="deleteSetting(setting.id)">この条件を削除</button>
  </div>
  <button v-on:click="resetSettingParams()">new</button>
  <br>
  <select v-model="selectedStartMonth">
    <option v-for="month in 12" :key="month">
      {{ month }}
    </option>
  </select>
  <select v-model="selectedStartDay">
    <option v-for="date in this.lastDate(this.selectedStartMonth)" :key="date">
      {{ date }}
    </option>
  </select>
  <br>
  <select v-model="selectedEndMonth">
    <option v-for="month in 12" :key="month">
      {{ month }}
    </option>
  </select>
  <select v-model="selectedEndDay">
    <option v-for="date in this.lastDate(this.selectedEndMonth)" :key="date">
      {{ date }}
    </option>
  </select>
  <div>この期間の勤務日数:
      <input type="number" v-show="specifiedTotalDays" v-model="totalWorkingDays"/>
  </div>
  <label for="checkSpecifiedTotalDays">指定しない</label>
  <input type="checkbox" id="checkSpecifiedTotalDays" v-model="notSpecifiedTotalDays" />
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
  <button v-if="this.settingId" v-on:click="updateSetting(this.settingId)">変更</button>
  <button v-else v-on:click="createSetting()">新規作成</button>
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
      settingId: "",
      totalWorkingDays: 0,
      notSpecifiedTotalDays: true,
    }
  },
  props: {
    year: { type: Number, reqired: true }, 
    settings: { type: Object, required: true }
  },
  computed: {
    specifiedTotalDays() {
      return !this.notSpecifiedTotalDays
    },
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
    updateSetting(settingId) {
      const start_at = new Date(this.year, (this.selectedStartMonth - 1), this.selectedStartDay)
      const end_at = new Date(this.year, (this.selectedEndMonth - 1), this.selectedEndDay)
      const schedules = {
        period_start_at: start_at.toDateString(),
        period_end_at: end_at.toDateString(),
        total_working_days: this.setTotalWorkingDays(),
        schedule_of_sunday: this.scheduleOfSunday
      }
      fetch(`api/calendars/${this.year}/settings/${settingId}`, {
      method: 'PUT',
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
    reflectSetting(setting) {
      const startDay = new Date(setting.period_start_at)
      const endDay = new Date(setting.period_end_at)
      this.totalWorkingDays = setting.total_working_days
      this.scheduleOfSunday = setting.schedule_of_sunday,
      this.selectedStartMonth = (startDay.getMonth() + 1),
      this.selectedStartDay = startDay.getDate(),
      this.selectedEndMonth = (endDay.getMonth() + 1),
      this.selectedEndDay = endDay.getDate(),
      this.settingId = setting.id
      if (setting.total_working_days) {
        this.notSpecifiedTotalDays = false
      } else {
        this.notSpecifiedTotalDays = true
      }
    },
    deleteSetting(settingId) {
      fetch(`api/calendars/${this.year}/settings/${settingId}`, {
      method: 'DELETE',
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': this.token(),
      },
      credentials: 'same-origin'
      })
      .catch((error) => {
        console.warn(error)
      })
    },
    createSetting() {
      const start_at = new Date(this.year, (this.selectedStartMonth - 1), this.selectedStartDay)
      const end_at = new Date(this.year, (this.selectedEndMonth - 1), this.selectedEndDay)
      const schedules = {
        period_start_at: start_at.toDateString(),
        period_end_at: end_at.toDateString(),
        total_working_days: this.setTotalWorkingDays(),
        schedule_of_sunday: this.scheduleOfSunday
      }
      fetch(`api/calendars/${this.year}/settings`, {
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
    resetSettingParams() {
      this.scheduleOfSunday = "",
      this.scheduleOfMonday = "",
      this.scheduleOfTuesday = "",
      this.scheduleOfWednesday = "",
      this.scheduleOfThursday = "",
      this.scheduleOfFriday = "",
      this.scheduleOfSaturday = "",
      this.selectedStartMonth = "",
      this.selectedStartDay = "",
      this.selectedEndMonth = "",
      this.selectedEndDay = "",
      this.settingId = "",
      this.totalWorkingDays = 0,
      this.notSpecifiedtotalDays = true
    },
    setTotalWorkingDays() {
      if (this.notSpecifiedTotalDays) { return null } 
      return this.totalWorkingDays
    }
  },
  emits: ['close'],
})
</script>

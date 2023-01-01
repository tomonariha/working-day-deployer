<template>
  <button v-on:click="openModal()">モーダル開く</button>
    <div id=overlay  v-show="showContent">
      <div id=content>
        <Modal v-bind:year="calendarYear" v-bind:settings="settings" v-on:close="closeModal()"></Modal>
      </div>
    </div>
  <button class="calendar-nav__previous" @click='previousMonth'>前</button>
  <button class="calendar-nav__next" @click='nextMonth'>後</button>
  <div class="calendar-nav__year--month">{{ calendarYear }}年{{ calendarMonth }}月 total:{{totalWorkingDays}}</div>
  <table class="calendar">
    <thead class="calendar__header">
      <tr>
        <th class="calendar__header-day">日</th>
        <th class="calendar__header-day">月</th>
        <th class="calendar__header-day">火</th>
        <th class="calendar__header-day">水</th>
        <th class="calendar__header-day">木</th>
        <th class="calendar__header-day">金</th>
        <th class="calendar__header-day">土</th>
      </tr>
    </thead>
    <tbody v-for="week in calendarWeeks" :key="week.id">
      <tr class="calendar__week">
        <td class="calendar__day" 
            v-for='date in week.value'
            :key='date.date'>
            <div class="calendar__day-label">{{ date.date }}</div>
            <Day v-bind:date="date" v-if="date.date > 0"></Day>
        </td>
      </tr>
    </tbody>
  </table>
  <button v-on:click="autoAdjast">適用</button>
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import Modal from './components/setting_modal.vue' 
import Day from './components/day.vue' 

export default defineComponent({
  name: 'Calendar',
  data() {
    return {
      schedules: ["●","▲","△","□"],
      markToSchedule: { "●":"full-time", "▲":"morning", "△":"afternoon", "□":"off" },
      scheduleToMark: { "full-time":"●", "morning":"▲", "afternoon":"△", "off":"□" },
      calendarDays: [],
      settings: [],
      currentYear: this.getCurrentYear(),
      currentMonth: this.getCurrentMonth(),
      calendarYear: this.getCurrentYear(),
      calendarMonth: this.getCurrentMonth(),
      today: this.getCurrentDay(),
      loaded: null,
      showContent: false,
      adjastedCalendar: [],
      totalWorkingDays: 0,
    }
  },
  props: {
    userId: { type: String, required: true }
  },
  computed: {
    firstWday() {
      const firstDay = new Date(this.calendarYear, this.calendarMonth - 1, 1)
      return firstDay.getDay()
    },
    lastDate() {
      const lastDay = new Date(this.calendarYear, this.calendarMonth, 0)
      return lastDay.getDate()
    },
    calendarWeeks() {
      const weeksAry = []
      let value = []
      let id = 1
      let weekDay = 0
      this.calendarDates.forEach(function (date, i, ary) {
        !date ? (date = { weekDay: weekDay }) : (date.weekDay = weekDay)
        value.push(date)
        weekDay++
        if (value.length === 7 || i === ary.length - 1) {
          weeksAry.push({ id: id, value: value })
          id++
          value = []
          weekDay = 0
        }
      })
      return weeksAry
    },
    calendarDates() {
      const calendar = []
      this.totalWorkingDays = 0
      if (this.firstWday > 0) {
        for (let blank = 0; blank < this.firstWday; blank++) {
          calendar.push(null)
        }
      }
      for (let date = 1; date <= this.lastDate; date++) {
        const result = this.calendarDays.filter((day) =>
          day.date.includes(
            `${this.calendarYear}-${this.formatMonth(this.calendarMonth)}-${this.formatDay(date)}`
          )
        )
        if (result.length > 0) {
          calendar.push({ 
            date: date,
            schedule: result[0].schedule,
            year: this.calendarYear,
            month: this.calendarMonth
          })
          this.countWorkingDays(result[0].schedule)
        } else {
          calendar.push({
            date: date, 
            schedule: null,
            year: this.calendarYear,
            month: this.calendarMonth
          })
        }
      }
      return calendar
    },
  },
  mounted() {
    const fetchCalendarAndSetting = async () => {
      await this.fetchCalendar()
      await this.fetchSettings()
    }
    fetchCalendarAndSetting()
  },
  methods: {
    token() {
      const meta = document.querySelector('meta[name="csrf-token"]')
      return meta ? meta.getAttribute('content') : ''
    },
    formatDay(day) {
      return day.toString().padStart(2, '0')
    },
    formatMonth(month) {
      return month.toString().padStart(2, '0')
    },
    getCurrentYear() {
      return new Date().getFullYear()
    },
    getCurrentMonth() {
      return new Date().getMonth() + 1
    },
    getCurrentDay() {
      return new Date().getDate()
    },
    previousMonth() {
      this.loaded = false
      if (this.calendarMonth === 1) {
        this.calendarMonth = 12
        this.calendarYear--
      } else {
        this.calendarMonth--
      }
      this.$nextTick(() => (this.loaded = true))
    },
    nextMonth() {
      this.loaded = false
      if (this.calendarMonth === 12) {
        this.calendarMonth = 1
        this.calendarYear++
      } else {
        this.calendarMonth++
      }
      this.$nextTick(() => (this.loaded = true))
    },
    fetchCalendar() {
      fetch(`/api/calendars/${this.calendarYear}.json`, {
      method: 'GET',
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': this.token()
      },
      credentials: 'same-origin'
      })
      .then((response) => {
        return response.json()
      })
      .then((json) => {
        json.forEach((r) => {
          this.calendarDays.push(r)
        })
        this.loaded = true
      })
      .catch((error) => {
        console.warn(error)
      })
    },
    openModal() {
      this.showContent = true
    },
    closeModal() {
      this.showContent = false
    },
    autoAdjast() {
      const setting = this.settings[0]
      const startDate = new Date(setting.period_start_at)
      const endDate = new Date(setting.period_end_at)
      const availableDays = new Array()
      if (setting.total_working_days) {
        const daysRequired = setting.total_working_days
      }
      for (let day = startDate; day <= endDate; day.setDate(day.getDate()+1)) {
        const formatedDate = day.getFullYear() + "-" + (day.getMonth()+1) + "-" + day.getDate()
        availableDays.push(formatedDate)
      }
      availableDays.forEach(d=> {
        const day = new Date(d)
        if (setting.schedule_of_sunday) {
          this.insertSchedule(day, setting.schedule_of_sunday)
        } 
      })
      this.reflectAdjastedCalendar()
    },
    insertSchedule(day , schedule) {
      if (day.getDay() === 0) {
        const formatedDate = day.getFullYear() + "-" + this.formatMonth(day.getMonth()+1) + "-" + this.formatDay(day.getDate())
        this.adjastedCalendar.push({
          date: formatedDate,
          schedule: schedule,
        })
      } 
    },
    fetchSettings() {
      fetch(`api/calendars/${this.calendarYear}/settings.json`, {
        method: 'GET',
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': this.token()
        },
        credentials: 'same-origin'
      })
      .then((response) => {
        return response.json()
      })
      .then((json) => {
        json.forEach((r) => {
          this.settings.push(r)
        })
        this.loaded = true
      })
      .catch((error) => {
        console.warn(error)
      })
    },
    reflectAdjastedCalendar() {
      for (let d of this.adjastedCalendar) {
        for (let day of this.calendarDays) {
          if (day.date === d.date) {
            this.calendarDays.splice(this.calendarDays.indexOf(day), 1, d)
          }
        }
      }
    },
    countWorkingDays(schedule) {
      if (schedule === 'full-time') {
        this.totalWorkingDays++
      } else if ((schedule === 'morning') || (schedule === 'afternoon')) {
        this.totalWorkingDays += 0.5
      }
    },
  },
  components: {
    Modal,
    Day,
  },
})
</script>

<style>
#overlay{
  z-index:1;
  position:fixed;
  top:0;
  left:0;
  width:100%;
  height:100%;
  background-color:rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
}
#content{
  z-index:2;
  width:50%;
  padding: 1em;
  background:#fff;
}
</style>
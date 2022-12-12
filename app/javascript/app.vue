<template>
  <button v-on:click="openModal()">モーダル開く</button>
    <div id=overlay  v-show="showContent">
      <div id=content>
        <Modal v-on:close="closeModal()"></Modal>
      </div>
    </div>
  <button class="calendar-nav__previous" @click='previousMonth'>前</button>
  <button class="calendar-nav__next" @click='nextMonth'>後</button>
  <div class="calendar-nav__year--month">{{ calendarYear }}年{{ calendarMonth }}月</div>
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
            :key='date.weekDay'>
            <div class="calendar__day-label">{{ date.date }}</div>
            <Popper arrow v-if="date.date > 0">
              <button>{{ scheduleToMark[date.schedule] }}</button>
              <template #content>
                <div v-for="schedule in schedules" :key="schedule">
                  <button v-on:click="changeSchedule(date, schedule)">{{ schedule }}</button>
                </div>
              </template>
            </Popper>
        </td>
      </tr>
    </tbody>
  </table>
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import Popper from 'vue3-popper'
import Modal from './components/setting_modal.vue' 

export default defineComponent({
  name: 'Calendar',
  data() {
    return {
      schedules: ["●","▲","△","□"],
      markToSchedule: { "●":"full-time", "▲":"morning", "△":"afternoon", "□":"off" },
      scheduleToMark: { "full-time":"●", "morning":"▲", "afternoon":"△", "off":"□" },
      calendarDays: [],
      currentYear: this.getCurrentYear(),
      currentMonth: this.getCurrentMonth(),
      calendarYear: this.getCurrentYear(),
      calendarMonth: this.getCurrentMonth(),
      today: this.getCurrentDay(),
      loaded: null,
      showContent: false,
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
          calendar.push({ date: date, schedule: result[0].schedule })
        } else {
          calendar.push({ date: date })
        }
      }
      return calendar
    },
  },
  mounted() {
    this.fetchCalendar()
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
    changeSchedule(date, schedule) {
      date.schedule = this.markToSchedule[schedule]
      this.updateCalendar(date)
      this.$nextTick(() => (this.fetchCalendar()))
    },
    updateCalendar(date) {
      fetch(`days/${this.calendarYear}/${this.calendarMonth}`, {
      method: 'POST',
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': this.token(),
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(date),
      credentials: 'same-origin'
      })
      .catch((error) => {
        console.warn(error)
      })
    },
    fetchCalendar() {
      fetch(`/api/calendars/${this.currentYear}.json`, {
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
        this.calendarDays = []
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
    }
  },
  components: {
    Popper,
    Modal,
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
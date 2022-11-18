<template>
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
            :key='date.weekDay'>{{ date.date }}
        </td>
      </tr>
    </tbody>
  </table>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'App',
  setup() {
    return {
      state: {
        message: "Hello Vue3 "
      }
    }
  },
  data() {
    return {
      currentYear: this.getCurrentYear(),
      currentMonth: this.getCurrentMonth(),
      calendarYear: this.getCurrentYear(),
      calendarMonth: this.getCurrentMonth(),
      today: this.getCurrentDay(),
      loaded: null
    }
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
        calendar.push({ date: date })
      }
      return calendar
    },
  },
  methods: {
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
  }
})
</script>

<template>
  <p>モーダル</p>
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
  <button>カレンダーに適用</button>
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
    }
  },
  props: {},
  emits: ['close']
})
</script>

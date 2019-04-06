<template>
  <section class="daily m-3">
    <h2>تغيير اليوم</h2>

    <datetime v-model="luxon_date" @input="change_luxon_date" :auto="true" class="datetime" min-datetime="2019-03-01"></datetime>
  </section>
</template>

<script >
import { Settings, DateTime } from 'luxon'

Settings.defaultLocale = 'ar'
Settings.defaultZoneName = 'UTC'
// console.log( DateTime.local().locale)

export default {
  name: 'daily',
  data () {
    return {
      luxon_date: ''
    }
  },
  firestore () {
    return {}
  },
  methods: {
    change_luxon_date(date){
      //console.log(DateTime.toUTC(date))
      console.log('change date to ', date , this.luxon_date)
      let dateTime = DateTime.fromISO(date)
      if(dateTime.valueOf()) {
        console.log('valueOf ',dateTime.valueOf())
        this.$store.commit('setDay' ,{
          ts: dateTime.valueOf(),
          iso: dateTime.toISODate(),
          d_week: dateTime.toLocaleString({ weekday: 'long'}),
          arab: dateTime.toLocaleString(DateTime.DATE_FULL) 
        })
      }
    }
  },
  mounted () {
    // this.luxon_date = DateTime.fromISO(this.$store.state.day.iso).toString()
  },
  components: {
  }
}
</script>

<style scoped >
h2 {
  margin: 0 0 1em;
  border-bottom: solid 1px #ddd;
}
</style>

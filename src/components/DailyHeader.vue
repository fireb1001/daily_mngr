<template>
  <section class="src-components-daily-header">
    <h1 @click="setToday">يومية {{day.iso}}</h1>
  </section>
</template>

<script>
// import { db } from '../main'

export default {
  name: 'daily-header',
  data () {
    return {
      day: this.$store.state.day
    }
  },
  firestore () {
    return {}
  },
  methods: {
    setToday () {
      // let iso = require('moment')().format('YYYY-MM-DD')
      // this.$store.commit('setDay' ,{now: Date.now(), iso: iso})
    }
  },
  components: {
  }
}
</script>

<style scoped lang="scss">

</style>

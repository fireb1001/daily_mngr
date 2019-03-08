<template>
  <section class="src-components-daily-header">
    <h1>يومية {{day}}</h1>
  </section>
</template>

<script>
// import { db } from '../main'

export default {
  name: 'daily-header',
  data () {
    return {
      day:'6/3/2019'
    }
  },
  firestore () {
    return {}
  },
  methods: {
  },
  components: {
  }
}
</script>

<style scoped lang="scss">

</style>

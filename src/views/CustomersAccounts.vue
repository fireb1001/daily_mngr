<template>
  <section class="accounts bg-accounts minh90">
    <h1>src-views-customers-accounts Component</h1>
  </section>
</template>

<script >
// import { db } from '../main'
import {OutgoingsDB} from '../db/OutgoingsDB'
export default {
  name: 'accounts',
  data () {
    return {
      daily_customers: []
    }
  },
  methods: {
    async refresh_daily_customers () {
      // TODO get unique daily customers
      OutgoingsDB.getAll({})
    }
  },
  components: {
  },
  mounted() {
    this.refresh_daily_customers()
  }
}
</script>

<style scoped lang="scss">

</style>

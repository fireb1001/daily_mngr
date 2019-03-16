<template>
  <section class="receipts bg-receipts minh90 m-1">
    <h1>src-views-suppliers-receipts Component</h1>

    {{suppliers_arr}}
  </section>
</template>

<script >
import { SuppliersDB } from '../db/SuppliersDB.js'

export default {
  name: 'receipts',
  data () {
    return {
      suppliers_arr: []
    }
  },
  methods: {
    async refresh_daily_suppliers() {
      this.suppliers_arr = await SuppliersDB.getAll({
        last_incoming_day: this.$store.state.day.formated
      })
      console.log(this.suppliers_arr)
    }
  },
  components: {
  },
  mounted() {
    this.refresh_daily_suppliers()
  }
}
</script>

<style scoped lang="scss">

</style>

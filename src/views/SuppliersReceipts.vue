<template>
  <section class="receipts bg-receipts minh90">
    <h1>src-views-suppliers-receipts Component</h1>
  </section>
</template>

<script >
import {SuppliersDB} from '../db/SuppliersDB.js'

export default {
  name: 'receipts',
  data () {
    return {
      suppliers_arr: []
    }
  },
  methods: {
    async refresh_daily_suppliers() {
      // TODO
      this.suppliers_arr = SuppliersDB.getAll({

      })
    }
  },
  components: {
  },
  mounted() {
    this.refresh_daily_suppliers
  }
}
</script>

<style scoped lang="scss">

</style>

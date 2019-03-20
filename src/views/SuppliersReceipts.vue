<template>
  <section class="receipts bg-receipts minh90 p-3">
    <h1> فواتير العملاء - معاملات اليوم</h1>

<router-link  v-for="(supplier, idx) in suppliers_arr" 
:to="{name:'supplier_details', params: {id: supplier.id}}"  :key="idx" 
class="btn btn-lg btn-primary m-1 btn-block">
  <span class="fa fa-receipt"></span> &nbsp; 
  عرض فواتير العميل - {{supplier.name}}
</router-link>

  </section>
</template>

<script >
import { SuppliersDB } from '../db/SuppliersDB.js'
import { IncomingsDB } from '../db/IncomingsDB.js';

export default {
  name: 'receipts',
  data () {
    return {
      suppliers_arr: [],
      store_day: this.$store.state.day
    }
  },
  methods: {
    async refresh_daily_suppliers() {
      // this.suppliers_arr = await SuppliersDB.getAll()
      // last_incoming_day: this.$store.state.day.formate
      // console.log(this.suppliers_arr)
      let unique_daily_suppliers_ids = await IncomingsDB.getDailySuppliers({day: this.store_day.iso})
      this.suppliers_arr = await SuppliersDB.getAll(unique_daily_suppliers_ids)
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

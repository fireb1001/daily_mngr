<template>
  <section class="receipts bg-receipts minh90 p-3">
    <h1> فواتير العملاء - معاملات اليوم</h1>

<router-link  v-for="(supplier, idx) in suppliers_arr" 
:to="{name:'supplier_details', params: {id: supplier.id}}"  :key="idx" 
class="btn btn-lg btn-primary m-1 btn-block" :class="{'btn-danger':suppliers_headers_arr[supplier.id] > 0}">
  <span class="fa fa-receipt"></span> &nbsp; 
  عرض فواتير العميل - {{supplier.name}} 
  <span v-if="suppliers_headers_arr[supplier.id] > 0">
  - متبقي {{suppliers_headers_arr[supplier.id]}} طرد
  </span>
</router-link>

  </section>
</template>

<script >
import { SuppliersDB } from '../db/SuppliersDB.js'
import { IncomingsHeaderDB } from '../db/IncomingsHeaderDB.js';

export default {
  name: 'receipts',
  data () {
    return {
      suppliers_arr: [],
      store_day: this.$store.state.day,
      suppliers_headers_arr : []
    }
  },
  methods: {
    async refresh_daily_suppliers() {
      // this.suppliers_arr = await SuppliersDB.getAll()
      // last_incoming_day: this.$store.state.day.formate
      // console.log(this.suppliers_arr)
      this.suppliers_headers_arr = await IncomingsHeaderDB.getDailySuppliers({day: this.store_day.iso})
      let ids = Object.keys(this.suppliers_headers_arr)
      this.suppliers_arr = await SuppliersDB.getAll(ids)
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

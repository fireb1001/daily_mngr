<template>
  <section class="accounts bg-accounts minh90 p-3">
    <h1>حسابات البائعين - معاملات اليوم</h1>

<router-link  v-for="(customer, idx) in daily_customers" :to="{name:'customer_details', params: {id: customer.id}}"  :key="idx" 
class="btn btn-lg btn-primary m-1 btn-block">
  <span class="fa fa-shopping-cart"></span> &nbsp; 
  عرض حساب البياع - {{customer.name}}
</router-link>

  </section>
</template>

<script >
// import { db } from '../main'
import { OutgoingsDB} from '../db/OutgoingsDB'
import { CustomersDB} from '../db/CustomersDB.js'
export default {
  name: 'accounts',
  data () {
    return {
      store_day: this.$store.state.day,
      daily_customers: []
    }
  },
  methods: {
    async refresh_daily_customers () {
      // TODO get unique daily customers
      let unique_daily_customers_ids = await OutgoingsDB.getDailyCustomers({day: this.store_day.formated})
      this.daily_customers = await CustomersDB.getAll(unique_daily_customers_ids)
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

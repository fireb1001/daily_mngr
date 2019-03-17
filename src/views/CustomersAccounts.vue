<template>
  <section class="accounts bg-accounts minh90 p-3">
    <h1>حسابات البائعين - معاملات اليوم</h1>

    {{ daily_customers }}
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

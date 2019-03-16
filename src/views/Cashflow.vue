<template>
  <section class="cashflow">
    <br/>
      <div class="table-responsive">
        <table class="table table-striped table-sm">
          <thead>
            <tr>
              <th>#</th>
              <th>المبلغ</th>
              <th>من</th>
              <th>نوع</th>
              <th>ملاحظات</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in cashflow_arr" :key='idx'>
              <td>{{item.id}}</td>
              <td>{{item.amount}}</td>
              <td>{{item.actor_name}}</td>
              <td>{{item.state}}</td>
              <td>{{item.notes}}</td>
            </tr>
          </tbody>
        </table>
      </div>
    
  </section>
</template>

<script>
// import { db } from '../main'
import {CashflowDB} from '../db/CashflowDB.js'
export default {
  name: 'cashflow',
  data () {
    return {
      cashflow_arr: []
    }
  },
  firestore () {
    return {}
  },
  methods: {
    async refresh_cashflow_arr() {
      let state = null
      if(this.$route.name == 'expensess') {
        state = ['given','expense']
      }
      else if(this.$route.name == 'collecting') {
        state = 'collecting' // ['given','expense']
      }
      else if (this.$route.name == 'payments') {
        state = ['nolon','payment']
      }
      
      // console.log( this.$route.name ,state)
      this.cashflow_arr = await CashflowDB.getAll({
        // state:this.$route.name
        state: state
      })
    }
  },
  components: {
  },
  mounted() {
    this.refresh_cashflow_arr()
  },
  updated() {
    // this.refresh_cashflow_arr()
  },
  computed: {
    /*
    comp_cashflow_arr : async function() {
      return await CashflowDB.getAll({state:'collecting'})
    }
    */
  },
  watch : {
    "$route": function() {
      this.refresh_cashflow_arr()
    }
  }
}
</script>

<style scoped lang="scss">

</style>

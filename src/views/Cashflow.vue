<template>
  <section class="cashflow m-3">
    <br/>
      <div class="table-responsive">
        <table class="table table-striped table-sm">
          <thead>
            <tr>
              <th>التاريخ</th>
              <th>المبلغ</th>
              <th>
                <span v-if="$route.name == 'expensess'">الي </span>
                <span v-if="$route.name != 'expensess'">من </span>
              </th>
              <th>نوع</th>
              <th>ملاحظات</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in cashflow_arr" :key='idx'>
              <td>{{item.day}}</td>
              <td>{{item.amount}}</td>
              <td>{{item.actor_name}}</td>
              <td>{{app_labels[item.state]}}
                <span v-if="item.d_product"> - {{item.d_product}}</span>
              </td>
              <td>{{item.notes}}</td>
            </tr>
          </tbody>
        </table>
      </div>
    <button class="btn btn-success" v-b-toggle.collapse_cash >اضافة جديد </button>

      <!-- Element to collapse  <div class="m-2"></div>-->
  <b-collapse id="collapse_cash" style="padding:25px;">
    <div class="entry-form">
    <form  @submit="addCashflow">
      <div class="form-group row">
        <label  class="col-sm-2">المبلغ</label>
        <div class="col-sm-10">
          <input v-model="cashflow_form.amount" class="form-control "  placeholder="ادخل مبلغ الدفعة">
        </div>
      </div>
      <div class="form-group row">
        <label  class="col-sm-2">تاريخ الدفعة</label>
        <div class="col-sm-10">
          <datetime v-model="cashflow_form.day" :auto="true" class="datetime" min-datetime="2018-01-01"></datetime>
        </div>
      </div>
      <div class="form-group row">
        <label  class="col-sm-2">ملاحظات</label>
        <div class="col-sm-10">
          <input v-model="cashflow_form.notes" class="form-control " placeholder="ادخال الملاحظات">
        </div>
      </div>     

      <button type="submit" class="btn btn-success" :disabled="! cashflow_form.day || ! cashflow_form.amount">اضافة</button>
      <button type="button" class="btn btn-danger mr-1"  v-b-toggle.collapse_pay >  اغلاق</button>
    </form>
    </div>
  </b-collapse>
  </section>
</template>

<script>
// import { db } from '../main'
import { CashflowDB, CashflowDAO} from '../db/CashflowDB.js'
import { APP_LABELS } from '../main.js'
export default {
  name: 'cashflow',
  data () {
    return {
      cashflow_arr: [],
      cashflow_form: new CashflowDAO(CashflowDAO.INIT_DAO),
      app_labels : APP_LABELS
    }
  },
  firestore () {
    return {}
  },
  methods: {
    async refresh_cashflow_arr() {
      let states = null
      if(this.$route.name == 'expensess') {
        states = ['given','expense','nolon','payment']
      }
      else if(this.$route.name == 'collecting') {
        states = ['collecting','outgoing_cash'] // ['given','expense']
      }
      // else if (this.$route.name == 'payments') { states = []   }
      
      // console.log( this.$route.name ,state)
      this.cashflow_arr = await CashflowDB.getAll({
        // state:this.$route.name
        day: this.$store.state.day.iso,
        states: states
      })
    },
    addCashflow(evt) {
      evt.preventDefault()
      
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

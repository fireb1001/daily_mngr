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
                <span v-if="$route.name == 'expenses'">الي </span>
                <span v-if="$route.name != 'expenses'">من </span>
              </th>
              <th>نوع</th>
              <th>ملاحظات</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in cashflow_arr" :key='idx'>
              <td>{{item.day}}</td>
              <td>{{item.amount}}</td>
              <td>{{item.actor_name}}</td>
              <td>{{app_labels[item.state]}}
                <span v-if="item.d_product"> - {{ item.d_product | productsFilter }}</span>
                <span v-if="item.outgoing_id"> - عدد {{ item.count }} - وزن {{ item.weight }}
                  <span v-if="item.income_day !== store_day.iso " class="text-danger"> 
                    <br>
                      <span class="fa fa-star text-primary"></span> الزرع وارد يوم {{item.income_day | arDate }}
                  </span>
                </span>
              </td>
              <td>{{item.notes}}</td>
              <td>
                <button class="btn text-danger" @click="removeCashflow(item.id)" >
                  <span class="fa fa-archive "></span> 
                  <template v-if="! confirm_step[item.id]"> حذف الحركة</template>
                  <template v-if="confirm_step[item.id]"> تأكيد </template>
                </button>
              </td>
            </tr>
            <tr>
              <td></td>
              <th>{{total_cash}}</th>
              <th>مجموع</th>
              
            </tr>
          </tbody>
        </table>
      </div>
    <button class="btn btn-success" v-b-toggle.collapse_cash >اضافة جديد </button>

      <!-- Element to collapse  <div class="m-2"></div>-->
  <b-collapse id="collapse_cash" class="m-5">
    <div class="entry-form">
    <form  @submit="addCashflow">
      {{cashflow_form.state}}
      <div class="form-group row" v-if="$route.name == 'expenses'"> 
        <label class="col-sm-2" >نوع المصروف</label>
        <div class="col-sm-10">
        <select class="form-control " v-model="cashflow_form.state">
          <option value="expenses">مصروفات يومية</option>
          <option value="men_account">حساب الرجالة</option>
          <option value="act_pymnt">دفعات لا تخصم من الايراد</option>
        </select>
        </div>
      </div>


      <div class="form-group row">
        <label  class="col-sm-2">مبلغ ال{{app_labels[$route.name]}}</label>
        <div class="col-sm-10">
          <div v-if="cashflow_form.state === 'men_account'" class="m-1">
            عدد الطرود المباعة اليوم {{day_count}} X 
            <input v-model="men_rate" class=""  placeholder="بياعة الرجالة">
            <br>
          </div>
          <input v-model="cashflow_form.amount" class="form-control "  placeholder="ادخل المبلغ ">
        </div>
      </div>

      <div class="form-group row">
        <label  class="col-sm-2">ملاحظات</label>
        <div class="col-sm-10">
          <input v-model="cashflow_form.notes" class="form-control " placeholder="ادخال الملاحظات">
        </div>
      </div>     

      <button type="submit" class="btn btn-success" :disabled="! valid_form" >اضافة</button>
      <button type="button" class="btn btn-danger mr-1"  v-b-toggle.collapse_pay >  اغلاق</button>
    </form>
    </div>
  </b-collapse>
  </section>
</template>

<script>
// import { db } from '../main'
import { CashflowDB, CashflowDAO } from '../db/CashflowDB.js'
import { DailyDB } from '../db/DailyDB.js'

import { APP_LABELS } from '../main.js'
export default {
  name: 'cashflow',
  data () {
    return {
      cashflow_arr: [],
      store_day: this.$store.state.day,
      cashflow_form: {state:this.$route.name , amount: null},
      app_labels : APP_LABELS,
      day_count : 0,
      men_rate : 1.5,
      confirm_step:[]
    }
  },
  firestore () {
    return {}
  },
  methods: {
    async refresh_cashflow_arr() {
      let states = null
      if(this.$route.name == 'expenses') {
        states = ['given','expenses','nolon','payment','act_pymnt' ,'recp_paid','paid','acc_rest','repay_cust_trust','men_account','repay_cust_rahn','supp_payment','out_receipt']
      }
      else if(this.$route.name == 'collecting') {
        states = ['collecting','outgoing_cash','supp_collect','cust_trust','cust_rahn'] 
      }
      // else if (this.$route.name == 'payments') { states = []   }
      
      // console.log( this.$route.name ,state)
      this.cashflow_arr = await CashflowDB.getAll({
        // state:this.$route.name
        day: this.$store.state.day.iso,
        states: states
      })
      
      this.day_count = await DailyDB.getTodayCount(this.store_day.iso)
    },
    async removeCashflow(cashflow_id) {
      if( this.confirm_step[cashflow_id] ) {
        await CashflowDB.deleteItem(cashflow_id)
        this.refresh_cashflow_arr()
      }
      else {
        this.confirm_step = []
        this.confirm_step[cashflow_id] = true
      }
    },
    async addCashflow(evt) {
      evt.preventDefault()
      let cashDAO = new CashflowDAO(this.cashflow_form)
      cashDAO.state = (this.cashflow_form.state) ? this.cashflow_form.state : this.$route.name
      cashDAO.day = this.store_day.iso
      if(this.$route.name == 'expenses')
      cashDAO.sum = '-'

      await CashflowDB.addNew(cashDAO)
      this.$root.$emit('bv::toggle::collapse', 'collapse_cash')
      this.cashflow_form = {}
      this.refresh_cashflow_arr()
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
    total_cash : function() {
      let sum = 0
      this.cashflow_arr.forEach(item => {
        sum += parseFloat(item.amount)
      })
      return sum
    },
    valid_form: function() {
      if(this.cashflow_form.amount && parseFloat(this.cashflow_form.amount) ){
        console.log(parseFloat(this.cashflow_form.amount))
        return true
      }
    }
  },
  watch : {
    "$route": function() {
      this.refresh_cashflow_arr()
    },
    "cashflow_form.state": function(val) {
      if(val === 'men_account') {
        this.cashflow_form.amount = this.day_count * this.men_rate
      }
    },
    men_rate: function(newval) {
      this.cashflow_form.amount = this.day_count * newval
    }
  }
}
</script>

<style scoped lang="scss">

</style>

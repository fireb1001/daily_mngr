<template>
  <section class="daily-moves bg-dailymoves p-3">
    <h1 class="text-center"> حركات يومية {{store_day.arab}}</h1>

        <br/>
      <h2>فواتير اليومية</h2>
      <div class="table-responsive">
        <table class="table table-striped table-sm pr-me1">
          <thead>
            <tr>
              <th>اسم العميل</th>
              <th>عدد الطرود</th>
              <th>الاصناف</th>
              <th>عدد المباع</th>
              <th>عدد المتبقي</th>
              <th>اجمالي البياعة</th>
              <th>العمولة</th>
              <th>فرق الفاتورة</th>
              <th>اجمالي</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in daily_receipts" :key='idx'>
              <td>{{item.supplier_name}}</td>
              <td>{{item.total_count}}</td>
              <td>{{item.products_arr | productsFilter }}</td>
              <td>{{item.total_count - item.total_current_rest}}</td>
              <td> 
                <span class="text-danger" v-if="item.total_current_rest">{{item.total_current_rest}}</span>
              </td>
              <td>{{item.total_sell_comm}}</td>
              <td>{{item.recp_comm | round2}}</td>
              <td >
                {{ item.out_sale_value - item.sale_value }}
              </td>
              <td>{{item.total_sell_comm + item.recp_comm}}</td>
              
            </tr>
            <tr>
              <td></td>
              <th>{{recp_sums.count}}</th>
              <th>المجموع</th>
              <td></td>
            </tr>
          </tbody>
        </table>
      </div>

      <hr>

      <h2>مخرجات اليومية</h2>
      <div class="table-responsive">
        <table class="table table-striped table-sm pr-me1">
          <thead>
            <tr>
              <th>المبلغ</th>
              <th>
                الي 
              </th>
              <th>نوع</th>
              <th>ملاحظات</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in cashflow_arr_out" :key='idx'>
              <td>{{item.amount}}</td>
              <td>{{item.actor_name}}</td>
              <td>{{app_labels[item.state]}}
                <span v-if="item.d_product"> - {{ item.d_product | productsFilter }}</span>
              </td>
              <td>{{item.notes}}</td>
            </tr>
            <tr>
              <th>{{total_cash_out}}</th>
              <th>مجموع</th>
              
            </tr>
          </tbody>
        </table>
      </div>

      <hr>

      <h2>مدخلات اليومية</h2>
      <div class="table-responsive">
        <table class="table table-striped table-sm pr-me1">
          <thead>
            <tr>
              <th>المبلغ</th>
              <th>
                من 
              </th>
              <th>نوع</th>
              <th>ملاحظات</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in cashflow_arr_in" :key='idx'>
              <td>{{item.amount}}</td>
              <td>{{item.actor_name}}</td>
              <td>{{app_labels[item.state]}}
                <span v-if="item.d_product"> - {{ item.d_product | productsFilter }}</span>
              </td>
              <td>{{item.notes}}</td>
            </tr>
            <tr>
              <th>{{total_cash_in}}</th>
              <th>مجموع</th>
              
              
            </tr>
          </tbody>
        </table>
      </div>

      <hr>

      <h2>زمامات اليوم</h2>
      <div class="table-responsive">
        <table class="table table-striped table-sm pr-me1">
          <thead>
            <tr>
              <th>#</th>
              <th>عدد</th>
              <th>الصنف</th>
              <th>اسم البياع</th>
              
              <th>السعر</th>
              <th>المبلغ</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in outgoings_today_arr" :key='idx'>
              <td>{{item.id}}</td>
              <td>
                {{item.product_name}}
                - زرع {{item.supplier_name}}
              </td>
              <td>{{item.customer_name}}</td>
              <td>{{item.count}}</td>
              <td>{{item.kg_price}}</td>
              <td>{{item.value_calc}}</td>
            </tr>
            <tr>
              <th></th>
              <th>مجموع الزمام</th>
              <td></td>
              <td></td>
              <td></td>
              <th>{{total_oncredit}}</th>
            </tr>
          </tbody>
        </table>
      </div>

        <button class="btn btn-printo pr-hideme" @click="vue_window.print()">
          <span class="fa fa-print"></span> طباعة 
        </button>
        
  </section>
</template>

<script >
import { ReceiptsDB } from '../db/ReceiptsDB';
import { APP_LABELS } from '../main.js'
import { CashflowDB } from '../db/CashflowDB.js'
import { OutgoingsDB } from '../db/OutgoingsDB';

export default {
  name: 'daily-moves',
  data () {
    return {
      store_day: this.$store.state.day,
      daily_receipts: [],
      cashflow_arr_in: [],
      outgoings_today_arr: [],
      cashflow_arr_out: [],
      app_labels : APP_LABELS
    }
  },
  methods: {
    async refresh_arrs() {
      this.daily_receipts = await ReceiptsDB.getAll({day: this.store_day.iso})

      this.cashflow_arr_out = await CashflowDB.getAll({
        // state:this.$route.name
        day: this.$store.state.day.iso,
        states: ['given','expensess','nolon','payment', 'recp_paid','paid','repay_cust_trust']
      })

      this.cashflow_arr_in = await CashflowDB.getAll({
        // state:this.$route.name
        day: this.$store.state.day.iso,
        states: ['collecting','outgoing_cash','supp_collect','cust_trust'] 
      })

      this.outgoings_today_arr = await OutgoingsDB.getAll({day: this.store_day.iso, customer : '> 0'})
    },
  },
  computed: {
    recp_sums: function() {
      let recp_sums = {count:0 }
      this.daily_receipts.forEach( recp => {
        console.log(recp)
        recp_sums.count += parseInt(recp.total_count)
      })
      return recp_sums
    },
    total_cash_in : function() {
      let sum = 0
      this.cashflow_arr_in.forEach(item => {
        sum += parseFloat(item.amount)
      })
      return sum
    },
    total_cash_out : function() {
      let sum = 0
      this.cashflow_arr_out.forEach(item => {
        sum += parseFloat(item.amount)
      })
      return sum
    },
    total_oncredit: function() {
      let sum = 0
      this.outgoings_today_arr.forEach(item => {
        sum += parseFloat(item.value_calc)
      })
      return sum
    },
  },
  async mounted() {
    this.refresh_arrs()
  },
  components: {
  }
}
</script>

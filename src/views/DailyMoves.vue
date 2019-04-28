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
              <th>الاصناف</th>
              <th>طرود مباعة</th>
              <th>البياعة</th>
              <th>العمولة</th>
              <th>بياعة + عمولة</th>
              <th>فرق الفاتورة</th>
              <th>النوالين</th>
              <th>مصاريف </th>
              <th>وهبة </th>
              <th>صافي </th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in daily_receipts" :key='idx'>
              <td>
                {{item.supplier_name}}
                <br/>
                <b>فاتورة {{app_labels.recps[item.recp_paid]}}</b>
              </td>
               <!--
              <td>{{item.total_count}}</td>
              -->
              <td v-html="$options.filters.productsFilter(item.products_arr,'<br/> , ')"></td>
              
              <td>{{item.total_count - item.total_current_rest}}</td>
              <!--
              <td> 
                <span class="text-danger" v-if="item.total_current_rest">{{item.total_current_rest}}</span>
              </td>
              -->
              <td>{{item.total_sell_comm}}</td>
              <td>{{item.recp_comm | round2}}</td>
              <td>{{item.total_sell_comm + item.recp_comm}}</td>
              <td >
                <span v-if="(item.out_sale_value - item.sale_value) > 0">+</span>
                {{ item.out_sale_value - item.sale_value }}
              </td>
              
              <td>{{item.total_nolon}}</td>
              <td>{{item.recp_expenses}}</td>
              <td>{{item.recp_given}}</td>
              <td>{{item.net_value}}</td>
            </tr>
            <tr>
              <td></td>
              <!--
              <th>{{recp_sums.count}}</th>
              -->
              <th>المجموع</th>
              <td></td>
              <td></td>
              <td></td>
              <td>{{recp_sums.total_comms}}</td>
              <th>
                <span v-if="recp_sums.diff  > 0">+</span>
                {{recp_sums.diff}}
              </th>
              <th>{{recp_sums.total_nolons_sum}}</th>
              <th></th>

            </tr>
          </tbody>
        </table>
      </div>
        <hr>
        <div>
          <h4>اجمالي فواتير الرصد فقط : {{recp_sums.total_rasd_net}}</h4>
        </div>

        <hr>
        <div>
          <h4>اجمالي ايرادات اليوم : {{recp_sums.total_income}}</h4>
        </div>

<h2>مصروفات تخصم من الايراد </h2>
      <div class="table-responsive">
        <table class="table table-striped table-sm pr-me1">
          <thead>
            <tr>
              <th>المبلغ</th>
              <th>نوع</th>

            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in cashflow_exp_arr_out" :key='idx'>
              <td>{{item.amount}}</td>

              <td>{{app_labels[item.state]}} {{item.actor_name}}
                <span v-if="item.d_product"> - {{ item.d_product | productsFilter }}</span> 
              {{item.notes}}
              </td>
            </tr>
            <tr>
              <th>{{total_exp_out}}</th>
              <th>مجموع المصروفات المخصومة من الايراد</th>
            </tr>
          </tbody>
        </table>
      </div>

        <hr>
        <div>
          <h4>صافي ايرادات اليوم : {{recp_sums.total_income - total_exp_out}}</h4>
        </div>
<hr>
      <h2>زمامات اليوم</h2>
      <div class="table-responsive">
        <table class="table table-striped table-sm pr-me1">
          <!--
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
          -->
          <tbody>
            <!--
            <tr v-for="(item, idx) in outgoings_today_arr" :key='idx'>
              <td>{{item.value_calc}}</td>
              <td>
                {{item.product_name}}
                - زرع {{item.supplier_name}}
              </td>
              <td>{{item.customer_name}}</td>
              <td>{{item.count}}</td>
              <td>{{item.kg_price}}</td>
              
            </tr>
            -->
            <tr>
              <th>{{total_oncredit}}</th>
              <th>مجموع الزمام</th>
              <td></td>
              <td></td>
              <td></td>
              
            </tr>
          </tbody>
        </table>
      </div>

      <hr>

      <h2>تحصيلات اليوم</h2>
      <div class="table-responsive">
        <table class="table table-striped table-sm pr-me1">
          <!--
          <thead>
            <tr>
              <th>المبلغ</th>
              <th>
                من 
              </th>
              <th></th>

            </tr>
          </thead>
          -->
          <tbody>
            <template v-for="(item, idx) in cashflow_arr_in"  >
              <tr v-if="false && (item.state ==='collecting' && item.actor_id )" :key='idx'>
                <td>{{item.amount}}</td>
                <td>{{item.actor_name}}</td>
                <td>{{app_labels[item.state]}}
                  <span v-if="item.d_product"> - {{ item.d_product | productsFilter }}</span>
                </td>
              </tr>
            </template>
            <tr>
              <th>{{total_cash_collect}}</th>
              <th>مجموع تحصيلات اليوم</th>
              
              
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
                <span v-if=" item.d_product"> - {{ item.d_product | productsFilter }}</span>
                <span v-if="false && item.outgoing_id"> - عدد {{ item.count }} - وزن {{ item.weight }}
                  <span v-if="item.income_day !== store_day.iso " class="text-danger"> 
                    <br>
                      <span class="fa fa-star text-primary"></span> الزرع وارد يوم {{item.income_day | arDate }}
                  </span>
                </span>
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
      cashflow_exp_arr_out: [],
      app_labels : APP_LABELS
    }
  },
  methods: {
    async refresh_arrs() {
      this.daily_receipts = await ReceiptsDB.getAll({day: this.store_day.iso})

      this.cashflow_arr_out = await CashflowDB.getAll({
        // state:this.$route.name
        day: this.$store.state.day.iso,
        states: ['given','expenses','nolon','payment', 'recp_paid','paid','acc_rest','repay_cust_trust','men_account','repay_cust_rahn','supp_payment','out_receipt']
      })

      this.cashflow_exp_arr_out = await CashflowDB.getAll({
        // state:this.$route.name
        day: this.$store.state.day.iso,
        states: ['given','expenses','men_account']
      })

      this.cashflow_arr_in = await CashflowDB.getAll({
        // state:this.$route.name
        day: this.$store.state.day.iso,
        states: ['collecting','outgoing_cash','supp_collect','cust_trust','cust_rahn'] 
      })

      this.outgoings_today_arr = await OutgoingsDB.getAll({day: this.store_day.iso, customer : '> 0'})
    },
  },
  computed: {
    recp_sums: function() {
      let recp_sums = {count:0, diff:0, total_nolons_sum: 0  , total_net_value: 0, total_rasd_net: 0
      , total_income: 0, total_comms: 0 }
      this.daily_receipts.forEach( recp => {
        recp_sums.count += parseInt(recp.total_count)
        recp_sums.diff += ( recp.out_sale_value - recp.sale_value )
        recp_sums.total_nolons_sum += recp.total_nolon
        recp_sums.total_net_value += recp.net_value
        recp_sums.total_income += recp.total_sell_comm + recp.recp_comm + ( recp.out_sale_value - recp.sale_value )
        recp_sums.total_comms += recp.total_sell_comm + recp.recp_comm 
        if(recp.recp_paid == 1)
          recp_sums.total_rasd_net += recp.net_value
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
    total_cash_collect: function() {
      let sum = 0
      this.cashflow_arr_in.forEach(item => {
        if(item.state === 'collecting')
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
    total_exp_out: function() {
      let sum = 0
      this.cashflow_exp_arr_out.forEach(item => {
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

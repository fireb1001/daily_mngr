<template>
  <section class="customer-details p-3 bg-accounts pr-me">
    <button class="btn btn-primary d-print-none" @click="$router.go(-1)">العودة</button>
    <h3 class="d-inline-block mr-3">حساب البائع : {{customer.name}}</h3>

      <table class="table table-bordered mt-1" v-if=" ! customer.is_self">
        <tr>
          <th>تليفون البياع</th>
          <td>{{customer.phone}}</td>
        </tr>
        <tr>
          <th>عنوان البياع</th>
          <td>{{customer.address}}</td>
        </tr>
      </table>
      <h3 class="text-center"> الزرع المتبقي في حساب المحل </h3>
      <div class=" row d-print-none p-1 "  v-if="customer.is_self">
        <button v-for="(item, idx) in self_rest_products" :key="idx" 
        v-b-toggle.collapse_sell  @click="sell_rest = item"
        class="btn btn-lg btn-primary m-1 btn-block">
          <span class="fa fa-shopping-cart"></span> &nbsp; 
          {{item.product_name}}  - 
          عدد ({{item.count}}) - السعر التقديري {{item.amount}}
        </button>
      </div>
        <b-collapse id="collapse_sell" class="d-print-none p-1">
          <div class="entry-form">
          <form  @submit="sellRest" class="m-2">
            <div class="form-group row">
              <label  class="col-sm-2">السعر الفعلي</label>
              <div class="col-sm-10">
                <input v-model="sell_rest.actual_sale" class="form-control "  placeholder="ادخل مبلغ البيع">
              </div>
            </div>
            <div class="form-group row">
              <label  class="col-sm-2">ملاحظات</label>
              <div class="col-sm-10">
                <input v-model="sell_rest.notes" class="form-control " placeholder="ادخال الملاحظات">
              </div>
            </div>
            <button type="submit" class="btn btn-success" :disabled="! sell_rest.amount">تحصيل</button>
          </form>
          </div>
        </b-collapse>
    <hr/>
        <table class="table table-striped ">
          <thead>
            <tr>
              <th>التاريخ</th>
              <th>الحركة</th>
              <th>المبلغ</th>
              <th>باقي</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(trans, idx) in customer_trans" :key='idx'>
              <td>{{trans.day}}</td>
              <td>
                {{labels.trans[trans.trans_type]}}
                <span v-if="trans.trans_type === 'outgoing'"> - {{trans.product_name}}</span>
                <span v-if="trans.notes">- {{trans.notes}} </span> 
              </td>
              <td>{{trans.amount}}</td>
              <td>{{trans.debt_after}}</td>
            </tr>
            <tr>
              <td></td>
              <td>رصيد المديونية الحالي</td>
              <td></td>
              <td>
                <b>{{customer.debt}}</b>
              </td>
            </tr>
          </tbody>
        </table>
  <button v-b-toggle.collapse_collect class="btn btn-success m-1 d-print-none">
    <span class="fa fa-credit-card"></span> &nbsp; 
    تحصيل مبلغ
  </button>
        <button class="btn btn-printo pr-hideme m-1" 
        @click="clipboard.writeText('حساب البائع '+ customer.name);vue_window.print()">
          <span class="fa fa-print"></span> طباعة
        </button>

  <!-- Element to collapse -->
  <b-collapse id="collapse_collect" class="d-print-none p-1">
    <div class="entry-form">
    <form  @submit="addCollecting" class="m-2">
      <div class="form-group row">
        <label  class="col-sm-2">المبلغ</label>
        <div class="col-sm-10">
          <input v-model="collect_form.amount" class="form-control "  placeholder="ادخل المبلغ المحصل">
        </div>
      </div>
      <div class="form-group row">
        <label  class="col-sm-2">ملاحظات</label>
        <div class="col-sm-10">
          <input v-model="collect_form.notes" class="form-control " placeholder="ادخال الملاحظات">
        </div>
      </div>
      <button type="submit" class="btn btn-success" :disabled="! collect_form.amount">تحصيل</button>
    </form>
    </div>
  </b-collapse>
  </section>
</template>

<script >
import { CustomersDB, CustomerDAO } from '../db/CustomersDB.js'
import { CustomerTransDB } from '../db/CustomerTransDB.js';
import { APP_LABELS } from '../main.js';
import { CashflowDAO, CashflowDB } from '../db/CashflowDB.js';
import { clipboard } from 'electron';

export default {
  name: 'customer-details',
  data () {
    return {
      customer: {},
      collect_form: {},
      store_day: this.$store.state.day,
      customer_trans: [],
      self_rest_products: [],
      customer_id: this.$route.params.id,
      labels: APP_LABELS,
      clipboard: clipboard,
      sell_rest: {actual_sale: 0 , notes: ''}
    }
  },
  methods: {
    async getCustomerDetails() {
      let customer_obj = await CustomersDB.getDAOById(this.customer_id)
      this.customer = {} // empty
      //console.log(customer_obj)
      this.customer = new CustomerDAO(customer_obj)
      this.customer_trans = []
      this.customer_trans = await CustomerTransDB.getAll({customer_id: this.customer_id})
      //console.log("is_self", this.customer)
      this.self_rest_products = []
      if(this.customer.is_self ) {
        
        this.customer_trans.forEach( item => {
          if(!item.actual_sale && item.product_id && item.count)
            this.self_rest_products.push(item)
        })
      }
    },
    async sellRest(evt) {
      evt.preventDefault()

      let cashDAO = new CashflowDAO(CashflowDAO.COLLECTING_DAO)
      cashDAO.day = this.store_day.iso
      cashDAO.amount = parseFloat(this.sell_rest.actual_sale)
      cashDAO.actor_id = this.customer_id
      cashDAO.actor_name = this.customer.name
      cashDAO.notes = this.sell_rest.notes
      cashDAO.id = await CashflowDB.addNew(cashDAO)
      cashDAO.amount = - (cashDAO.amount)
      await CustomersDB.updateDebtOnly(this.customer_id, cashDAO.amount)

      await CustomerTransDB.saveById(this.sell_rest.id, {
        actual_sale: this.sell_rest.actual_sale,
        notes: this.sell_rest.notes
      })
      this.getCustomerDetails()
      this.collect_form = {}
      this.sell_rest = {actual_sale: 0 , notes: ''}
      this.$root.$emit('bv::toggle::collapse', 'collapse_sell')
    },
    async addCollecting(evt ) {
      evt.preventDefault()
      let cashDAO = new CashflowDAO(CashflowDAO.COLLECTING_DAO)
      cashDAO.day = this.store_day.iso
      cashDAO.amount = parseFloat(this.collect_form.amount)
      cashDAO.actor_id = this.customer_id
      cashDAO.actor_name = this.customer.name
      cashDAO.notes = this.collect_form.notes
      cashDAO.id = await CashflowDB.addNew(cashDAO)
      cashDAO.amount = - (cashDAO.amount)
      await CustomersDB.updateDebt(this.customer_id, cashDAO)

      this.getCustomerDetails()
      this.collect_form = {}
      this.$root.$emit('bv::toggle::collapse', 'collapse_collect')
      /*
      let transDAO = new CustomerTransDAO(CustomerTransDAO.COLLECTING_DAO)
      transDAO.cashflow_id = cash_id
      transDAO.amount = cashDAO.amount
      await CustomerTransDB.addNew(transDAO)
      */
    }
  },
  components: {
  },
  mounted() {
    this.getCustomerDetails()
  }
}
</script>

<style scoped lang="scss">

</style>

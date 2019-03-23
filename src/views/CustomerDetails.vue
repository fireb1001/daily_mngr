<template>
  <section class="customer-details p-3 bg-accounts">
    <h3>حساب البياع : {{customer.name}}</h3>
      <table class="table table-bordered">
        <tr>
          <th>تليفون البياع</th>
          <td>{{customer.phone}}</td>
        </tr>
        <tr>
          <th>عنوان البياع</th>
          <td>{{customer.address}}</td>
        </tr>

      </table>
      <div class="m-2">
        <button class="btn btn-primary" @click="$router.go(-1)">العودة</button>
      </div>

    <hr/>
        <table class="table table-striped ">
          <tbody>
            <tr v-for="(trans, idx) in customer_trans" :key='idx'>
              <td>{{trans.day}}</td>
              <td>{{labels.trans[trans.trans_type]}}</td>
              <td>{{trans.amount}}</td>
            </tr>
            <tr>
              <td></td>
              <td>رصيد المديونية الحالي</td>
              <td>
                <b>{{customer.debt}}</b>
              </td>
            </tr>
          </tbody>
        </table>
  <button v-b-toggle.collapse2 class="btn btn-primary m-1">
    <span class="fa fa-credit-card"></span> &nbsp; 
    تحصيل مبلغ
  </button>


  <!-- Element to collapse -->
  <b-collapse id="collapse2" style="padding:25px;">
    <div class="entry-form">
    <form  @submit="addCollecting">
      <div class="form-group row">
        <label  class="col-sm-2">المبلغ</label>
        <div class="col-sm-10">
          <input v-model="collect_form.amount" class="form-control "  placeholder="ادخل المبلغ المحصل">
        </div>
      </div>
      <button type="submit" class="btn btn-success">تحصيل</button>
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

export default {
  name: 'customer-details',
  data () {
    return {
      customer: {},
      collect_form: {},
      store_day: this.$store.state.day,
      customer_trans: [],
      customer_id: this.$route.params.id,
      labels: APP_LABELS
    }
  },
  methods: {
    async getCustomerDetails() {
      let customer_obj = await CustomersDB.getDAOById(this.customer_id)
      this.customer = {} // empty
      console.log(customer_obj)
      this.customer = new CustomerDAO(customer_obj)
      this.customer_trans = []
      this.customer_trans = await CustomerTransDB.getAll({customer_id: this.customer_id})
    },
    async addCollecting(evt ) {
      evt.preventDefault()
      let cashDAO = new CashflowDAO(CashflowDAO.COLLECTING_DAO)
      cashDAO.day = this.store_day.iso
      cashDAO.amount = parseFloat(this.collect_form.amount)
      cashDAO.actor_id = this.customer_id
      cashDAO.actor_name = this.customer.name
      await CashflowDB.addNew(cashDAO)
      cashDAO.amount = - (cashDAO.amount)
      await CustomersDB.updateDebt(this.customer_id, cashDAO)

      this.getCustomerDetails()
      this.collect_form = {}
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

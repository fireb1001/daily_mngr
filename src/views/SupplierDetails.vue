<template>
  <section class="suppliers bg-receipts p-3">
      <h3>ملف العميل : {{supplier.name}}</h3>

      <table class="table table-bordered">
        <tr>
          <th>تليفون العميل</th>
          <td>{{supplier.phone}}</td>
        </tr>
        <tr>
          <th>عنوان العميل</th>
          <td>{{supplier.address}}</td>
        </tr>

      </table>
      <div class="m-2">
        <button class="btn btn-primary" @click="$router.go(-1)">العودة</button>
      </div>

  <button v-b-toggle.collapse_pay class="btn btn-primary m-1">
    <span class="fa fa-money-bill-wave"></span> &nbsp; 
    اضافة دفعات سابقة 
  </button>


  <!-- Element to collapse -->
  <b-collapse id="collapse_pay" style="padding:25px;">
    <div class="entry-form">
    <form  @submit="addPayments">
      <div class="form-group row">
        <label  class="col-sm-2">المبلغ</label>
        <div class="col-sm-10">
          <input v-model="trans_form.amount" class="form-control "  placeholder="ادخل الدفعة">
        </div>
      </div>
      <button type="submit" class="btn btn-success">اضافة</button>
    </form>
    </div>
  </b-collapse>
  <br/>
    <h2>اجماليات وارد اليوم {{store_day.iso}}</h2>
      <div class="table-responsive">
        <table class="table table-striped table-sm">
          <thead>
            <tr>
              <th>#</th>
              <th>الصنف</th>
              <th>عدد الطرود</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(incom, idx) in incomings_headers_today" :key='idx'>
              <td></td>
              <td>{{incom.product_name}}</td>
              <td>{{incom.total_count}}</td>
            </tr>
          </tbody>
        </table>
      </div>
  <hr>
      <h2>اجماليات بيع اليوم {{store_day.iso}}</h2>
      <div class="table-responsive">
        <table class="table table-striped table-sm">
          <thead>
            <tr>
              <th>#</th>
              <th>الصنف</th>
              <th>عدد الطرود</th>
              <th>اجمالي الوزن</th>
              <th>سعر الكيلو</th>
              <th>سعر البيع</th>
              <th>البيع + العمولة</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in outgoings_headers_today" :key='idx'>
              <td></td>
              <td>{{item.product_name}}</td>
              <td>{{item.total_count}}</td>
              <td>{{item.total_weight}}</td>
              <td>{{item.kg_price}}</td>
              <td>{{item.total_weight * item.kg_price }}</td>
              <td>{{item.total_value}}</td>
            </tr>
          </tbody>
        </table>
      </div>
  </section>
</template>

<script >
import { SuppliersDB, SupplierDAO } from '../db/SuppliersDB.js'
import { OutgoingsHeaderDB } from '../db/OutgoingsHeaderDB.js';
import { IncomingsHeaderDB } from '../db/IncomingsHeaderDB.js';

export default {
  name: 'supplier-details',
  data () {
    return {
      supplier: {},
      store_day: this.$store.state.day,
      trans_form: {},
      outgoings_headers_today: [],
      incomings_headers_today: []
    }
  },
  methods: {
    async getSupplierDetails() {
      let supp_obj = await SuppliersDB.getDAOById(this.$route.params.id)
      this.supplier = new SupplierDAO(supp_obj)
      this.incomings_headers_today = await IncomingsHeaderDB.getAll({
        day: this.store_day.iso,
        supplier_id: this.supplier.id
      })

      this.outgoings_headers_today = await OutgoingsHeaderDB.getAll({
        day: this.store_day.iso,
        supplier_id: this.supplier.id
      })
    },
    async addPayments(evt){
      evt.preventDefault()
      this.getSupplierDetails()
    }
  },
  computed: {
  },
  components: {
  },
  mounted() {
    this.getSupplierDetails()
  }
}
</script>


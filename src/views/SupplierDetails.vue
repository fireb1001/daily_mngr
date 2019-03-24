<template>
  <section class="suppliers bg-receipts p-3">
    <section v-if="show_details">
      <button class="btn btn-primary" @click="$router.go(-1)">العودة</button>
      <h3 class="d-inline-block mr-3">ملف العميل : {{supplier.name}}</h3> 

      <table class="table table-bordered mt-1">
        <tr>
          <th>تليفون العميل</th>
          <td>{{supplier.phone}}</td>
        </tr>
        <tr>
          <th>عنوان العميل</th>
          <td>{{supplier.address}}</td>
        </tr>
        <tr>
          <th>الرصيد الحالي</th>
          <td>
            {{supplier.balance}}
            <button v-b-toggle.collapse_pay class="btn btn-success ">
              <span class="fa fa-money-bill-wave"></span> &nbsp; 
              اضافة دفعات سابقة 
            </button>
          </td>
        </tr>
      </table>
      
  <!-- Element to collapse  <div class="m-2"></div>-->
  <b-collapse id="collapse_pay" style="padding:25px;">
    <div class="entry-form">
    <form  @submit="addPayments">
      <div class="form-group row">
        <label  class="col-sm-2">المبلغ</label>
        <div class="col-sm-10">
          <input v-model="trans_form.amount" class="form-control "  placeholder="ادخل مبلغ الدفعة">
        </div>
      </div>
      <div class="form-group row">
        <label  class="col-sm-2">تاريخ الدفعة</label>
        <div class="col-sm-10">
          <datetime v-model="trans_form.day" :auto="true" class="datetime" min-datetime="2018-01-01"></datetime>
        </div>
      </div>
      <div class="form-group row">
        <label  class="col-sm-2">ملاحظات</label>
        <div class="col-sm-10">
          <input v-model="trans_form.notes" class="form-control "  placeholder="ادخال الملاحظات">
        </div>
      </div>
      <button type="submit" class="btn btn-success">اضافة</button>
    </form>
    </div>
  </b-collapse>

    <h2>اجماليات وارد اليوم {{store_day.iso}}</h2>
      <div class="table-responsive">
        <table class="table table-striped table-sm">
          <thead>
            <tr>
              <th>#</th>
              <th>الصنف</th>
              <th>عدد الطرود</th>
              <th>متبقي</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(incom, idx) in incomings_headers_today" :key='idx'>
              <td></td>
              <td>{{incom.product_name}}</td>
              <td>{{incom.total_count}}</td>
              <td>{{incom.current_count}}</td>
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
              <th>المبلغ</th>

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
            </tr>
          </tbody>
        </table>
      </div>
      <!-- -->
      <h4 class="text-danger" v-if="total_current_rest > 0"> عدد الطرود المتبقية التي لم يتم بيعها حتي الان {{ total_current_rest }} طرد</h4>
      <button @click="show_details = false"
      class="btn m-1" :class="{'btn-danger':  total_current_rest > 0 , 'btn-success':  total_current_rest == 0}">
        <span class="fa fa-receipt"></span> &nbsp; 
        انشاء فاتورة
      </button>
      </section>
      <section v-if="! show_details">
        <h4 class="text-danger text-center"> فاتورة </h4>
        <p>
          تحريراً في {{store_day.arab}}
        </p>
        <p>
          المطلوب من السيد/ {{supplier.name}}
        </p>
      <div class="table-responsive">
        <table class="table table-striped table-sm">
          <thead>
            <tr>
              <th>الاجمالي</th>
              <th>عدد الطرود</th>
              <th> الوزن</th>
              <th> </th>
              <th>سعر الكيلو</th>
              <th>الصنف</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in outgoings_headers_today" :key='idx'>
              <td>
                {{item.recp_kg_price *  item.recp_weight }}
              </td>
              <td>{{item.total_count}}</td>
              <td>{{item.recp_weight}}</td>
              <td>X</td>
              <td>
                <input v-model="item.recp_kg_price" class="form-control"  >

              </td>
              <td>{{item.product_name}}</td>
            </tr>
            <tr>
              <td ><b class="border-top border-primary">{{calc_receipt.total}} </b></td>
            </tr>
          </tbody>
        </table>
      </div>
      <button @click="show_details = true" class="btn btn-primary m-1" >
        العودة
      </button>
      </section>
  </section>
</template>

<script >
import { SuppliersDB, SupplierDAO } from '../db/SuppliersDB.js'
import { OutgoingsHeaderDB } from '../db/OutgoingsHeaderDB.js';
import { IncomingsHeaderDB } from '../db/IncomingsHeaderDB.js';
import { DateTime } from '../main.js'

export default {
  name: 'supplier-details',
  data () {
    return {
      supplier: {},
      supplier_id: this.$route.params.id,
      show_details: true,
      store_day: this.$store.state.day,
      trans_form: {},
      receipt: {cols: [], comm: 0, nolon: 0 ,receipt_given:0, total: 0 },
      outgoings_headers_today: [],
      incomings_headers_today: []
    }
  },
  methods: {
    async getSupplierDetails() {
      let supp_obj = await SuppliersDB.getDAOById(this.supplier_id)
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
      this.trans_form.day = DateTime.fromISO(this.trans_form.day).toISODate()
      await SuppliersDB.updateBalance(this.supplier_id,this.trans_form)
      this.trans_form = {}
      this.getSupplierDetails()
    }
  },
  computed: {
    total_current_rest: function() {
      let sum =0 
      this.incomings_headers_today.forEach(item =>{
        sum += parseInt(item.current_count)
      })
      return sum
    },
    calc_receipt: function(){
      let sum =0 
      this.outgoings_headers_today.forEach(item =>{
        sum += parseFloat(item.recp_weight) * parseFloat(item.recp_kg_price)
      })
      let calc = {total: sum}
      return calc
    }
  },
  components: {
  },
  mounted() {
    this.getSupplierDetails()
  }
}
</script>


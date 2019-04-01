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
            <div class="row">
              <span class="col">
                {{supplier.balance}}
                <span class="text-primary mr-3"  v-if="! show_payments" @click="show_payments = true">عرض الدفعات</span>
              </span>
            
              <button v-b-toggle.collapse_pay class="col btn btn-success ml-3 mr-3">
                <span class="fa fa-money-bill-wave"></span> &nbsp; 
                اضافة دفعات سابقة 
              </button>
            </div>
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
          <input v-model="trans_form.notes" class="form-control " placeholder="ادخال الملاحظات">
        </div>
      </div>     

      <button type="submit" class="btn btn-success" :disabled="! trans_form.day || ! trans_form.amount">اضافة</button>
      <button type="button" class="btn btn-danger mr-1"  v-b-toggle.collapse_pay >  اغلاق</button>
    </form>
    </div>
  </b-collapse>

    <div class="table-responsive" v-if="show_payments">
      <h2>دفعات العميل {{supplier.name}}</h2>
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
            <tr v-for="(payment, idx) in supplier_payments" :key='idx'>
              <td>{{payment.day}}</td>
              <td>
                {{labels.payments[payment.trans_type]}}
                <span v-if="payment.notes">- {{payment.notes}} </span>
              </td>
              <td>{{payment.amount}}</td>
              <td>{{payment.balance_after}}</td>
            </tr>
            <tr>
              <td></td>
              <td>رصيد العميل الحالي</td>
              <td>
                <b>{{supplier.balance}}</b>
              </td>
            </tr>
          </tbody>
        </table>
        <div class="text-center">
          <b class="text-danger" @click="show_payments = false">اغلاق الدفعات</b>
        </div>
    </div>

    <div class="table-responsive" v-if="! show_payments">
      <h2>اجماليات وارد اليوم {{store_day.iso}}</h2>
      <table class="table table-striped table-sm">
        <thead>
          <tr>
            <th>#</th>
            <th>الصنف</th>
            <th>عدد الطرود</th>
            
            <th>متبقي</th>
            <th>اجمالي النولون</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(incom, idx) in incomings_headers_today" :key='idx'>
            <td></td>
            <td>{{incom.product_name}}</td>
            <td>{{incom.total_count}}</td>
            
            <td>{{incom.current_count}}</td>
            <td>{{incom.inc_total_nolon}}</td>
          </tr>
        </tbody>
      </table>
    </div>

    <hr>
      
    <div class="table-responsive" v-if="! show_payments">
      <h2>اجماليات بيع اليوم {{store_day.iso}}</h2>
      <table class="table table-striped table-sm">
        <thead>
          <tr>
            <th>#</th>
            <th>الصنف</th>
            <th>عدد الطرود</th>
            <th>اجمالي الوزن</th>
            <th> سعر الكيلو
              (بيع)
            </th>
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

        <div v-if="! show_payments">
          <!-- -->
          <h4 class="text-danger" v-if="inc_sums.c_total_current_rest > 0"> عدد الطرود المتبقية التي لم يتم بيعها حتي الان {{ inc_sums.c_total_current_rest }} طرد</h4>
          <button @click="show_details = false"
          class="btn m-1" :class="{'btn-danger':  inc_sums.c_total_current_rest > 0 , 'btn-success':  inc_sums.c_total_current_rest == 0}">
            <span class="fa fa-receipt"></span> &nbsp; 
            انشاء فاتورة
          </button>
        </div>
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
              <th>سعر الكيلو
                (فاتورة)
              </th>
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
import { SupplierTransDB } from '../db/SupplierTransDB.js';
import { APP_LABELS } from '../main.js';

export default {
  name: 'supplier-details',
  data () {
    return {
      supplier: {},
      supplier_id: this.$route.params.id,
      show_details: true,
      show_payments : false,
      store_day: this.$store.state.day,
      trans_form: {},
      receipt: {cols: [], comm: 0, nolon: 0 ,receipt_given:0, total: 0 },
      outgoings_headers_today: [],
      incomings_headers_today: [],
      supplier_payments: [],
      labels: APP_LABELS
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

      this.supplier_payments = await SupplierTransDB.getAll({supplier_id: this.supplier.id})
    },
    async addPayments(evt){
      evt.preventDefault()
      this.trans_form.day = DateTime.fromISO(this.trans_form.day).toISODate()
      await SuppliersDB.updateBalance(this.supplier_id,this.trans_form)
      this.trans_form = {}
      this.$root.$emit('bv::toggle::collapse', 'collapse_pay')
      this.getSupplierDetails()
    }
  },
  computed: {
    inc_sums: function() {
      let inc_sums ={c_total_current_rest:0 , c_total_inc_nolon: 0}
      this.incomings_headers_today.forEach(item =>{
        inc_sums.c_total_current_rest += parseInt(item.current_count)
        inc_sums.c_total_inc_nolon += parseFloat(item.inc_total_nolon)
      })
      return inc_sums
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


<template>
  <section class="suppliers bg-receipts p-3">
    <section v-if="show_details">

      <button class="btn btn-primary pr-hideme" @click="$router.go(-1)">العودة</button>
      <h2 class="d-inline-block mr-3 ">ملف العميل : {{supplier.name}}</h2> 
      <br>
      <div class="pr-mt-2"></div>
      <table class="table table-bordered mt-1 pr-hideme">
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
  <b-collapse id="collapse_pay" style="padding:25px;" class="pr-hideme">
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
      <h3 class="m-3">سجل دفعات العميل </h3>
        <table class="table table-striped pr-me">
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
          <button class="btn btn-printo pr-hideme" @click="vue_window.print()">
            <span class="fa fa-print"></span> طباعة الدفعات
          </button>
          <b class="text-danger pr-hideme m-3" @click="show_payments = false">اغلاق الدفعات</b>
        </div>
    </div>

    <h4 class="text-danger" v-if="inc_sums.c_total_current_rest > 0"> عدد الطرود المتبقية التي لم يتم بيعها حتي الان {{ inc_sums.c_total_current_rest }} طرد</h4>
    <button @click="show_details = false;initReceipt()" class="btn m-1 pr-hideme"
      :class="{'btn-danger':  inc_sums.c_total_current_rest > 0 , 'btn-success':  inc_sums.c_total_current_rest == 0}">
      <span class="fa fa-receipt"></span> &nbsp; 
      الفواتير
    </button>

    <div class="table-responsive" v-if="! show_payments">
      <h3>اجماليات وارد اليوم {{store_day.iso}}</h3>
      <table class="table table-striped table-sm pr-me">
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
          <tr v-for="(incom, idx) in incomings_headers_today" :key='idx' :class="{'text-danger':incom.current_count > 0}">
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
    <div class="pr-mt-2"></div>
    <div class="table-responsive" v-if="! show_payments">
      <h3>اجماليات بيع اليوم {{store_day.iso}}</h3>
      <table class="table table-striped table-sm pr-me">
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
            <td>{{item.sold_count}}</td>
            <td>{{item.total_weight}}</td>
            <td>{{item.kg_price}}</td>
            <td>{{item.total_weight * item.kg_price }}</td>
          </tr>
        </tbody>
      </table>
    </div>

        <div v-if="! show_payments">
          <button class="btn btn-printo pr-hideme" @click="vue_window.print()">
            <span class="fa fa-print"></span> طباعة الاجماليات
          </button>

        </div>
      </section>

      <section v-if="! show_details && show_receipt">
        <h1 class="text-danger text-center"> أولاد الحاج/ مصطفي ندا مصطفي</h1>
        <h1 class="text-primary text-center">الأستاذ / جمــال نــدا</h1>
        <h4 class="text-danger text-center"> لتجارة وتسويق الفاكهة </h4>
        <h5 class="text-primary text-center">
          سوق العبور - القاهرة - محل رقم 150 عنبر 4 فاكهة س.ت :284040
        </h5>
        <h5 class="text-primary text-center">
          ت : 4470350 المعلم سلامة : 01118357750 الأستاذ محمد : 01023929223
        </h5>
        <h3 class="text-danger text-center"> فاتـورة # {{receipt.id}}</h3>
        <p class="pr-me">
          تحريراً في {{store_day.arab}}
          <br/>
          المطلوب من السيد/ {{supplier.name}}
        </p>
      <div class="table-responsive p-2" style="border: 2px solid #79ace0; border-radius: 12px;">
        <table class="table table-bordered table-sm pr-me" >
          <thead>
            <tr>
              <th>الاجمالي</th>
              <th>عدد المباع</th>
              <th> الوزن</th>
              <th> </th>
              <th>سعر الكيلو
                <span v-if="! print_mode">(فاتورة)</span>
              </th>
              <th>الصنف</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in outgoings_headers_today" :key='idx'>
              <td>
                {{item.recp_kg_price *  item.recp_weight | round2}}
              </td>
              <td>{{item.sold_count}}</td>
              <td>{{item.recp_weight}}</td>
              <td>X</td>
              <td style="width:20%">
                <input v-model="item.recp_kg_price" class="form-control"  v-if="! print_mode && ! receipt.receipt_paid">
                <span v-if=" print_mode || receipt.receipt_paid">{{item.recp_kg_price}}</span>
              </td>
              <td style="width:25%">{{item.product_name}}</td>
            </tr>
            <tr>
              <td ><b class="border-top border-primary">{{calc_sale_value | round2}} </b></td>
            <th ></th>
            <td style="border: none !important;"></td>
            <td style="border: none !important;"></td>
            <td style="border: none !important;"></td>
            <td style="border: none !important;"></td>
            </tr>
          <tr>
            
            <td>( {{inc_sums.c_total_inc_nolon}} )</td>
            <th >مشال</th>
            <td style="border: none !important;"></td>
            <td style="border: none !important;"></td>
            <td style="border: none !important;"></td>
            <td style="border: none !important;"></td>
          </tr>
          <tr>
            
            <td>( {{receipt.sale_value * (receipt.comm_rate / 100) | round2}} )</td>
            <th >عمولة</th>
            <td></td>
            <td></td>
            <td ><input v-if="! print_mode && ! receipt.receipt_paid" v-model="receipt.comm_rate" class="form-control"  ></td>
            <th>
              <span v-if="! print_mode && ! receipt.receipt_paid">
               نسبة العمولة {{receipt.comm_rate }}%  
               </span>
            </th>
          </tr>
          <tr>
            <td>( {{receipt.receipt_given}} )</td>
            <th >وهبة الفاتورة</th>
            <td></td>
            <td></td>
            <td ><input v-if="! print_mode && ! receipt.receipt_paid" v-model="receipt.receipt_given" class="form-control"  ></td>
            <th >
              <span v-if="! print_mode && ! receipt.receipt_paid">
              ادخل مبلغ الوهبة
              </span>
              </th>
          </tr>
          <tr>
            <td> <b class="border-top border-primary">{{receipt.net_value | round2}} </b></td>
            <th >صافي الفاتورة</th>
            <td style="border: none !important;"></td>
            <td style="border: none !important;"></td>
            <td style="border: none !important;"></td>
            <td style="border: none !important;"></td>
          </tr>
          </tbody>
        </table>
      </div>
        <p class="text-danger pr-me">
          خالص بيد حامله ولا تلغي أي شيكات أو ايصالات امانة
        </p>
      <button @click="show_details = true; print_mode= false; getSupplierDetails()" class="btn btn-primary m-1 pr-hideme" >
        العودة
      </button>
      <button v-if="! receipt.receipt_paid" @click="saveRecp(0)" class="btn btn-success m-1 pr-hideme" >
        حفظ الفاتورة
      </button>
      <button v-if="! receipt.receipt_paid" @click="saveRecp(1)" class="btn btn-success m-1 pr-hideme" >
        رصد الفاتورة
      </button>
      <button v-if="! receipt.receipt_paid" @click="saveRecp(2)" class="btn btn-success m-1 pr-hideme" >
        صرف الفاتورة
      </button>
      <!--
      <button v-if="! receipt.receipt_paid " @click="discardRecp()" class="btn btn-danger m-1 pr-hideme" >
        استرجاع قبل الفاتورة
      </button>
      -->
      <button v-if=" print_mode || receipt.receipt_paid " class="btn btn-printo pr-hideme m-1" @click="vue_window.print()">
        <span class="fa fa-print"></span> طباعة 
      </button>

      <button v-if="! print_mode && ! receipt.receipt_paid" @click="print_mode= true" class="btn btn-primary m-1 pr-hideme" >
        معاينة طباعة
      </button>
      </section>
  </section>
</template>

<script >
import { SuppliersDB, SupplierDAO } from '../db/SuppliersDB.js'
import { OutgoingsHeaderDB, OutgoingHeaderDAO } from '../db/OutgoingsHeaderDB.js'
import { IncomingsHeaderDB } from '../db/IncomingsHeaderDB.js'
import { ReceiptDAO, ReceiptsDB} from '../db/ReceiptsDB.js'
import { DateTime } from '../main.js'
import { SupplierTransDB } from '../db/SupplierTransDB.js'
import { APP_LABELS } from '../main.js'

export default {
  name: 'supplier-details',
  data () {
    return {
      supplier: {},
      supplier_id: this.$route.params.id,
      show_details: true,
      show_payments : false,
      show_receipt: false,
      print_mode: false,
      store_day: this.$store.state.day,
      trans_form: {},
      //receipt: {cols: [], comm_rate: 0, nolon: 0 ,receipt_given:0, total: 0 },
      receipt: new ReceiptDAO(),
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
      console.log(this.outgoings_headers_today)

      this.supplier_payments = await SupplierTransDB.getAll({supplier_id: this.supplier.id})
      
    },
    async addPayments(evt){
      evt.preventDefault()
      this.trans_form.day = DateTime.fromISO(this.trans_form.day).toISODate()
      this.trans_form.amount = - parseFloat(this.trans_form.amount)
      await SuppliersDB.updateBalance(this.supplier_id,this.trans_form)
      this.trans_form = {}
      this.$root.$emit('bv::toggle::collapse', 'collapse_pay')
      this.getSupplierDetails()
    },
    async initReceipt() {
      console.log(this.inc_sums)
      this.receipt = await ReceiptsDB.initReceipt({day: this.store_day.iso, supplier_id: this.supplier.id},{
        total_nolon: this.inc_sums.c_total_inc_nolon,
        sale_value: this.calc_sale_value,
        day: this.store_day.iso,
        supplier_id: this.supplier.id
      })
      this.receipt.total_nolon = this.inc_sums.c_total_inc_nolon
      this.receipt.sale_value = this.calc_sale_value
      this.show_receipt = true
    },
    async saveRecp(paid) {

      this.outgoings_headers_today.forEach(async item =>{
        let out_head_DAO = new OutgoingHeaderDAO(item)
        out_head_DAO.parseTypes()
        let recp_comm_value = (out_head_DAO.recp_kg_price * out_head_DAO.recp_weight ) * (this.receipt.comm_rate / 100)
        //out_head_DAO.recp_comm_rate = (out_head_DAO.recp_comm_rate > 0) ? out_head_DAO.recp_comm_rate : 0
        await OutgoingsHeaderDB.saveById(item.id, {
          recp_kg_price: out_head_DAO.recp_kg_price,
          recp_comm_rate: this.receipt.comm_rate,
          recp_comm_value: recp_comm_value,
          recp_total: out_head_DAO.recp_kg_price * out_head_DAO.recp_weight
        })
      })
      this.receipt.receipt_paid = paid

      await ReceiptsDB.saveById(this.receipt.id, this.receipt)
      if(paid == 1) {
        // Add supplier trans
        await SuppliersDB.updateBalance(this.supplier_id, {
          day: this.store_day.iso,
          amount: this.receipt.net_value,
          trans_type: 'receipt_1'
        })
      }
    },
    async discardRecp() {
      this.outgoings_headers_today.forEach( async item =>{
        let out_head_DAO = new OutgoingHeaderDAO(item)
        out_head_DAO.parseTypes()
        await OutgoingsHeaderDB.saveById(item.id, {
          recp_kg_price: out_head_DAO.kg_price,
          recp_total: out_head_DAO.kg_price * out_head_DAO.total_weight
        })
      })
      this.show_receipt = false
      this.show_details = true
      this.print_mode= false
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
    calc_sale_value: function(){
      let sum =0 
      this.outgoings_headers_today.forEach(item =>{
        sum += parseFloat(item.recp_weight) * parseFloat(item.recp_kg_price)
      })
      // this.receipt.sale_value = sum
      return sum
    },
    calc_receipt_net: function() {
      return this.receipt.sale_value 
      - ( this.receipt.sale_value * ( this.receipt.comm_rate / 100 )) 
      - this.receipt.receipt_given 
      - this.receipt.total_nolon
    }
  },
  watch : {
    /*
    receipt: {
      handler() {
        this.receipt.calcVals()
      },
      deep: true
    },
    */
    calc_sale_value: function(newval) {
      this.receipt.sale_value = newval
    },
    calc_receipt_net: function(newval) {
      this.receipt.net_value = newval
    }
  },
  components: {
  },
  mounted() {
    this.getSupplierDetails()
  }
}
</script>


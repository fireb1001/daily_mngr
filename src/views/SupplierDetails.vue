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
                
              </span>

              <span class="btn btn-primary mr-3"  v-if="! show_payments" @click="show_payments = true">عرض الدفعات والفواتير السابقة</span>
              <button v-b-toggle.collapse_pay class="col btn btn-success ml-3 mr-3">
                <span class="fa fa-money-bill-wave"></span> &nbsp; 
                دفعات / تحصيلات
              </button>
            </div>
          </td>
        </tr>
      </table>

  <!-- Element to collapse  <div class="m-2"></div>-->
  <b-collapse id="collapse_pay" style="padding:25px;" class="pr-hideme">
    <div class="entry-form">
    <form  @submit="addPayments">
      <b-form-group label="نوع الحركة">
        <b-form-radio-group  v-model="trans_form.sum">
          <b-form-radio value="-">دفعة سابقة</b-form-radio>
          <b-form-radio value="+">تحصيل</b-form-radio>
        </b-form-radio-group>
      </b-form-group>

      <div class="form-group row">
        <label  class="col-sm-2">المبلغ</label>
        <div class="col-sm-10">
          <input v-model="trans_form.amount" class="form-control "  placeholder="ادخل المبلغ">
        </div>
      </div>
      <div class="form-group row" v-if="trans_form.sum === '-'">
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

      <button type="submit" class="btn btn-success" :disabled="! valid_payments_form ">
        <span v-if="trans_form.sum && trans_form.sum == '-'">اضافة دفعة</span>
        <span v-if="trans_form.sum && trans_form.sum == '+'">تحصيل مبلغ</span>
      </button>
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

      <h3 class="m-3">سجل فواتير العميل </h3>
        <table class="table table-striped pr-me">
          <thead>
            <tr>
              <th>التاريخ</th>
              <th>صافي الفاتورة</th>
              <th>عدد الطرود</th>
              <th>الاصناف</th>
              <th>حالة الفاتورة</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(receipt, idx) in supplier_receipts" :key='idx'>
              <td>{{receipt.day}}</td>
              <td>
                {{receipt.net_value}}
              </td>
              <td>{{receipt.total_count}}</td>
              <td>{{receipt.products_arr | productsFilter }}</td>
              <td>
                <span v-if="receipt.receipt_paid == 1">رصد</span>
                <span v-if="receipt.receipt_paid == 2">صرف</span>
              </td>

            </tr>
            <tr>
              <td></td>
              <td>اجمالي فواتير الرصد فقط = <b>{{supp_recps_sums.total_rasd}}</b> </td>
              <td>
                
              </td>
            </tr>
          </tbody>
        </table>

        <div class="text-center">
          <button class="btn btn-printo pr-hideme" @click="vue_window.print()">
            <span class="fa fa-print"></span> طباعة 
          </button>
          <b class="btn btn-danger pr-hideme m-3" @click="show_payments = false">اغلاق </b>
        </div>
    </div>

    <h4 class="text-danger" v-if="inc_sums.c_total_current_rest > 0"> عدد الطرود المتبقية التي لم يتم بيعها حتي الان {{ inc_sums.c_total_current_rest }} طرد</h4>
    <button @click="initReceipt()" class="btn m-1 pr-hideme"
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
          <tr>
            <td></td>
            <th>الاجمالي</th>
            <td>{{out_sums.total_sold_count}}</td>
            <td></td>
            <td></td>
            <td><b class="border-top border-primary">{{out_sums.calc_outgoings_value}}</b></td>
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
      <template v-if="print_mode">
        <h1 class="text-danger text-center"> أولاد الحاج/ مصطفي ندا مصطفي</h1>
        <h1 class="text-primary text-center">الأستاذ / جمــال نــدا</h1>
        <h3 class="text-danger text-center"> لتجارة وتسويق الفاكهة </h3>
        <h4 class="text-primary text-center">
          سوق العبور - القاهرة - محل رقم ١٥٠ عنبر ٤ فاكهة س.ت :٢٨٤٠٤٠
        </h4>
        <h4 class="text-primary text-center">
          ت : ٤٤٧٠٣٥٠ المعلم سلامة : ٠١١١٨٣٥٧٧٥٠ الأستاذ محمد : ٠١٠٢٣٩٢٩٢٢٣
        </h4>
      </template>

        <h2 class="text-danger text-center"> فاتـورة </h2>
        <!-- # {{receipt.id | toAR}} -->
        <p class="pr-me">
          تحريراً في {{store_day.arab }}
          <br/>
          المطلوب من السيد/ {{supplier.name}}
        </p>
      <div class="table-responsive p-2" style="border: 2px solid #79ace0; border-radius: 12px;" > 
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
            <tr v-for="(item, idx) in receipts_details" :key='idx'>
              <td>
                {{item.kg_price *  item.weight | round2 | toAR }}
              </td>
              <td >
                <input v-model="item.count" class="form-control"  v-if="! print_mode && ! receipt.receipt_paid">
                <span v-if=" print_mode || receipt.receipt_paid">{{item.count | toAR }}</span>
              </td>
              <td >
                <input v-model="item.weight" class="form-control"  v-if="! print_mode && ! receipt.receipt_paid">
                <span v-if=" print_mode || receipt.receipt_paid">{{item.weight | toAR }}</span>
              </td>
              <td>X</td>
              <td >
                <input v-model="item.kg_price" class="form-control"  v-if="! print_mode && ! receipt.receipt_paid">
                <span v-if=" print_mode || receipt.receipt_paid">{{item.kg_price | toAR }}</span>
              </td>
              <td >{{item.product_name}} 
                <button v-if=" ! print_mode && ! receipt.receipt_paid" class="btn text-success" @click="removeRecpDetail(item.id)" >
                  <span class="fa fa-remove "></span> 
                  حذف
                </button>
              </td>
            </tr>
            <!-- TODO add new row ! -->
            <tr>
              <td ><b class="border-top border-primary">{{recp_sums.calc_sale_value | round2 | toAR }} </b></td>
            <th ></th>
            <td style="border: none !important;"></td>
            <td style="border: none !important;"></td>
            <td style="border: none !important;"></td>
            <td style="border: none !important;"></td>
            </tr>
          <tr>
            
            <td>( {{inc_sums.c_total_inc_nolon | round2 | toAR }} )</td>
            <th >مشال</th>
            <td style="border: none !important;"></td>
            <td style="border: none !important;"></td>
            <td style="border: none !important;"></td>
            <td style="border: none !important;"></td>
          </tr>
          <tr>
            
            <td>( {{receipt.recp_comm | round2 | toAR }} )</td>
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
            <td>( {{receipt.receipt_given | round2 | toAR }} )</td>
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
            <td> <b class="border-top border-primary">{{receipt.net_value | round2 | toAR }} </b></td>
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
          * خالص بيد حامله ولا تلغي أي شيكات أو ايصالات امانة
        </p>
      <div v-for="(item, product_id) in inc_sums.products_sold" :key='product_id' >
        <template v-if="! print_mode && recp_sums.products_sold[product_id]">
          <div class="alert alert-danger" role="alert" v-if="(item.sold - recp_sums.products_sold[product_id].count) > 0">
            <span class="fa fa-exclamation-circle"></span>
            متبقي {{item.sold - recp_sums.products_sold[product_id].count}} من {{item.product_name}} تم بيعه ولم يتم احتسابه في الفاتورة
              <button class="btn text-primary" @click="newRecpDetial(item)" >
                  انشاء جديد
              </button>
          </div>
          <div class="alert alert-danger" role="alert" v-if="(item.sold - recp_sums.products_sold[product_id].count) < 0 ">
            <span class="fa fa-exclamation-circle"></span>
            عدد المبيع اكبر من الفعلي ({{item.sold - recp_sums.products_sold[product_id].count}}) من {{item.product_name}}  
          </div>
        </template>
        <div class="alert alert-danger" role="alert" v-if="item.sold && ! recp_sums.products_sold[product_id] ">
            <span class="fa fa-exclamation-circle"></span>
            متبقي {{item.sold }} من {{item.product_name}} تم بيعه ولم يتم احتسابه في الفاتورة
              <button class="btn text-primary" @click="newRecpDetial(item)" >
                  انشاء جديد
              </button>
        </div>
      </div>

      <button @click="show_details = true; print_mode= false; getSupplierDetails()" class="btn btn-primary m-1 pr-hideme" >
        العودة
      </button> | 
      <button v-if="! receipt.receipt_paid" @click="saveRecp(0)" class="btn btn-success m-1 pr-hideme" >
        حفظ الفاتورة
      </button> |
      <button v-if="receipt.receipt_paid != 2 " @click="discardRecp()" class="btn btn-danger m-1 pr-hideme" >
        اعادة انشاء الفاتورة
      </button> 
      <button v-if="! receipt.receipt_paid" @click="saveRecp(1)" class="btn btn-danger m-1 pr-hideme" >
        رصد الفاتورة
      </button> 
      <button v-if="! receipt.receipt_paid" @click="saveRecp(2)" class="btn btn-danger m-1 pr-hideme" >
        صرف الفاتورة
      </button> |
      <!--
      <button v-if="! receipt.receipt_paid " @click="discardRecp()" class="btn btn-danger m-1 pr-hideme" >
        استرجاع قبل الفاتورة
      </button>
      -->
      <button v-if=" print_mode" class="btn btn-printo pr-hideme m-1" @click="vue_window.print()">
        <span class="fa fa-print"></span> طباعة 
      </button>

      <button v-if=" print_mode " @click="print_mode= false" class="btn btn-primary m-1 pr-hideme" >
        اغلاق معاينة طباعة
      </button>

      <button v-if="! print_mode " @click="print_mode= true" class="btn btn-primary m-1 pr-hideme" >
        معاينة طباعة
      </button>
      </section>
  </section>
</template>

<script >
import { SuppliersDB, SupplierDAO } from '../db/SuppliersDB.js'
import { OutgoingsHeaderDB } from '../db/OutgoingsHeaderDB.js'
import { IncomingsHeaderDB } from '../db/IncomingsHeaderDB.js'
import { ReceiptDAO, ReceiptsDB} from '../db/ReceiptsDB.js'
import { SupplierTransDB } from '../db/SupplierTransDB.js'
import { APP_LABELS } from '../main.js'
import { Settings, DateTime } from 'luxon'
import { ReceiptsDetailsDB, ReceiptDetailDAO } from '../db/ReceiptsDetailsDB';
import { CashflowDAO, CashflowDB } from '../db/CashflowDB';

Settings.defaultLocale = 'ar'
Settings.defaultZoneName = 'UTC'

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
      trans_form: {sum: '-'},
      //receipt: {cols: [], comm_rate: 0, nolon: 0 ,receipt_given:0, total: 0 },
      receipt: new ReceiptDAO(),
      outgoings_headers_today: [],
      receipts_details: [],
      incomings_headers_today: [],
      supplier_payments: [],
      supplier_receipts: [],
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
      this.supplier_receipts = await ReceiptsDB.getAll({supplier_id: this.supplier.id})
      
    },
    async removeRecpDetail(id){
      await ReceiptsDetailsDB.deleteAll({id: id})
      this.receipts_details= this.receipts_details.filter( item =>  item.id != id )
    },
    async newRecpDetial(item) {
      await this.saveRecp(0)
      let newRecpDetialDAO = new ReceiptDetailDAO(item)
      newRecpDetialDAO.supplier_id = this.supplier.id
      newRecpDetialDAO.supplier_name = this.supplier.name
      newRecpDetialDAO.day = this.store_day.iso
      newRecpDetialDAO.receipt_id = this.receipt.id

      if(this.recp_sums.products_sold && this.recp_sums.products_sold[item.product_id]) {
         newRecpDetialDAO.count = item.sold - this.recp_sums.products_sold[item.product_id].count
      } else {
         newRecpDetialDAO.count = item.sold 
      }
     
      console.log('newRecpDetialDAO', newRecpDetialDAO)
      await ReceiptsDetailsDB.addNew(newRecpDetialDAO)
      await this.initReceipt()
    },
    async addPayments(evt){
      evt.preventDefault()

      if(this.trans_form.day)
        this.trans_form.day = DateTime.fromISO(this.trans_form.day).toISODate()
      else 
        this.trans_form.day = this.store_day.iso

      if(this.trans_form.sum == '+') {
        this.trans_form.amount = parseFloat(this.trans_form.amount)
        let cashflowDAO = new CashflowDAO(CashflowDAO.SUPP_COLLECT_DAO)
        cashflowDAO.amount = this.trans_form.amount
        cashflowDAO.day = this.store_day.iso
        cashflowDAO.actor_id = this.supplier.id
        cashflowDAO.actor_name = this.supplier.name

        this.trans_form.cashflow_id = await CashflowDB.addNew(cashflowDAO)
      }
      else {
        this.trans_form.amount = - parseFloat(this.trans_form.amount)
      }

      await SuppliersDB.updateBalance(this.supplier_id,this.trans_form)
      this.trans_form = {sum: '-'}
      this.$root.$emit('bv::toggle::collapse', 'collapse_pay')
      this.getSupplierDetails()
    },
    async initReceipt() {
      this.receipt = await ReceiptsDB.initReceipt({day: this.store_day.iso, supplier_id: this.supplier.id},
      {
        day: this.store_day.iso,
        supplier_id: this.supplier.id,
        supplier_name: this.supplier.name,
        total_nolon: this.inc_sums.c_total_inc_nolon,
        total_current_rest: this.inc_sums.c_total_current_rest,
        incomings_headers_today: this.incomings_headers_today,
        outgoings_headers_today: this.outgoings_headers_today,
        out_sale_value: this.out_sums.calc_outgoings_value,
        total_count: this.inc_sums.c_total_count
      })
      
      this.receipts_details = await ReceiptsDetailsDB.getAll({
        day: this.store_day.iso,
        supplier_id: this.supplier.id
      })
      // save Receipt as Precaution procedure
      // await ReceiptsDB.saveById(this.receipt.id, this.receipt)
      this.show_details = false
      this.show_receipt = true
    },
    async saveRecp(paid) {
      console.log('saveRecp paid', paid)
      this.receipts_details.forEach(async item =>{
        let receiptDetailDAO = new ReceiptDetailDAO(item)
        receiptDetailDAO.parseTypes()
        // calc comm for daily moves
        // let recp_comm_value = (out_head_DAO.recp_kg_price * out_head_DAO.recp_weight ) * (this.receipt.comm_rate / 100)
        //out_head_DAO.recp_comm_rate = (out_head_DAO.recp_comm_rate > 0) ? out_head_DAO.recp_comm_rate : 0
        await ReceiptsDetailsDB.saveById(item.id, {
          kg_price: receiptDetailDAO.kg_price,
          calc_value: receiptDetailDAO.kg_price * receiptDetailDAO.weight,
          weight: receiptDetailDAO.weight,
          count: receiptDetailDAO.count
          // comm_rate: this.receipt.comm_rate,
          // recp_comm_value: recp_comm_value,
        })
      })

      this.receipt.receipt_paid = paid
      console.log("this.receipt", this.receipt)
      await ReceiptsDB.saveById(this.receipt.id, this.receipt)
      // Add supplier trans if paid == 1
      /*
      await SuppliersDB.updateBalance(this.supplier_id, {
        day: this.store_day.iso,
        amount: this.receipt.net_value,
        trans_type: 'receipt_1'
      })
      */
      if(paid == 2) {
       // Save cashflow
       let cashflowDAO = new CashflowDAO(CashflowDAO.RECP_PAID_DAO)
       cashflowDAO.day = this.store_day.iso
       cashflowDAO.actor_id = this.supplier.id
       cashflowDAO.actor_name = this.supplier.name
       cashflowDAO.amount = this.receipt.net_value
       cashflowDAO.d_product = this.receipt.products_arr

       CashflowDB.addNew(cashflowDAO)
      }
      await this.getSupplierDetails()
    },
    async discardRecp() {
      // reinit the recp
      await ReceiptsDB.deleteAll({day: this.store_day.iso, supplier_id: this.supplier.id})
      await ReceiptsDetailsDB.deleteAll({day: this.store_day.iso, supplier_id: this.supplier.id})
      /*
      this.outgoings_headers_today.forEach( async item =>{
        let out_head_DAO = new OutgoingHeaderDAO(item)
        out_head_DAO.parseTypes()
        await OutgoingsHeaderDB.saveById(item.id, {
          recp_kg_price: out_head_DAO.kg_price,
          recp_total: out_head_DAO.kg_price * out_head_DAO.total_weight
        })
      })
      */
      this.receipts_details = []
      this.receipt= new ReceiptDAO()
      this.show_receipt = false
      this.show_details = true
      this.print_mode= false
      this.initReceipt()
    }
  },
  computed: {
    inc_sums: function() {
      let inc_sums ={c_total_current_rest:0 , c_total_inc_nolon: 0, c_total_count: 0, products_sold: {}}
      this.incomings_headers_today.forEach(item =>{
        inc_sums.c_total_current_rest += parseInt(item.current_count)
        inc_sums.c_total_count += parseInt(item.total_count)
        inc_sums.c_total_inc_nolon += parseFloat(item.inc_total_nolon)
        let product_sold_obj = { 
          product_id: item.product_id,
          sold: (parseInt(item.total_count) - parseInt(item.current_count)),
          product_name: item.product_name
        }
        inc_sums.products_sold[item.product_id] = product_sold_obj
      })
      return inc_sums
    },
    recp_sums: function(){
      let recp_sums = {calc_sale_value: 0 , products_sold: {}}

      this.receipts_details.forEach(item =>{
        recp_sums.calc_sale_value += parseFloat(item.weight) * parseFloat(item.kg_price)
        
        let product_sold_obj = { 
          product_id: item.product_id,
          product_name: item.product_name
        }
        if(recp_sums.products_sold && recp_sums.products_sold[item.product_id]) {
          product_sold_obj.count = parseInt(recp_sums.products_sold[item.product_id].count) + parseInt(item.count)
        } else {
          product_sold_obj.count = parseInt(item.count)
        }
        recp_sums.products_sold[item.product_id] = product_sold_obj
      })
      // this.receipt.sale_value = sum
      return recp_sums
    },
    out_sums: function(){
      let out_sums = {calc_outgoings_value: 0 , total_sold_count: 0}
      this.outgoings_headers_today.forEach(item =>{
        out_sums.calc_outgoings_value += parseFloat(item.total_weight) * parseFloat(item.kg_price)
        out_sums.total_sold_count += parseInt(item.sold_count)
      })
      // this.receipt.sale_value = sum
      return out_sums
    },
    calc_receipt_comm: function(){
      return this.receipt.sale_value * ( this.receipt.comm_rate / 100 )
    },
    calc_receipt_net: function() {
      return this.receipt.sale_value 
      - ( this.receipt.sale_value * ( this.receipt.comm_rate / 100 )) 
      - this.receipt.receipt_given 
      - this.receipt.total_nolon
    },
    supp_recps_sums: function(){
      let supp_recps_sums = {total_rasd: 0 }
      this.supplier_receipts.forEach(item =>{
        if(item.receipt_paid == 1)
          supp_recps_sums.total_rasd += parseFloat(item.net_value)
      })
      // this.receipt.sale_value = sum
      return supp_recps_sums
    },
    valid_payments_form: function() {

      if(this.trans_form.sum && this.trans_form.amount && parseFloat(this.trans_form.amount)) {
        if(this.trans_form.sum == '-' && ! this.trans_form.day)
          return false
        else 
          return true
      }
      return false

    }
  },
  watch : {
    recp_sums: {
      async handler(newVals) {
        console.log("recp_sums changed calc_sale_value", newVals.calc_sale_value)
        this.receipt.sale_value= newVals.calc_sale_value
        // TODO Watch rests
        // await this.saveRecp(this.receipt.receipt_paid)
      },
      deep: true
    },
    /*
    calc_sale_value: function(newval) {
      this.receipt.sale_value = newval
    },
    */
    calc_receipt_net: function(newval) {
      this.receipt.net_value = newval
    },
    calc_receipt_comm: function(newval) {
      this.receipt.recp_comm = newval
    }
  },
  components: {
  },
  mounted() {
    this.getSupplierDetails()
  }
}
</script>


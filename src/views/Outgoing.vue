<template>
  <div class="out row ">
    <div class="col-6 bg-outgoing minh90 d-print-none" v-if="detailed === false">
    <br/>
    <!-- <img alt="Vue logo" src="../assets/logo.png"> 
    <HelloWorld msg="Welcome to Your Vue.js App"/>
    
<ul class="nav nav-tabs">
  <li class="nav-item">
    <router-link class="nav-link" to="/">وارد اليوم</router-link>
  </li>
  <li class="nav-item">
    <a class="nav-link active" href="#">صادر اليوم</a>
  </li>
  <li class="nav-item">
    <a class="nav-link disabled" href="#" tabindex="-1" aria-disabled="true">Disabled</a>
  </li>

</ul>
-->

<div class="p-3" v-show="! selected_inc_hdr || ! selected_inc_hdr.product_id">
<button v-for="(incom, idx) in incoming_headers" :key="idx" 
v-b-toggle.collapse2 
@click="selected_inc_hdr= incom"
class="btn btn-lg  m-1 btn-block" 
:class="{'btn-primary': incom.day === store_day.iso, 'btn-danger': incom.day !== store_day.iso}">
  <span class="fa fa-shopping-cart"></span> &nbsp; 
  {{incom.product_name}} - 
  زرع <b> {{incom.supplier_name}} </b> - 
  متبقي ({{incom.current_count}}) {{incom.unit}} 
  <span v-if="incom.day !== store_day.iso"><br/> 
وارد {{incom.day | arDate }}
  </span>
  
</button>
</div>


<div class="p-4" v-if="selected_inc_hdr && selected_inc_hdr.product_id">
  <h4 :class="{ 'text-danger':  outgoing_form.count > selected_inc_hdr.current_count}">
    بيع {{outgoing_form.count}} من
      {{selected_inc_hdr.product_name}} - 
  زرع <b> {{selected_inc_hdr.supplier_name}} </b> - 
  متبقي ({{selected_inc_hdr.current_count}}) {{selected_inc_hdr.unit}}

  </h4>
    <form  @submit="addNewOutgoing">
  <div class="form-group row">
    <label class="col-sm-2">التاريخ</label>
    <div class="col-sm-10">
      <input v-model="outgoing_form.day" class="form-control" disabled>
    </div>
  </div>

  <div class="form-group row">
    <label :class="{ 'text-danger':  outgoing_form.count > selected_inc_hdr.current_count}" class="col-sm-2">عدد</label>
    <div class="col-sm-10">
      <input v-model="outgoing_form.count" class="form-control">
    </div>
  </div>

  <div class="form-group row">
    <label :class="{ 'text-danger':  outgoing_form.sell_comm > 10 }" class="col-sm-2">
      قيمة البياعة
    </label>
    <div class="col-sm-10">
      <input v-model="outgoing_form.sell_comm" class="form-control" placeholder="ادخل القيمة">
    </div>
  </div>

  <div class="form-group row">
    <label class="col-sm-2">وزن</label>
    <div class="col-sm-10">
      <input v-model="outgoing_form.weight" class="form-control" placeholder="ادخل القيمة">
    </div>
  </div>

  <div class="form-group row">
    <label :class="{ 'text-danger':  outgoing_form.kg_price > 150 }" class="col-sm-2">سعر الكيلو</label>
    <div class="col-sm-10">
      <input v-model="outgoing_form.kg_price" class="form-control" placeholder="ادخل القيمة">
    </div>
  </div>

<hr/>

  <div class="form-group row">
    <label  class="col-sm-2">الاجمالي</label>
    <div class="col-sm-10" >
      <button class="btn btn-success" type="button" v-if="false && ! outgoing_form.value_calc && valid_form " @click="outgoing_form.value_calc=true"> حساب الاجمالي </button>
      <div v-if="value_calc && valid_form">
        <span style="float: right"> {{value_calc_text}} &nbsp; = </span>
        <b style="float: right"> {{value_calc}} </b> &nbsp; جنيه
      </div>
    </div>
  </div>

  <div class="form-group row">
    <label for="notes1" class="col-sm-2">اسم البياع</label>
    <div class="col-sm-10">
      <select v-model="outgoing_form.customer_select" class="form-control"  >
        <option value="">كاش</option>
      <option v-for="(customer, idx) in active_customers" :key='idx' :value="{ id: customer.id, name: customer.name}">
        {{customer.name}}
      </option>
    </select>
    </div>
  </div>

  <div class="form-group row" v-if="outgoing_form.customer_select && outgoing_form.customer_select.id">
    <label  class="col-sm-2">تحصيل جزء</label>
    <div class="col-sm-10">
      <input v-model="outgoing_form.collecting" class="form-control" placeholder="ادخل قيمة التحصيل">
    </div>
  </div>
  
  <div class="form-group row">
    <label for="notes1" class="col-sm-2">ملاحظات</label>
    <div class="col-sm-10">
      <input v-model="outgoing_form.notes" class="form-control" id="notes1"  placeholder="ادخال الملاحظات">
    </div>
  </div>
  
  <button type="submit" class="btn btn-success" :disabled="! valid_form">اضافة</button> 
  &nbsp;&nbsp;
  <button class="btn btn-danger" type="button" @click="reinit_form()"> اغلاق </button>
</form>

</div>

</div>
<!-- conditional class col-6 -->
<div class="p-3 col-print-12 pr-me" :class="{ 'col-6': ! detailed , 'col-10':  detailed }">

  <div class="m-3  ">
  <h2>بيع اليوم {{store_day.arab}}</h2>
      <div class="table-responsive">
        <table class="table table-striped table-sm pr-me">
          <thead>
            <tr>
              <th>#</th>

              <th>زرع العميل</th>
              <th>عدد</th>
              <th>الصنف</th>
              <th>اسم البياع</th>
              
              <th v-if="detailed ">بياعة </th>
              <th v-if="detailed ">مبلغ البياعة </th>
              
              <th >الوزن</th>
              <th>السعر</th>
              <th>المبلغ</th>
              <th v-if="detailed ">ملاحظات</th>
              <th v-if="detailed "></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in outgoings_arr" :key='idx'>
              <td>{{item.id}}</td>

              <td>{{item.supplier_name}}</td>
              <td>{{item.count}}</td>
              <td>{{item.product_name}}</td>
              <td>{{item.customer_name}}</td>
              
              <td v-if="detailed ">{{item.sell_comm}}</td>
              <td v-if="detailed ">{{item.sell_comm * item.count}}</td>
              
              <td>{{item.weight}}</td>
              <td>{{item.kg_price}}</td>
              <td>{{item.value_calc}}</td>
              <td v-if="detailed ">{{item.notes}}</td>
              <td v-if="detailed" class="d-print-none">
                <button class="btn text-danger" @click="discard(item.id)" >
                  <span class="fa fa-archive "></span> 
                  <template v-if="! confirm_step[item.id]"> حذف المبيع</template>
                  <template v-if="confirm_step[item.id]"> تأكيد </template>
                </button>
              </td>
            </tr>
          </tbody>
        </table>
        <button class="btn btn-primary pr-hideme" v-if="detailed === false" @click="show_details()"> عرض التفاصيل </button>
        
        <button class="btn btn-printo pr-hideme" v-if="detailed !== false" 
        @click="clipboard.writeText('بيع اليوم '+store_day.iso);vue_window.print()">
          <span class="fa fa-print"></span> طباعة
        </button>
        &nbsp;
        <button class="btn btn-primary pr-hideme" v-if="detailed !== false" @click="detailed= false"> العودة للبيع </button>
      </div>
    </div>
  </div>
</div>
</template>

<script>
// @ is an alias to /src
const { clipboard } = require('electron')
import { IncomingsHeaderDB, IncomingsHeaderDAO } from '../db/IncomingsHeaderDB'
import { CustomersDB } from '../db/CustomersDB'
import { OutgoingDAO, OutgoingsDB } from '../db/OutgoingsDB.js'
export default {
  name: 'out',
  components: {
    
  },
  data() {
    return {
      outgoings_arr: [],
      active_customers: [],
      store_day: this.$store.state.day,
      incoming_headers: [],
      selected_inc_hdr: new IncomingsHeaderDAO({}),
      outgoing_form: new OutgoingDAO(OutgoingDAO.INIT_DAO),
      detailed: false,
      clipboard: clipboard,
      confirm_step: [],
      discard_success: false
    }
  },
  computed: {
    value_calc_text: function () {
      if(this.outgoing_form.count && 
      this.outgoing_form.sell_comm &&
      this.outgoing_form.weight &&
      this.outgoing_form.kg_price)
      return `(${this.outgoing_form.count} * ${this.outgoing_form.sell_comm}) + (${this.outgoing_form.weight} * ${this.outgoing_form.kg_price})`
    },
    value_calc: function () {
      if(this.outgoing_form.count && 
      this.outgoing_form.sell_comm &&
      this.outgoing_form.weight &&
      this.outgoing_form.kg_price) {
        // this.outgoing_form.parseTypes()
        // only parse count
        // this.outgoing_form.count = parseInt(this.outgoing_form.count)
        let count = this.outgoing_form.count 
        let sell_comm = this.outgoing_form.sell_comm
        let weight = this.outgoing_form.weight 
        let kg_price = this.outgoing_form.kg_price
        return (count * sell_comm ) + ( weight * kg_price)
      }
      else return false
    },
    valid_form: function () {
      return this.outgoing_form.count > 0 && this.outgoing_form.count <= this.selected_inc_hdr.current_count &&
      this.outgoing_form.sell_comm > 0 && this.outgoing_form.sell_comm <= 10 &&
      this.outgoing_form.weight > 0 &&
      this.outgoing_form.kg_price > 0
    }
  },
  methods: {
    async addNewOutgoing(evt){
      evt.preventDefault()
      /*
      let values = this.outgoing.data
      let instert_q = ` INSERT INTO ${Outgoing.table_name} 
      (day, supplier, count, product, notes) 
      VALUES ('${values.day}',${values.supplier},${values.count},${values.product},'${values.notes}')
`
      try {
        await conn_pool.query(instert_q)
        this.refresh_outgoings()
      } catch (error) {
        console.error("SQL error", error)
        this.outgoings_arr.push(new Outgoing(values))
      }
      */
      // console.log(this.value_calc)
      this.outgoing_form.value_calc = this.value_calc
      
      this.outgoing_form.income_head_id = this.selected_inc_hdr.id
      this.outgoing_form.income_day = this.selected_inc_hdr.day
      this.outgoing_form.supplier_id = this.selected_inc_hdr.supplier_id
      this.outgoing_form.supplier_name = this.selected_inc_hdr.supplier_name
      this.outgoing_form.product_id = this.selected_inc_hdr.product_id
      this.outgoing_form.product_name = this.selected_inc_hdr.product_name

      await OutgoingsDB.addNew(this.outgoing_form)

      this.reinit_form()
      this.refresh_outgoings()
      this.refresh_incoming_headers()

    },
    async discard(id) {
      if( this.confirm_step[id] ) {
        // Discard Incoming
        this.discard_success = await OutgoingsDB.discard(id)
        
        this.confirm_step = []
        this.reinit_form()
        this.refresh_outgoings()
        this.refresh_incoming_headers()
      }
      else {
        this.confirm_step = []
        this.confirm_step[id] = true
      }
    },
    show_details() {
      this.detailed = true
    },
    reinit_form() {
      this.selected_inc_hdr = new IncomingsHeaderDAO({})
      this.outgoing_form =new OutgoingDAO(OutgoingDAO.INIT_DAO)
      this.outgoing_form.day = this.store_day.iso
    },
    async refresh_outgoings() {
      this.outgoings_arr = await OutgoingsDB.getAll({day: this.store_day.iso})
      /*
      try {
        var results = await conn_pool.query('SELECT * FROM '+Outgoing.table_name)
        this.outgoings_arr = []
        results.forEach( item => {
          this.outgoings_arr.push(new Outgoing(item))
        })
      } catch(err) {
          throw new Error(err)
      }
      */
    },
    async refresh_incoming_headers() {
      this.incoming_headers = await IncomingsHeaderDB.getAll({current_count: '> 0', day: this.store_day.iso})
    }
  },
  async mounted() {
    this.active_customers = await CustomersDB.getAll({active: 1})
    this.reinit_form()
    this.refresh_outgoings()
    this.refresh_incoming_headers()
  }
}
</script>

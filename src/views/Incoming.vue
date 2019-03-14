<template>
  <div class="home row">
    <div class="col-6 bg-incoming minh90">
    <br/>
    <!-- <img alt="Vue logo" src="../assets/logo.png"> 
    <HelloWorld msg="Welcome to Your Vue.js App"/>
    <DailyHeader />
    --> 
    
  <!--
<ul class="nav nav-tabs">
  <li class="nav-item">
    <a class="nav-link active" href="#">وارد اليوم</a>
  </li>
  <li class="nav-item">
    <router-link class="nav-link" to="/out">صادر اليوم</router-link>
  </li>

  <li class="nav-item">
    <a class="nav-link disabled" href="#" tabindex="-1" aria-disabled="true">Disabled</a>
  </li>
</ul>
-->
    <form  @submit="addNewIncoming" class="p-4">
  <div class="form-group row">
    <label class="col-sm-2">التاريخ</label>
    <div class="col-sm-10">
      <input v-model="incoming_form.date" class="form-control" disabled>
    </div>
  </div>

  <div class="form-group row">
    <label  class="col-sm-2">العميل</label>
    <div class="col-sm-10">
      <select v-model="incoming_form.supplier_select" class="form-control"  >
      <option v-for="(supplier, idx) in active_suppliers" :key='idx' :value="{ id: supplier.id, name: supplier.name}">
        {{supplier.name}}
      </option>
    </select>
    </div>
  </div>

  <div class="form-group row">
    <label class="col-sm-2">الصنف</label>
    <div class="col-sm-10">
      <select v-model="incoming_form.product_select" class="form-control" >
      <option v-for="(product, idx) in active_products" :key='idx' :value="{ id: product.id, name: product.name}">
        {{product.name}}
      </option>
    </select>
    </div>
  </div>

  <div class="form-group row">
    <label for="exampleFormControlSelect1" class="col-sm-2">عدد</label>
    <div class="col-sm-10">
      <input v-model="incoming_form.count" class="form-control">
    </div>
  </div>
<!--
  <div class="form-group row">
    <label for="exampleFormControlSelect1" class="col-sm-2">وحدة</label>
    <div class="col-sm-10">
      <select v-model="incoming_form.unit" class="form-control" id="exampleFormControlSelect1">
      <option>صندوق</option>
      <option>قفص</option>
      <option>كرتونة</option>
    </select>
    </div>
  </div>
-->

  <div class="form-group row">
    <label class="col-sm-2">نولون</label>
    <div class="col-sm-10">
      <input v-model="incoming_form.nolon" class="form-control">
    </div>
  </div>

  <div class="form-group row">
    <label class="col-sm-2">وهبة</label>
    <div class="col-sm-10">
      <input v-model="incoming_form.given" class="form-control">
    </div>
  </div>

  <div class="form-group row">
    <label for="notes1" class="col-sm-2">ملاحظات</label>
    <div class="col-sm-10">
      <input v-model="incoming_form.notes" class="form-control" id="notes1"  placeholder="ادخال الملاحظات">
    </div>
  </div>
<!--
  <div class="form-group form-check">
    <input type="checkbox" class="form-check-input" id="exampleCheck1">
    <br/>
    <label class="form-check-label" for="exampleCheck1">جديد</label>
  </div>
  
-->
  <button type="submit" class="btn btn-success" :disabled="! valid_form">اضافة</button>
  
</form>
</div>
<div class="col-6">
  <br/>
  <h2>وارد اليوم</h2>
      <div class="table-responsive">
        <table class="table table-striped table-sm">
          <thead>
            <tr>
              <th>#</th>
              <th>التاريخ</th>
              <th>العميل</th>
              <th>الصنف</th>
              <th>عدد</th>
              <th>وحدة</th>
              <th>ملاحظات</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(incom, idx) in incomings_arr" :key='idx'>
              <td>{{incom.id}}</td>
              <td>{{incom.date}}</td>
              <td>{{incom.supplier_name}}</td>
              <td>{{incom.product_name}}</td>
              <td>{{incom.count}}</td>
              <td>{{incom.unit}}</td>
              <td>{{incom.notes}}</td>
            </tr>
          </tbody>
        </table>
      </div>
  </div>
</div>
</template>

<script>
// @ is an alias to /src
import DailyHeader from '@/components/DailyHeader.vue'
import {IncomingDB, IncomingDAO} from '../db/IncomingDB.js'
import { SuppliersDB } from '../db/SuppliersDB.js'
import { ProductsDB } from '../db/ProductsDB.js'

export default {
  name: 'home',
  components: {
    DailyHeader
  },
  data() {
    return {
      incomings_arr: [],
      store_day: this.$store.state.day,
      active_suppliers: [],
      active_products: [],
      incoming_form: new IncomingDAO(IncomingDAO.INIT_DAO) // set defaults 
    }
  },
  methods: {
    async addNewIncoming(evt){
      evt.preventDefault()
      console.log(this.incoming_form)
      await IncomingDB.addNew(this.incoming_form)
      this.incoming_form = new IncomingDAO(IncomingDAO.INIT_DAO)
      this.incoming_form.date = this.store_day.formated
      this.refresh_inc_arr()
    },
    async refresh_inc_arr() {
      // console.log(require('moment')(this.store_day.formated).format("X"))
      this.incomings_arr = await IncomingDB.getAll()
    }
  },
  async mounted() {
    delete this.incoming_form.id 
    this.incoming_form.date = this.store_day.formated
    this.refresh_inc_arr()
    this.active_suppliers = await SuppliersDB.getAll()
    this.active_products = await ProductsDB.getAll()
  },
  computed: {
    valid_form: function() {
      return this.incoming_form.supplier_select && this.incoming_form.supplier_select.id &&
        this.incoming_form.product_select && this.incoming_form.product_select.id &&
        this.incoming_form.count
    }
  }
}
</script>

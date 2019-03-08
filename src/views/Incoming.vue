<template>
  <div class="home">
    <br/>
    <!-- <img alt="Vue logo" src="../assets/logo.png"> 
    <HelloWorld msg="Welcome to Your Vue.js App"/>
    --> 
    <DailyHeader />
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
    <label for="exampleInputEmail1" class="col-sm-2">التاريخ</label>
    <div class="col-sm-10">
      <input v-model="incoming.data.date" class="form-control" id="exampleInputEmail1" placeholder="Enter date">
    </div>
  </div>

  <div class="form-group row">
    <label for="exampleFormControlSelect1" class="col-sm-2">عدد</label>
    <div class="col-sm-10">
      <select v-model="incoming.data.count" class="form-control" id="exampleFormControlSelect1">
      <option>1</option>
      <option>2</option>
      <option>3</option>
      <option>4</option>
      <option>5</option>
    </select>
    </div>
  </div>

  <div class="form-group row">
    <label for="exampleFormControlSelect2" class="col-sm-2">المورد</label>
    <div class="col-sm-10">
      <select v-model="incoming.data.supplier" class="form-control" id="exampleFormControlSelect2">
      <option>1</option>
      <option>2</option>
      <option>3</option>
      <option>4</option>
      <option>5</option>
    </select>
    </div>
  </div>

  <div class="form-group row">
    <label for="exampleFormControlSelect3" class="col-sm-2">الصنف</label>
    <div class="col-sm-10">
      <select v-model="incoming.data.product" class="form-control" id="exampleFormControlSelect3" >
      <option>1</option>
      <option>2</option>
      <option>3</option>
      <option>4</option>
      <option>5</option>
    </select>
    </div>
  </div>

  <div class="form-group row">
    <label for="notes1" class="col-sm-2">ملاحظات</label>
    <div class="col-sm-10">
      <input v-model="incoming.data.notes" class="form-control" id="notes1"  placeholder="ادخال الملاحظات">
    </div>
  </div>

  <div class="form-group form-check">
    <input type="checkbox" class="form-check-input" id="exampleCheck1">
    <br/>
    <label class="form-check-label" for="exampleCheck1">جديد</label>
  </div>
  <button type="submit" class="btn btn-success">اضافة</button>
  
</form>

  <h2>وارد اليوم</h2>
      <div class="table-responsive">
        <table class="table table-striped table-sm">
          <thead>
            <tr>
              <th>#</th>
              <th>التاريخ</th>
              <th>عدد</th>
              <th>المورد</th>
              <th>الصنف</th>
              <th>ملاحظات</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(incom, idx) in incomings_arr" :key='idx'>
              <td>{{incom.data.id}}</td>
              <td>{{incom.data.date}}</td>
              <td>{{incom.data.count}}</td>
              <td>{{incom.data.supplier}}</td>
              <td>{{incom.data.product}}</td>
              <td>{{incom.data.notes}}</td>
            </tr>
          </tbody>
        </table>
      </div>
  </div>
</template>

<script>
// @ is an alias to /src
import DailyHeader from '@/components/DailyHeader.vue'
import { conn_pool } from '../main'
import { Incoming } from '../sql_classes'

export default {
  name: 'home',
  components: {
    DailyHeader
  },
  data() {
    return {
      incomings_arr: [],
      incoming: new Incoming({count: 3, supplier: 1, date: '20/02/2019'}) // set defaults 
    }
  },
  methods: {
    async addNewIncoming(evt){
      evt.preventDefault()
      let values = this.incoming.data
      let instert_q = ` INSERT INTO ${Incoming.table_name} 
      (date, supplier, count, product, notes) 
      VALUES ('${values.date}',${values.supplier},${values.count},${values.product},'${values.notes}')
`
      try {
        await conn_pool.query(instert_q)
      } catch (error) {
        console.error("SQL error", error)
        this.incomings_arr.push(new Incoming(values))
      }
      
      this.incoming = new Incoming({})
      this.refresh_inc_arr()
    },
    async refresh_inc_arr() {
      try {
        var results = await conn_pool.query('SELECT * FROM '+Incoming.table_name)
        this.incomings_arr = []
        results.forEach( item => {
          this.incomings_arr.push(new Incoming(item))
        })
        // this.incoming = results[0]
      } catch(err) {
          throw new Error(err)
      }
    }
  },
  async mounted() {
    this.refresh_inc_arr()
  }
}
</script>

<template>
  <div class="out">
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

<div class="p-4">
    <form  @submit="addNewOutgoing">
  <div class="form-group row">
    <label class="col-sm-2">التاريخ</label>
    <div class="col-sm-10">
      <input v-model="outgoing.data.date" class="form-control"  placeholder="Enter date" disabled>
    </div>
  </div>

  <div class="form-group row">
    <label for="exampleFormControlSelect1" class="col-sm-2">عدد</label>
    <div class="col-sm-10">
      <select v-model="outgoing.data.count" class="form-control" id="exampleFormControlSelect1">
      <option>1</option>
      <option>2</option>
      <option>3</option>
      <option>4</option>
      <option>5</option>
    </select>
    </div>
  </div>

  <div class="form-group row">
    <label for="exampleInputEmail1" class="col-sm-2">الوزن</label>
    <div class="col-sm-10">
      <input v-model="outgoing.data.weight" class="form-control" id="exampleInputEmail1" placeholder="Enter date">
    </div>
  </div>

  <div class="form-group row">
    <label for="exampleInputEmail1" class="col-sm-2">السعر</label>
    <div class="col-sm-10">
      <input v-model="outgoing.data.price" class="form-control" id="exampleInputEmail1" placeholder="Enter date">
    </div>
  </div>
  <div class="form-group row">
    <label for="exampleFormControlSelect2" class="col-sm-2">المورد</label>
    <div class="col-sm-10">
      <select v-model="outgoing.data.supplier" class="form-control" id="exampleFormControlSelect2">
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
      <select v-model="outgoing.data.product" class="form-control" id="exampleFormControlSelect3" >
      <option>1</option>
      <option>2</option>
      <option>3</option>
      <option>4</option>
      <option>5</option>
    </select>
    </div>
  </div>

  <div class="form-group row">
    <label for="notes1" class="col-sm-2">البائع</label>
    <div class="col-sm-10">
      <input v-model="outgoing.data.seller" class="form-control" id="notes1"  placeholder="اسم البائع ">
    </div>
  </div>

  <div class="form-group row">
    <label for="notes1" class="col-sm-2">ملاحظات</label>
    <div class="col-sm-10">
      <input v-model="outgoing.data.notes" class="form-control" id="notes1"  placeholder="ادخال الملاحظات">
    </div>
  </div>

  <div class="form-group form-check">
    <input type="checkbox" class="form-check-input" id="exampleCheck1">
    <br/>
    <label class="form-check-label" for="exampleCheck1">جديد</label>
  </div>
  <button type="submit" class="btn btn-success">اضافة</button>
</form>
</div>

  <h2>صادر اليوم</h2>
      <div class="table-responsive">
        <table class="table table-striped table-sm">
          <thead>
            <tr>
              <th>#</th>
              <th>التاريخ</th>
              <th>عدد</th>
              <th>الوزن</th>
              <th>السعر</th>
              <th>المورد</th>
              <th>الصنف</th>
              <th>البائع</th>
              <th>ملاحظات</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in outgoings_arr" :key='idx'>
              <td>{{item.data.id}}</td>
              <td>{{item.data.date}}</td>
              <td>{{item.data.count}}</td>
              <td>{{item.data.weight}}</td>
              <td>{{item.data.price}}</td>
              <td>{{item.data.supplier}}</td>
              <td>{{item.data.product}}</td>
              <td>{{item.data.seller}}</td>
              <td>{{item.data.notes}}</td>
            </tr>
          </tbody>
        </table>
      </div>
  </div>
</template>

<script>
// @ is an alias to /src
import { conn_pool } from '../main'
import { Outgoing } from '../sql_classes'

export default {
  name: 'out',
  components: {
    
  },
  data() {
    return {
      outgoings_arr: [],
      outgoing: new Outgoing({count: 4, supplier: 1, date: '20/02/2019'}) // set defaults 
    }
  },
  methods: {
    async addNewOutgoing(evt){
      evt.preventDefault()
      let values = this.outgoing.data
      let instert_q = ` INSERT INTO ${Outgoing.table_name} 
      (date, supplier, count, product, notes) 
      VALUES ('${values.date}',${values.supplier},${values.count},${values.product},'${values.notes}')
`
      try {
        await conn_pool.query(instert_q)
        this.refresh_out_arr()
      } catch (error) {
        console.error("SQL error", error)
        this.outgoings_arr.push(new Outgoing(values))
      }
      
      this.outgoing = new Outgoing({})
      
    },
    async refresh_out_arr() {
      try {
        var results = await conn_pool.query('SELECT * FROM '+Outgoing.table_name)
        this.outgoings_arr = []
        results.forEach( item => {
          this.outgoings_arr.push(new Outgoing(item))
        })
      } catch(err) {
          throw new Error(err)
      }
    }
  },
  async mounted() {
    this.refresh_out_arr()
  }
}
</script>

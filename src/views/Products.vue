<template>
  <div class="products">
    <br/>
    <!-- <img alt="Vue logo" src="../assets/logo.png"> 
    <HelloWorld msg="Welcome to Your Vue.js App"/>
    -->
    <div>
  <!-- Using modifiers -->
  <button v-b-toggle.collapse2 class="btn btn-primary m-1">ادخال صنف جديد</button>

  <!-- Element to collapse -->
  <b-collapse id="collapse2" style="padding:25px;">
    <div class="entry-form">
    <form  @submit="addNewProduct">
      <div class="form-group row">
        <label for="exampleInputEmail1" class="col-sm-2">اسم الصنف</label>
        <div class="col-sm-10">
          <input v-model="product.data.name" class="form-control " id="exampleInputEmail1" placeholder="Enter date">
        </div>
      </div>

      <div class="form-group row">
        <label for="notes1" class="col-sm-2">ملاحظات</label>
        <div class="col-sm-10">
          <input v-model="product.data.notes" class="form-control " id="notes1"  placeholder="ادخال الملاحظات">
        </div>
      </div>

      <button type="submit" class="btn btn-success">اضافة</button>
    </form>
    </div>
  </b-collapse>
</div>

<br/>

  <h2 :class="{ 'text-danger': ! show_active }">{{show_active}} الاصناف </h2>
      <div class="table-responsive">
        <table class="table table-striped table-sm">
          <thead>
            <tr>
              <th> كود الصنف </th>
              <th>اسم الصنف</th>
              <th>ملاحظات</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in comp_products_arr" :key='idx' >
              <td>{{item.data.id}}</td>
              <td>{{item.data.name}}</td>
              <td>{{item.data.notes}}</td>
              <td>
                <button class="btn text-danger" @click="archive(item.data.id)" v-if="item.data.active === 1">
                  <span class="fa fa-archive "></span> 
                  <template v-if="! confirm_step[item.data.id]"> أرشفة</template>
                  <template v-if="confirm_step[item.data.id]"> تأكيد </template>
                </button>
                <button class="btn text-success" @click="archive(item.data.id, 'undo')" v-if="item.data.active === 0">
                  <span class="fa fa-undo "></span> 
                  <template v-if="! confirm_step[item.data.id]"> استرجاع</template>
                  <template v-if="confirm_step[item.data.id]"> تأكيد </template>
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
  </div>
</template>

<script>
// @ is an alias to /src
// import HelloWorld from '@/components/HelloWorld.vue'
import { conn_pool } from '../main'
import { Product } from '../sql_classes'

export default {
  name: 'out',
  components: {
  },
  data() {
    return {
      products_arr: [],
      confirm_step: [],
      show_active: true,
      product: new Product({ supplier: 1, unit: 'KG'}) // set defaults 
    }
  },
  computed: {
    comp_products_arr: function () {
      let active = (this.show_active ) ? 1 : 0;
      return this.products_arr.filter( item => item.data.active === active)
    }
  },
  methods: {
    async addNewProduct(evt){
      evt.preventDefault()
      let values = this.product.data

      let instert_q = ` INSERT INTO ${Product.table_name} 
      (name, supplier, unit, price, notes, active) 
      VALUES ('${values.name}',${values.supplier},'${values.unit}',${values.price},'${values.notes}','${values.active}')
`
      try {
        console.log(instert_q)
        await conn_pool.query(instert_q)
        this.refresh_products_arr()
      } catch (error) {
        console.error("SQL error", error)
        this.products_arr.push(new Product(values))
      }
      this.product = new Product({})
    },
    async refresh_products_arr() {
      try {
        var results = await conn_pool.query('SELECT * FROM '+Product.table_name)

        this.products_arr = []
        results.forEach( item => {
          this.products_arr.push(new Product(item))
        })

      } catch(err) {
          throw new Error(err)
      }
    },
    async archive( id ,undo = '') {
      if( this.confirm_step[id] ) {
        let active = (undo === 'undo') ? 1 : 0 ;
        try {
          await conn_pool.query('UPDATE product SET active = '+ active +' WHERE product.id ='+ id)
          this.refresh_products_arr()
        } catch(err) {
            throw new Error(err)
        }
      }
      else {
        // Always modify arrays by using an Array instance method, or replacing it entirely
        // Or
        // this.$set(this.confirm_step, id, true)
        this.confirm_step = []
        this.confirm_step[id] = true
      }
    },
  },
  async mounted() {
    this.refresh_products_arr()
  }
}
</script>

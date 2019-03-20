<template>
  <section class="products row">
    <div class="col-5">
    <br/>
    <!-- <img alt="Vue logo" src="../assets/logo.png"> 
    <HelloWorld msg="Welcome to Your Vue.js App"/>
    -->
    <div>
  <!-- Using modifiers -->
  <button v-b-toggle.collapse2 class="btn btn-primary m-1">ادخال صنف جديد
    &nbsp; <span class="fa fa-apple-alt"></span>
  </button>

<button  class="btn btn-danger m-1" @click="show_active=false" v-if="show_active">
  عرض الارشيف
  &nbsp; <span class="fa fa-archive"></span>
</button>
<button  class="btn btn-success m-1" @click="show_active=true" v-if="! show_active">
  اغلاق الارشيف   &nbsp; <span class="fa fa-external-link-square-alt"></span>
</button>

  <!-- Element to collapse -->
  <b-collapse id="collapse2" style="padding:25px;">
    <div class="entry-form">
    <form  @submit="addNewProduct">
      <div class="form-group row">
        <label  class="col-sm-2">اسم الصنف</label>
        <div class="col-sm-10">
          <input v-model="product_form.name" class="form-control "  placeholder="ادخل اسم الصنف">
        </div>
      </div>
<!--
      <div class="form-group row">
        <label for="notes1" class="col-sm-2">ملاحظات</label>
        <div class="col-sm-10">
          <input v-model="product_form.notes" class="form-control " id="notes1"  placeholder="ادخال الملاحظات">
        </div>
      </div>
-->
      <button type="submit" class="btn btn-success" :disabled="! product_form.name">اضافة</button>
    </form>
    </div>
  </b-collapse>
</div>
</div>

  <div class="col-7">
    <br/>
    <h2 :class="{ 'text-danger': ! show_active }">
      <span v-if="show_active"> ادارة </span>
      <span v-if="! show_active"> ارشيف </span>
     الاصناف 
    </h2>

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
              <td>{{item.id}}</td>
              <td>{{item.name}}</td>
              <td>{{item.notes}}</td>
              <td>
                <button class="btn text-danger" @click="archive(item.id)" v-if="item.active === 1">
                  <span class="fa fa-archive "></span> 
                  <template v-if="! confirm_step[item.id]"> أرشفة</template>
                  <template v-if="confirm_step[item.id]"> تأكيد </template>
                </button>
                <button class="btn text-success" @click="archive(item.id, 'undo')" v-if="item.active === 0">
                  <span class="fa fa-undo "></span> 
                  <template v-if="! confirm_step[item.id]"> استرجاع</template>
                  <template v-if="confirm_step[item.id]"> تأكيد </template>
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
  </div>
</section>
</template>

<script>
// @ is an alias to /src
// import HelloWorld from '@/components/HelloWorld.vue'
import { ProductsDB, ProductDAO} from '../db/ProductsDB.js'
export default {
  name: 'products',
  components: {
  },
  data() {
    return {
      products_arr: [],
      confirm_step: [],
      show_active: true,
      product_form: new ProductDAO(ProductDAO.INIT_DAO)
    }
  },
  computed: {
    comp_products_arr: function () {
      let active = (this.show_active ) ? 1 : 0;
      return this.products_arr.filter( item => item.active === active)
    }
  },
  methods: {
    async addNewProduct(evt){
      evt.preventDefault()
      delete this.product_form.id
      await ProductsDB.addNew(this.product_form)
      this.product_form = new ProductDAO(ProductDAO.INIT_DAO)
      this.refresh_products()
    },
    async refresh_products() {
      this.products_arr = await ProductsDB.getAll()
      let new_prs = await ProductsDB.getAll()
      console.log(new_prs)
    },
    async archive( id ,undo = '') {
      if( this.confirm_step[id] ) {
        let active = (undo === 'undo') ? 1 : 0 ;
        /*
        try {
          await conn_pool.query('UPDATE product SET active = '+ active +' WHERE product.id ='+ id)
          this.refresh_products_arr()
        } catch(err) {
            throw new Error(err)
        }
        */
        await ProductsDB.saveById( id, {active: active})
        this.confirm_step = []
        this.refresh_products()
      }
      else {
        this.confirm_step = []
        this.confirm_step[id] = true
      }
    },
  },
  async mounted() {
    this.refresh_products()
  }
}
</script>

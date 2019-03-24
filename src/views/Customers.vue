<template>
  <section class="customers row">
    <div class="col-5">
    <br/>
<button v-b-toggle.collapse_it class="btn btn-primary m-1">
  ادخال بياع جديد 
  &nbsp; <span class="fa fa-address-book"></span>
</button>
<button  class="btn btn-danger m-1" @click="show_active=false" v-if="show_active">
  عرض الارشيف
  &nbsp; <span class="fa fa-archive"></span>
</button>
<button  class="btn btn-success m-1" @click="show_active=true" v-if="! show_active">
  اغلاق الارشيف   &nbsp; <span class="fa fa-external-link-square-alt"></span>
</button>
  <!-- Element to collapse -->
  <b-collapse id="collapse_it" style="padding:25px;">
    <div class="entry-form">

    <form  @submit="addNew">
      <div class="form-group row">
        <label class="col-sm-2">اسم البائع</label>
        <div class="col-sm-10">
          <input v-model="customer_form.name" class="form-control " placeholder="ادخل اسم البائع">
        </div>
      </div>

      <div class="form-group row">
        <label class="col-sm-2">تليفون</label>
        <div class="col-sm-10">
          <input v-model="customer_form.phone" class="form-control "  placeholder="التليفون">
        </div>
      </div>

      <div class="form-group row">
        <label class="col-sm-2">عنوان</label>
        <div class="col-sm-10">
          <input v-model="customer_form.address" class="form-control "  placeholder="ادخال العنوان">
        </div>
      </div>

      <div class="form-group row">
        <label class="col-sm-2">مبلغ المديونية</label>
        <div class="col-sm-10">
          <input v-model="customer_form.debt" :disabled="edit_id > 0"
          class="form-control"  placeholder="ادخل المبلغ">
        </div>
      </div>

      <div class="form-group row">
        <label class="col-sm-2">ملاحظات</label>
        <div class="col-sm-10">
          <input v-model="customer_form.notes" class="form-control "  placeholder="ادخال الملاحظات">
        </div>
      </div>
      <p class="text-danger"> سيتم اضافة البياع بمبلغ مديونية يساوي 
        <template v-if="! customer_form.debt"> 0 </template>
        <template v-if="customer_form.debt"> {{customer_form.debt}} </template>
         جنيه</p>
      <button type="submit" class="btn btn-success">
        <template v-if="! edit_id"> اضافة</template>
        <template v-if="edit_id"> حفظ </template>
      </button>
    </form>
    </div>
  </b-collapse>
  </div>
  <div class="col-7">
    <br/>
  <h2 :class="{ 'text-danger': ! show_active }">
    <span v-if="show_active"> ادارة </span>
    <span v-if="! show_active"> ارشيف </span>
     البائعين 
  </h2>
      <div class="table-responsive">
        <table class="table table-striped table-sm">
          <thead>
            <tr>
              <th> # </th>
              <th>اسم البائع</th>
              <th>التليفون</th>
              <th>المديونية</th>
              <th>ملاحظات</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in comp_customers_arr" :key='idx' >
              <td>{{idx + 1}}</td>
              <td>
                <router-link class="nav-link " :to="{name:'customer_details', params: {id: item.id}}">
                {{item.name}}
                </router-link>
              </td>
              <td>{{item.phone}}</td>
              <td>{{item.debt}}</td>
              <td>{{item.notes}}</td>
              <td>
                <button class="btn text-danger" @click="archive(item.id)" v-if="item.active === 1">
                  <span class="fa fa-archive "></span> 
                  <template v-if="! confirm_step[item.id]"> أرشفة</template>
                  <template v-if="confirm_step[item.id]"> تأكيد </template>
                </button>
                <button class="btn text-success" @click="archive(item.id, 'undo')" v-if="item.active === 0 || ! item.active">
                  <span class="fa fa-undo "></span> 
                  <template v-if="! confirm_step[item.id]"> استرجاع</template>
                  <template v-if="confirm_step[item.id]"> تأكيد </template>
                </button>
                <button class="btn text-primary" @click="edit(item.id)">
                  تعديل
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
  </div>
  </section>
</template>

<script >
import {CustomersDB, CustomerDAO} from '../db/CustomersDB'

export default {
  name: 'customers',
  data () {
    return {
      customer_form: new CustomerDAO(CustomerDAO.INIT_DAO),
      customers_arr: [],
      edit_id: 0,
      show_active: true,
      confirm_step: []
    }
  },
  methods: {
    async addNew(evt) {
      evt.preventDefault()
      if( this.edit_id !==0 && this.edit_id === this.customer_form.id) {
        // Edit 
        await CustomersDB.saveById(this.customer_form.id, this.customer_form)
      }
      else { // New 
        await CustomersDB.addNew(this.customer_form)
      }
      
      this.customer_form = new CustomerDAO(CustomerDAO.INIT_DAO)
      this.refresh_all()
    },
    async edit(id) {
      this.edit_id = id
      let edit_customer_obj = this.customers_arr.filter( element =>{
        return element.id == id
      })
      this.customer_form = new CustomerDAO(edit_customer_obj[0])
      this.$root.$emit('bv::toggle::collapse', 'collapse_it')
      // TODO collabse from js and check active for new supp
    },
    async archive(id, undo = '') {
      if( this.confirm_step[id] ) {
        let active = (undo === 'undo') ? 1 : 0 ;
        await CustomersDB.saveById(id, {active: active})
        this.confirm_step = []
        this.refresh_all()
      }
      else {
        this.confirm_step = []
        this.confirm_step[id] = true
      }
    },
    async refresh_all() {
      this.customers_arr = await CustomersDB.getAll()
    }
  },
  async mounted() {
    this.refresh_all()
  },
  computed: {
    comp_customers_arr: function () {
      let active = (this.show_active ) ? 1 : 0;
      return this.customers_arr.filter( item => item.active === active)
    }
  }
}
</script>

<style scoped lang="scss">

</style>

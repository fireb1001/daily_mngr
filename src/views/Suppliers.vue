<template>
  <section class="suppliers row">
    <div class="col-5">
    <br/>
<button v-b-toggle.collapse_it class="btn btn-primary m-1">
  ادخال عميل جديد 
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
    <form  @submit="addNewSupplier">
      <div class="form-group row">
        <label for="exampleInputEmail1" class="col-sm-2">اسم العميل</label>
        <div class="col-sm-10">
          <input v-model="supplier_form.name" class="form-control " id="exampleInputEmail1" placeholder="ادخل اسم العميل">
        </div>
      </div>

      <div class="form-group row">
        <label  class="col-sm-2">رقم التليفون</label>
        <div class="col-sm-10">
          <input v-model="supplier_form.phone" class="form-control"  placeholder="رقم التليفون" >
        </div>
      </div>

      <div class="form-group row">
        <label  class="col-sm-2">العنوان </label>
        <div class="col-sm-10">
          <input v-model="supplier_form.address" class="form-control"  placeholder="ادخل عنوان العميل" >
        </div>
      </div>

      <div class="form-group row">
        <label for="notes1" class="col-sm-2">ملاحظات</label>
        <div class="col-sm-10">
          <input v-model="supplier_form.notes" class="form-control " id="notes1"  placeholder="ادخال الملاحظات">
        </div>
      </div>

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
     العملاء 
  </h2>
      <div class="table-responsive">
        <table class="table table-striped table-sm">
          <thead>
            <tr>
              <th> </th>
              <th>اسم العميل</th>
              <th>رقم التليفون </th>
              <th>اجمالي الطرود</th>
              <th>الرصيد الحالي</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in comp_suppliers_arr" :key='idx' >
              <td>{{idx + 1 }}</td>
              <td>
                <router-link class="nav-link " :to="{name:'supplier_details', params: {id: item.id}}">
                  {{item.name}}
                </router-link>
               </td>
              <td>{{item.phone}}</td>
              <td>{{item.total_count}}</td>
              <td>{{item.balance}}</td>
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
import { SuppliersDB, SupplierDAO } from '../db/SuppliersDB.js'

export default {
  name: 'suppliers',
  data () {
    return {
      supplier_form: new SupplierDAO(SupplierDAO.INIT_DAO),
      suppliers_arr: [],
      edit_id: 0,
      show_active: true,
      confirm_step: []
    }
  },
  firestore () {
    return {}
  },
  methods: {
    async addNewSupplier(evt) {
      evt.preventDefault()
      console.log(this.supplier_form)
      if( this.edit_id !==0 && this.edit_id === this.supplier_form.id) {
        // Edit 
        await SuppliersDB.saveById(this.supplier_form.id, {
          name: this.supplier_form.name,
          phone: this.supplier_form.phone,
          address: this.supplier_form.address,
          notes: this.supplier_form.notes
        })
      }
      else {
        // New 
        await SuppliersDB.addNew(this.supplier_form)
      }
      this.$root.$emit('bv::toggle::collapse', 'collapse_it')
      this.refresh_all()
      this.supplier_form = new SupplierDAO(SupplierDAO.INIT_DAO)
      this.edit_id  = 0
    },
    async edit(id) {
      this.edit_id = id
      let edit_supp_obj = this.suppliers_arr.filter( element =>{
        return element.id == id
      })
      this.supplier_form = new SupplierDAO(edit_supp_obj[0])
      this.$root.$emit('bv::toggle::collapse', 'collapse_it')
      // TODO collabse from js and check active for new supp
    },
    async archive(id, undo = '') {
      if( this.confirm_step[id] ) {
        let active = (undo === 'undo') ? 1 : 0 ;
        await SuppliersDB.saveById(id, {active: active})
        this.confirm_step = []
        this.refresh_all()
      }
      else {
        this.confirm_step = []
        this.confirm_step[id] = true
      }
    },
    async refresh_all() {
      this.suppliers_arr = await SuppliersDB.getAll()
      console.log(this.suppliers_arr)
    }
  },
  async mounted() {
    this.refresh_all()
  },
  computed: {
    comp_suppliers_arr: function () {
      let active = (this.show_active ) ? 1 : 0;
      return this.suppliers_arr.filter( item => item.active === active)
    }
  },
  components: {
  }
}
</script>

<style scoped lang="scss">

</style>

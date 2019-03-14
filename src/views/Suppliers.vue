<template>
  <section class="suppliers row">
    <div class="col-6">
    <br/>
<button v-b-toggle.collapse2 class="btn btn-primary m-1">
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
  <b-collapse id="collapse2" style="padding:25px;">
    <div class="entry-form">
    <form  @submit="addNewSupplier">
      <div class="form-group row">
        <label for="exampleInputEmail1" class="col-sm-2">اسم العميل</label>
        <div class="col-sm-10">
          <input v-model="supplier_form.name" class="form-control " id="exampleInputEmail1" placeholder="ادخل اسم العميل">
        </div>
      </div>

      <div class="form-group row">
        <label for="notes1" class="col-sm-2">ملاحظات</label>
        <div class="col-sm-10">
          <input v-model="supplier_form.notes" class="form-control " id="notes1"  placeholder="ادخال الملاحظات">
        </div>
      </div>

      <button type="submit" class="btn btn-success">اضافة</button>
    </form>
    </div>
  </b-collapse>
  </div>

  <div class="col-6">
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
              <th> كود العميل </th>
              <th>اسم العميل</th>
              <th>ملاحظات</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in comp_suppliers_arr" :key='idx' >
              <td>{{item.id}}</td>
              <td>{{item.name}}</td>
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
              </td>
            </tr>
          </tbody>
        </table>
      </div>
  </div>
  </section>
</template>

<script >
import { SuppliersDB } from '../db/SuppliersDB.js'

export default {
  name: 'suppliers',
  data () {
    return {
      supplier_form: {},
      suppliers_arr: [],
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
      
      this.supplier_form['active'] = 1
      SuppliersDB.addNew(this.supplier_form)
      this.refresh_all()
      this.supplier_form = {}
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

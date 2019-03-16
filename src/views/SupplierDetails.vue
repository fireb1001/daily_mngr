<template>
  <section class="suppliers row m-3">
      <h3>ملف العميل : {{supplier.name}}</h3>

      <table class="table table-bordered">
        <tr>
          <th>تليفون العميل</th>
          <td>{{supplier.phone}}</td>
        </tr>
        <tr>
          <th>عنوان العميل</th>
          <td>{{supplier.address}}</td>
        </tr>

      </table>
      <div class="m-2">
        <button class="btn btn-primary" @click="$router.go(-1)">العودة</button>
      </div>
  </section>
</template>

<script >
import { SuppliersDB, SupplierDAO } from '../db/SuppliersDB.js'

export default {
  name: 'supplier-details',
  data () {
    return {
      supplier: {}
    }
  },
  methods: {
    async getSupplier() {
      let supp_obj = await SuppliersDB.getDAOById(this.$route.params.id)
      this.supplier = new SupplierDAO(supp_obj)
    }
  },
  computed: {
  },
  components: {
  },
  mounted() {
    this.getSupplier()
  }
}
</script>


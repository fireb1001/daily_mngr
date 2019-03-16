<template>
  <section class="suppliers row m-1">
      <h3>ملف العميل : {{supplier.name}}</h3>
      <table>
        <tr>
          <th>عنوان العميل</th>
          <td>{{supplier.address}}</td>
        </tr>
      </table>
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
      let supp_obj = await SuppliersDB.getDAOById(1)
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

<style scoped lang="scss">

</style>

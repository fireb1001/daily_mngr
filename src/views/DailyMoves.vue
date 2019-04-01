<template>
  <section class="daily-moves bg-dailymoves p-3">
    <h2>كشف الحركة ليوم {{store_day.arab}}</h2>

        <br/>
      <div class="table-responsive">
        <table class="table table-striped table-sm">
          <thead>
            <tr>
              <th>التاريخ</th>
              <th>اسم العميل</th>
              <th>الصنف</th>
              <th>عدد المباع</th>
              <th>بسعر</th>
              <th>البياعة</th>
              <th>العمولة</th>
              <th>اجمالي</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in outgoings_header_arr" :key='idx'>
              <td>{{item.day}}</td>
              <td>{{item.supplier_name}}</td>
              <td>{{item.product_name}}</td>
              <td>{{item.sold_count}}</td>
              <td>{{item.kg_price}}</td>
              <td>{{item.total_sell_comm_value}}</td>
              <td>{{item.recp_comm_rate}}</td>
              <td>{{item.total_sell_comm_value + item.recp_comm_rate}}</td>
              <td>{{item.notes}}</td>
            </tr>
          </tbody>
        </table>
      </div>
  </section>
</template>

<script >

import { OutgoingsHeaderDB } from '../db/OutgoingsHeaderDB'
// TODO to be incomings headers
export default {
  name: 'daily-moves',
  data () {
    return {
      store_day: this.$store.state.day,
      outgoings_header_arr: []
    }
  },
  methods: {
    async refresh_arrs() {
      this.outgoings_header_arr = await OutgoingsHeaderDB.getAll({day: this.store_day.iso})
    },
  },
  async mounted() {
    this.refresh_arrs()
  },
  components: {
  }
}
</script>

<style scoped lang="scss">

</style>

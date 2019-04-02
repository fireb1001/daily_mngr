<template>
  <section class="daily-moves bg-dailymoves p-3">
    <h2 class="text-center">كشف الحركة ليوم {{store_day.arab}}</h2>

        <br/>
      <div class="table-responsive">
        <table class="table table-striped table-sm pr-me">
          <thead>
            <tr>
              <th>التاريخ</th>
              <th>اسم العميل</th>
              <th>الصنف</th>
              <th>عدد المباع</th>
              <th>البياعة</th>
              <th>العمولة</th>
              <th>اجمالي</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in inc_header_arr" :key='idx'>
              <td>{{item.day}}</td>
              <td>{{item.supplier_name}}</td>
              <td>{{item.product_name}}</td>
              <td>{{item.total_count - item.current_count}}</td>
              <td>{{item.inc_total_sell_comm}}</td>
              <td>{{item.recp_comm}}</td>
              <td>{{item.inc_total_sell_comm + item.recp_comm}}</td>
              
            </tr>
          </tbody>
        </table>
      </div>

        <button class="btn btn-printo pr-hideme" @click="vue_window.print()">
          <span class="fa fa-print"></span> طباعة 
        </button>
  </section>
</template>

<script >

import { IncomingsHeaderDB } from '../db/IncomingsHeaderDB';

export default {
  name: 'daily-moves',
  data () {
    return {
      store_day: this.$store.state.day,
      inc_header_arr: []
    }
  },
  methods: {
    async refresh_arrs() {
      this.inc_header_arr = await IncomingsHeaderDB.getAll({day: this.store_day.iso})
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

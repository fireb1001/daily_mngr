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
              <th>عدد الطرود</th>
              <th>الاصناف</th>
              <th>عدد المباع</th>
              <th>عدد المتبقي</th>
              <th>اجمالي البياعة</th>
              <th>العمولة</th>
              <th>فرق الفاتورة</th>
              <th>اجمالي</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, idx) in daily_receipts" :key='idx'>
              <td>{{item.day}}</td>
              <td>{{item.supplier_name}}</td>
              <td>{{item.total_count}}</td>
              <td>{{item.products_arr | productsFilter }}</td>
              <td>{{item.total_count - item.total_current_rest}}</td>
              <td> 
                <span class="text-danger" v-if="item.total_current_rest">{{item.total_current_rest}}</span>
              </td>
              <td>{{item.total_sell_comm}}</td>
              <td>{{item.recp_comm | round2}}</td>
              <td >
                {{ item.out_sale_value - item.net_value }}
              </td>
              <td>{{item.total_sell_comm + item.recp_comm}}</td>
              
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
import { ReceiptsDB } from '../db/ReceiptsDB';

export default {
  name: 'daily-moves',
  data () {
    return {
      store_day: this.$store.state.day,
      daily_receipts: []
    }
  },
  methods: {
    async refresh_arrs() {
      this.daily_receipts = await ReceiptsDB.getAll({day: this.store_day.iso})
    },
  },
  async mounted() {
    this.refresh_arrs()
  },
  components: {
  }
}
</script>

<template>
  <section class="src-views-developer-tools m-1 p-3">
    <h1 class="m-3">نظام مدير اليومية</h1>
    <h2 class="text-danger"> اصدار رقم {{app_version}}</h2>
    <br/>
    <h3 class="text-danger" v-if="demo_till">* نسخة تجريبية حتي {{demo_till}}</h3>
    <h3 class="text-success" v-if="! demo_till">* نسخة مرخصة</h3>
    <!--1561990955
    <button class="btn btn-danger" type="button" @click="remove('daily')"> Remove Daily </button>
    <button class="btn btn-danger" type="button" @click="remove('all')"> Remove All </button>
    -->
    <button class="btn btn-primary m-2" type="button" @click="bk()"> 

 نسخ قاعدة البيانات 
    </button>
    <!--
    <router-link class="btn btn-primary m-2" to="/outhead_table">
      <span class="fa fa-dolly"></span>
      جدول اجماليات البيع 
    </router-link>
    -->

  </section>
</template>

<script >
import { AdminCTRL } from '../ctrl/AdminCTRL';
import { moment, db_config } from '../main'

const {app} = require('electron').remote
export default {
  name: 'src-views-developer-tools',
  data () {
    return {
      app_version: app.getVersion(),
      demo_till: ''
    }
  },
  async mounted() {
    let app_cnfg = await AdminCTRL.getShaderConfigs()
    if(app_cnfg['demo_till'].config_value !== "open") {
      this.demo_till = moment.unix(app_cnfg['demo_till'].config_value).format('LL')
    }
  },
  methods: {
    async remove(){
      /*
      if(what ==='daily')
        await AdminDB.removeDaily()
      else if (what === 'all')
        await AdminDB.removeAll()
      */
    },
    bk() {
      var exec = require('child_process').exec
      exec(`D:\\xampp\\mysql\\bin\\mysqldump.exe --user root ${db_config.database} | 7z a -si D:\\00_system_backup\\${db_config.database}-${Date.now()}.sql.7z`, (err)=>{
      //exec('D:\\laragon\\bin\\mysql\\mysql-5.7.24-winx64\\bin\\mysqldump.exe --user root daily_mngr > D:\\daily_mngr.sql', (err)=>{
        if (err) 
          console.error(`exec error: ${err}`)
        else 
          console.log(`DONE ! `)
      })
    }
  },
  components: {
  }
}
</script>

<style scoped lang="scss">

</style>

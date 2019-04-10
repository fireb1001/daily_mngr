<template>
  <section class="src-views-developer-tools m-1 p-3">
    <h1 class="m-3">نظام مدير اليومية</h1>
    <h2 class="text-danger"> اصدار رقم {{app_version}}</h2>
    <br/>
    <!--
    <button class="btn btn-danger" type="button" @click="remove('daily')"> Remove Daily </button>
    <button class="btn btn-danger" type="button" @click="remove('all')"> Remove All </button>
    -->
    <button class="btn btn-primary m-2" type="button" @click="bk()"> 

      عمل نسخة احتياطية  
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
import {AdminDB} from '../db/AdminDB.js'
const {app} = require('electron').remote

export default {
  name: 'src-views-developer-tools',
  data () {
    return {
      app_version: app.getVersion()
    }
  },
  firestore () {
    return {}
  },
  methods: {
    async remove(what){
      if(what ==='daily')
        await AdminDB.removeDaily()
      else if (what === 'all')
        await AdminDB.removeAll()
    },
    bk() {
      var exec = require('child_process').exec
      exec(`D:\\xampp\\mysql\\bin\\mysqldump.exe --user root daily_mngr | 7z a -si D:\\00_system_backup\\daily_mngr-${Date.now()}.sql.7z`, (err)=>{
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

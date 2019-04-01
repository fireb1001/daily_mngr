<template>
  <section class="src-views-developer-tools m-1">
    <br/>
    <button class="btn btn-danger" type="button" @click="remove('daily')"> Remove Daily </button>
    <button class="btn btn-danger" type="button" @click="remove('all')"> Remove All </button>
    <button class="btn btn-primary" type="button" @click="bk()"> bk </button>
  </section>
</template>

<script >
import {AdminDB} from '../db/AdminDB.js'


export default {
  name: 'src-views-developer-tools',
  data () {
    return {}
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
      exec('D:\\xampp\\mysql\\bin\\mysqldump.exe --user root daily_mngr > D:\\daily_bk_2.sql', (err)=>{
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

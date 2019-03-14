<template>
  <section class="src-views-developer-tools m-1">
    <br/>
    <button class="btn btn-danger" type="button" @click="remove_daily()"> Remove Daily </button>
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
    async remove_daily(){
      console.log('remove_daily')
      await AdminDB.removeDaily()
    }
  },
  components: {
  }
}
</script>

<style scoped lang="scss">

</style>

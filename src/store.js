import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    day: {}
  },
  mutations: {
    setDay (state, day) {
      state.day = day
    }
  },
  actions: {

  }
})

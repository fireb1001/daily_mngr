import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    day: {},
    shader_configs: []
  },
  mutations: {
    setDay (state, day) {
      state.day = day
    },
    setShaderConfigs (state, payload) {
      state.shader_configs = payload
    }
  },
  actions: {

  }
})

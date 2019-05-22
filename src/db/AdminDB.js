import {  conn_pool, appConfigs } from '../main'

export class AdminDB {

  static async getShaderConfigs(){
    let query = ` SELECT * FROM shader_configs where shader_name = '${appConfigs.shader_name}' `
    // console.log(query)
    let all = []
    let results = await conn_pool.query(query)
    results.forEach( item => { 
        all[item.config_name] = Object.assign({}, item)
    })
    return all
  }

  static async saveShaderConfig(){

  }

}
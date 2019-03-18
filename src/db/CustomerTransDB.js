// import { conn_pool } from '../main'
import { dexie } from '../main'

export class CustomerTransDAO {

  id
  day
  customer_id
  outgoing_id
  cashflow_id
  amount
  trans_type = ''
  debt_after = 0

  constructor(data) {
    Object.assign(this, data)
  }

  static get COLLECTING_DAO() {
    return {
      trans_type: 'collecting'
    }
  }

  parseTypes () {
    // this.total_count = parseInt(this.total_count)
  }
}

export class CustomerTransDB {

  static TABLE_NAME = 'customer_trans'

  static async saveById(id, payload) {
    return await dexie[this.TABLE_NAME].update(id, payload)
  }

  static async addNew(data) {
    delete data.id
    return await dexie[this.TABLE_NAME].add(data)
  }

  static async getAll(data) {
    let all = []
    if(data.customer_id) {
      all = await dexie[this.TABLE_NAME].where({customer_id: data.customer_id}).toArray()
      console.log(all)
    }
    else {
      all = await dexie[this.TABLE_NAME].toArray()
    }
    return all
  }
}